//
//  RealitySceneLoader.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import Foundation
import RealityKit

/// Loads the game's augmented-reality scenes from `Pixel Pursuit.reality`, the compiled Reality Composer file.
///
/// The editable Reality Composer projects live in the repository's "Reality Composer Projects" folder.
enum RealitySceneLoader {
    nonisolated enum LoadError: Error {
        /// `Pixel Pursuit.reality` isn't in the app bundle.
        case missingRealityFile
        /// The scene has no counterpart in the Reality file (only the coaching stage).
        case noRealityScene(ARSceneID)
    }

    /// The compiled Reality Composer file bundled with the app.
    static var realityFileURL: URL? {
        Bundle.main.url(forResource: "Pixel Pursuit", withExtension: "reality")
    }

    /// Loads a scene asynchronously and returns it as an anchor ready to add to an `ARView`'s scene.
    static func loadAnchor(for scene: ARSceneID) async throws -> AnchorEntity {
        guard let sceneName = scene.realitySceneName else {
            throw LoadError.noRealityScene(scene)
        }
        guard let fileURL = realityFileURL,
              var components = URLComponents(url: fileURL, resolvingAgainstBaseURL: false) else {
            throw LoadError.missingRealityFile
        }

        // A Reality file holds several scenes; the URL fragment picks one.
        components.fragment = sceneName
        guard let sceneURL = components.url else {
            throw LoadError.missingRealityFile
        }

        // Load as an anchor entity specifically: the generic `Entity` initializer drops the scene's anchoring,
        // which would leave the whole scene floating at the AR world origin instead of on the floor.
        return try await AnchorEntity(contentsOf: sceneURL)
    }
}
