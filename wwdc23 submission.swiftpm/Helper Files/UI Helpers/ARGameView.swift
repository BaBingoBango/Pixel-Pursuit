//
//  ARGameView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI
import RealityKit
import ARKit

/// A SwiftUI view that shows the camera. Mostly though, it renders and controls AR content!
struct ARGameView: UIViewRepresentable {
    
    var scene: ARSceneID
    @Binding var actionButtonMessage: String
    
    /// Generates the view for first use.
    /// - Parameter context: The system-provided context.
    /// - Returns: An `ARView` to use in SwiftUI.
    func makeUIView(context: Context) -> ARView {
        
        // Create an AR view!
        let arView = ARView(frame: .zero)
        
        switch scene {
        case .coaching:
            arView.addCoaching()
        case .diskTable:
            arView.showDiskTableScene()
        case .office:
            arView.showOfficeScene()
        case .disk:
            
            // Transitioning is done here due to use of actionButtonMessage!
            // First, load the scene!
            let diskSceneAnchor = try! PixelPursuit.loadDisk()
            
            // Add behavior handlers!
            diskSceneAnchor.actions.approachPhotosTable.onAction = { _ in
                actionButtonMessage = "view photos"
            }
            diskSceneAnchor.actions.approachDesktopTable.onAction = { _ in
                actionButtonMessage = "view desktop"
            }
            diskSceneAnchor.actions.approachWebTable.onAction = { _ in
                actionButtonMessage = "view web history"
            }
            diskSceneAnchor.actions.approachComputerTable.onAction = { _ in
                actionButtonMessage = "access server"
            }
            
            arView.scene.anchors.removeAll()
            arView.scene.addAnchor(diskSceneAnchor)
            ARsceneID = .disk
            
        case .photos:
            arView.showPhotosScene()
        case .desktop:
            arView.showDesktopScene()
        case .webHistory:
            arView.showWebScene()
        case .secretServer:
            arView.showServerScene()
        }
        
        return arView
    }
    
    /// Updates the view. (this function is unused in this project)
    func updateUIView(_ uiView: ARView, context: Context) {}
}

extension ARView: ARCoachingOverlayViewDelegate {
    
    /// Shows the AR coaching prompts to the user.
    func addCoaching() {
        
        // Create the overlay!
        let coachingOverlay = ARCoachingOverlayView()
        
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.setActive(true, animated: true)
        
        // Bang! Present it!
        self.addSubview(coachingOverlay)
    }
    
    /// Called when the user completes the AR coaching prompts.
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // When the coaching ends, switch to the disk table scene!
        showDiskTableScene()
    }
}

extension ARView {
    /// Transitions the view to the disk table scene.
    func showDiskTableScene() {
        // Get the anchor!
        let diskTableSceneAnchor = try! PixelPursuit.loadDisktable()
        
        scene.anchors.removeAll()
        scene.addAnchor(diskTableSceneAnchor)
        ARsceneID = .diskTable
    }
    
    /// Transitions the view to the office scene.
    func showOfficeScene() {
        scene.anchors.removeAll()
        scene.addAnchor(try! PixelPursuit.loadOffice())
        ARsceneID = .office
    }
    
    /// Transitions the view to the photos scene.
    func showPhotosScene() {
        scene.anchors.removeAll()
        scene.addAnchor(try! PixelPursuit.loadPhotos())
        ARsceneID = .photos
    }
    
    /// Transitions the view to the desktop scene.
    func showDesktopScene() {
        scene.anchors.removeAll()
        scene.addAnchor(try! PixelPursuit.loadDesktop())
        ARsceneID = .desktop
    }
    
    /// Transitions the view to the web scene.
    func showWebScene() {
        scene.anchors.removeAll()
        scene.addAnchor(try! PixelPursuit.loadHistory())
        ARsceneID = .webHistory
    }
    
    /// Transitions the view to the server scene.
    func showServerScene() {
        scene.anchors.removeAll()
        scene.addAnchor(try! PixelPursuit.loadServer())
        ARsceneID = .secretServer
    }
}
