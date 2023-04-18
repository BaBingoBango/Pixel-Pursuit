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
    
    /// Generates the view for first use.
    /// - Parameter context: The system-provided context.
    /// - Returns: An `ARView` to use in SwiftUI.
    func makeUIView(context: Context) -> ARView {
        
        // Present AR coaching!
        let arView = ARView(frame: .zero)
        arView.addCoaching()
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
        coachingOverlay.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        coachingOverlay.activatesAutomatically = true
        
        // Coaching settings!
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
        
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
        scene.anchors.removeAll()
        scene.addAnchor(try! PixelPursuit.loadDisktable())
        ARsceneID = .diskTable
    }
    
    /// Transitions the view to the office scene.
    func showOfficeScene() {
        scene.anchors.removeAll()
        scene.addAnchor(try! PixelPursuit.loadOffice())
        ARsceneID = .office
    }
}
