//
//  ARGameView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import ARKit
import RealityKit
import SwiftUI
import os

/// The SwiftUI face of the game's augmented-reality view. It hosts a RealityKit `ARView`, runs the AR coaching
/// overlay, and loads the requested scene from the game's Reality Composer file.
///
/// The game recreates this view (through `.id`) whenever it moves to a different scene, so every scene starts
/// with a fresh AR session, just as the game has always done.
struct ARGameView: UIViewRepresentable {
    /// The scene to show. `.coaching` runs the coaching overlay and then loads the disk table scene by itself.
    let scene: ARSceneID
    /// The scene that is actually on screen.
    @Binding var presentedScene: ARSceneID
    /// The action offered to the player. Amanda's disk changes it as the player approaches its tables.
    @Binding var action: GameAction?

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        #if targetEnvironment(simulator)
        // The simulator has no camera or world tracking, so render the scene with a virtual camera instead.
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        #else
        let arView = ARView(frame: .zero)
        #endif

        context.coordinator.parent = self
        context.coordinator.arView = arView

        if scene == .coaching {
            context.coordinator.startCoaching()
        } else {
            context.coordinator.present(scene)
        }
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Keep the coordinator's bindings current.
        context.coordinator.parent = self
    }

    /// Owns the AR view's behavior: coaching, scene loading, and the proximity triggers in Amanda's disk.
    final class Coordinator: NSObject, @preconcurrency ARCoachingOverlayViewDelegate {
        var parent: ARGameView?
        weak var arView: ARView?

        private var loadTask: Task<Void, Never>?
        private let logger = Logger(subsystem: "Ethan-Marshall.Pixel-Pursuit", category: "ARGameView")

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

        /// Shows the coaching overlay until the player has found a horizontal surface, then loads the disk table scene.
        func startCoaching() {
            #if targetEnvironment(simulator)
            // There's nothing to coach without world tracking: go straight to the first scene.
            present(.diskTable)
            #else
            guard let arView else { return }

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
            #endif
        }

        /// Called when the coaching overlay goes away: the player has found their floor.
        func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
            present(.diskTable)
        }

        /// Replaces whatever is in the AR view with the given scene.
        func present(_ scene: ARSceneID) {
            loadTask?.cancel()
            loadTask = Task { [weak self] in
                guard let self else { return }
                do {
                    let anchor = try await RealitySceneLoader.loadAnchor(for: scene)
                    guard !Task.isCancelled, let arView else { return }

                    arView.scene.anchors.removeAll()
                    #if targetEnvironment(simulator)
                    // Without plane detection, pin the scene to the world origin and look at it from a virtual camera.
                    anchor.anchoring = AnchoringComponent(.world(transform: matrix_identity_float4x4))
                    arView.scene.addAnchor(Self.makeSimulatorCamera())
                    #endif
                    arView.scene.addAnchor(anchor)
                    parent?.presentedScene = scene
                } catch {
                    logger.error("Couldn't load the \(scene.rawValue, privacy: .public) scene: \(String(describing: error), privacy: .public)")
                }
            }
        }

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

        #if targetEnvironment(simulator)
        private static func makeSimulatorCamera() -> AnchorEntity {
            let camera = PerspectiveCamera()
            camera.look(at: .zero, from: [0, 1.6, 3], relativeTo: nil)
            let cameraAnchor = AnchorEntity(world: .zero)
            cameraAnchor.addChild(camera)
            return cameraAnchor
        }
        #endif
    }
}
