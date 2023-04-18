//
//  ARCoachingServices.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import ARKit
import RealityKit

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.delegate = self
        
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        scene.anchors.append(try! PixelPursuit.loadOffice())
    }
}
