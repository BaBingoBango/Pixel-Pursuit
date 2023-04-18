//
//  ARViewContainer.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addCoaching()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
