//
//  ARGameView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import ARKit
import Combine
import RealityKit
import SwiftUI
import os

/// The SwiftUI face of the game's augmented-reality view. One `ARView` and one AR session last for the whole
/// game: the coordinator runs the coaching overlay, lets the player put the scenes on the floor, and swaps
/// scenes in place as the story moves on, so the room never has to be scanned twice.
struct ARGameView: UIViewRepresentable {
    /// The scene to show. `.coaching` means nothing is loaded yet; the briefing table appears once the player places it.
    let scene: ARSceneID
    /// The scene that is actually on screen.
    @Binding var presentedScene: ARSceneID
    /// Where the game is in placing its scenes. The game sets this back to `.placing` to let the player move a scene.
    @Binding var placement: PlacementState
    /// The action offered to the player. Amanda's disk changes it as the player approaches its tables.
    @Binding var action: GameAction?

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let coordinator = context.coordinator
        coordinator.parent = self

        #if targetEnvironment(simulator)
        // The simulator has no camera or world tracking: render the scenes with a virtual camera instead.
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        coordinator.arView = arView
        coordinator.startSimulatorPreview()
        #else
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        coordinator.arView = arView
        coordinator.startSession()
        #endif

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        let coordinator = context.coordinator
        coordinator.parent = self
        coordinator.show(scene)
        coordinator.setPlacing(placement == .placing)
    }

    /// Owns everything that outlives a SwiftUI update: the AR session, coaching, placement, the loaded scene,
    /// and the proximity triggers in Amanda's disk.
    final class Coordinator: NSObject, @preconcurrency ARCoachingOverlayViewDelegate {
        var parent: ARGameView?
        weak var arView: ARView?

        /// The scene the game last asked for, so repeated SwiftUI updates don't reload it.
        private var requestedScene: ARSceneID?
        /// The scene anchor currently in the AR view.
        private var currentAnchor: AnchorEntity?
        /// Where the player put the scene on the floor. Every scene shares it.
        private var placementTransform: simd_float4x4?
        private var isPlacing = false

        private var loadTask: Task<Void, Never>?
        private var preloadTask: Task<Void, Never>?
        private var preloadedDiskTable: AnchorEntity?
        private var frameSubscription: (any Cancellable)?
        private let logger = Logger(subsystem: "Ethan-Marshall.Pixel-Pursuit", category: "ARGameView")

        /// A translucent red disc that shows where the next tap will put the scene.
        private lazy var reticle: ModelEntity = {
            var material = UnlitMaterial(color: .red)
            material.blending = .transparent(opacity: 0.35)
            let disc = ModelEntity(mesh: .generatePlane(width: 0.5, depth: 0.5, cornerRadius: 0.25), materials: [material])
            disc.isEnabled = false
            return disc
        }()

        /// Posted by RealityKit whenever a Reality Composer "Notify" behavior fires.
        private static let notifyActionName = Notification.Name("RealityKit.NotifyAction")

        override init() {
            super.init()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleNotifyAction(_:)),
                name: Self.notifyActionName,
                object: nil
            )
        }

        // MARK: - Session

        /// Starts world tracking with horizontal plane detection and the coaching overlay.
        func startSession() {
            guard let arView else { return }

            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            configuration.environmentTexturing = .automatic
            arView.session.run(configuration)

            let reticleAnchor = AnchorEntity(world: .zero)
            reticleAnchor.addChild(reticle)
            arView.scene.addAnchor(reticleAnchor)
            frameSubscription = arView.scene.subscribe(to: SceneEvents.Update.self) { [weak self] _ in
                self?.updateReticle()
            }

            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.cancelsTouchesInView = false
            arView.addGestureRecognizer(tap)

            let overlay = ARCoachingOverlayView()
            overlay.delegate = self
            overlay.session = arView.session
            overlay.goal = .horizontalPlane
            overlay.translatesAutoresizingMaskIntoConstraints = false
            arView.addSubview(overlay)
            NSLayoutConstraint.activate([
                overlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
                overlay.topAnchor.constraint(equalTo: arView.topAnchor),
                overlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
            ])
            overlay.setActive(true, animated: true)
        }

        /// Called when the coaching overlay goes away. The first time, the player has found their floor.
        func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
            guard placementTransform == nil else { return }
            preloadDiskTable()
            parent?.placement = .placing
        }

        #if targetEnvironment(simulator)
        /// Without tracking there's nothing to place: show the briefing table at the origin, seen from a virtual camera.
        func startSimulatorPreview() {
            guard let arView else { return }
            let camera = PerspectiveCamera()
            camera.look(at: .zero, from: [0, 1.6, 3], relativeTo: nil)
            let cameraAnchor = AnchorEntity(world: .zero)
            cameraAnchor.addChild(camera)
            arView.scene.addAnchor(cameraAnchor)

            placementTransform = matrix_identity_float4x4
            Task { @MainActor [weak self] in
                self?.parent?.placement = .placed
            }
            loadAndPresent(.diskTable)
        }
        #endif

        // MARK: - Placement

        /// Shows or hides the reticle. While it's showing, the next tap on the floor places the scene.
        func setPlacing(_ placing: Bool) {
            guard placing != isPlacing else { return }
            isPlacing = placing
            reticle.isEnabled = placing
        }

        private func updateReticle() {
            guard isPlacing, let arView else { return }
            let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
            guard let hit = floorHit(at: center) else {
                reticle.isEnabled = false
                return
            }
            reticle.isEnabled = true
            reticle.transform = Transform(matrix: placementTransform(for: hit))
        }

        @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard isPlacing, let arView, let hit = floorHit(at: recognizer.location(in: arView)) else { return }
            place(at: placementTransform(for: hit))
        }

        /// The floor under a point on screen. Prefers a plane ARKit knows is the floor, then any horizontal
        /// plane, then a plane estimate, so placement works on every iPad.
        private func floorHit(at point: CGPoint) -> simd_float4x4? {
            guard let arView else { return nil }
            let planes = arView.raycast(from: point, allowing: .existingPlaneGeometry, alignment: .horizontal)
            let floor = planes.first { ($0.anchor as? ARPlaneAnchor)?.classification == .floor }
            if let hit = floor ?? planes.first {
                return hit.worldTransform
            }
            return arView.raycast(from: point, allowing: .estimatedPlane, alignment: .horizontal).first?.worldTransform
        }

        /// A transform on the floor at `hit`, turned to face the player.
        private func placementTransform(for hit: simd_float4x4) -> simd_float4x4 {
            var position = ScenePlacement.position(of: hit)
            position.y += 0.005 // Sit a hair above the floor so the reticle doesn't fight with it.
            let viewer = arView?.cameraTransform.translation ?? .zero
            return ScenePlacement.transform(at: position, facing: viewer)
        }

        private func place(at transform: simd_float4x4) {
            placementTransform = transform
            setPlacing(false)
            parent?.placement = .placed

            if let currentAnchor, let arView {
                // Moving the scene that's already out: re-anchor it where the player tapped.
                arView.scene.removeAnchor(currentAnchor)
                currentAnchor.anchoring = AnchoringComponent(.world(transform: transform))
                arView.scene.addAnchor(currentAnchor)
            } else {
                loadAndPresent(.diskTable)
            }
        }

        // MARK: - Scenes

        /// Shows a scene in place of the current one, at the spot the player chose.
        func show(_ scene: ARSceneID) {
            guard scene != requestedScene else { return }
            requestedScene = scene
            guard scene != .coaching else { return }
            loadAndPresent(scene)
        }

        private func preloadDiskTable() {
            guard preloadTask == nil else { return }
            preloadTask = Task { [weak self] in
                guard let self else { return }
                do {
                    preloadedDiskTable = try await RealitySceneLoader.loadAnchor(for: .diskTable)
                } catch {
                    logger.error("Couldn't preload the disk table scene: \(String(describing: error), privacy: .public)")
                }
            }
        }

        private func loadAndPresent(_ scene: ARSceneID) {
            loadTask?.cancel()
            loadTask = Task { [weak self] in
                guard let self else { return }
                do {
                    let anchor: AnchorEntity
                    if scene == .diskTable, let preloaded = await preloadedDiskTableIfAvailable() {
                        anchor = preloaded
                    } else {
                        anchor = try await RealitySceneLoader.loadAnchor(for: scene)
                    }
                    guard !Task.isCancelled, let arView, let placementTransform else { return }

                    // The file anchors each scene to "any horizontal plane"; pin it to the spot the player chose instead.
                    anchor.anchoring = AnchoringComponent(.world(transform: placementTransform))
                    if let currentAnchor {
                        arView.scene.removeAnchor(currentAnchor)
                    }
                    arView.scene.addAnchor(anchor)
                    currentAnchor = anchor
                    parent?.presentedScene = scene
                } catch {
                    logger.error("Couldn't load the \(scene.rawValue, privacy: .public) scene: \(String(describing: error), privacy: .public)")
                }
            }
        }

        private func preloadedDiskTableIfAvailable() async -> AnchorEntity? {
            await preloadTask?.value
            defer { preloadedDiskTable = nil }
            return preloadedDiskTable
        }

        // MARK: - Proximity triggers

        @objc private func handleNotifyAction(_ notification: Notification) {
            guard let parent, parent.scene == .disk,
                  let arView,
                  let userInfo = notification.userInfo,
                  let scene = userInfo["RealityKit.NotifyAction.Scene"] as? RealityKit.Scene, scene === arView.scene,
                  let identifier = userInfo["RealityKit.NotifyAction.Identifier"] as? String,
                  let action = GameAction(notifyActionIdentifier: identifier) else {
                return
            }
            parent.action = action
        }
    }
}
