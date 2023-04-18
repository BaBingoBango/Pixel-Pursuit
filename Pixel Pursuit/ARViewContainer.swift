//
//  ARViewContainer.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let officeAnchor = try! PixelPursuit.loadOffice()
        arView.scene.anchors.append(officeAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
