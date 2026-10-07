//
//  ScenePlacement.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 10/7/26.
//

import RealityKit
import simd

/// The math behind putting a scene on the floor.
nonisolated enum ScenePlacement {
    /// A floor transform at `position`, turned so the scene's front (its +Z axis) faces `viewer`.
    static func transform(at position: SIMD3<Float>, facing viewer: SIMD3<Float>) -> simd_float4x4 {
        let toViewer = viewer - position
        let yaw = atan2(toViewer.x, toViewer.z)
        let rotation = simd_quatf(angle: yaw, axis: [0, 1, 0])
        return Transform(scale: .one, rotation: rotation, translation: position).matrix
    }

    /// The translation of a transform, as a point.
    static func position(of transform: simd_float4x4) -> SIMD3<Float> {
        SIMD3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
}
