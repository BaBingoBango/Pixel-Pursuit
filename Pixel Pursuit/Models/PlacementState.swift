//
//  PlacementState.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 10/7/26.
//

/// Where the game is in putting its scenes on the real floor.
nonisolated enum PlacementState {
    /// The coaching overlay is helping the player find a floor.
    case scanning
    /// A reticle follows the floor; the next tap places (or moves) the scene there.
    case placing
    /// The scene is on the floor and the game is on.
    case placed
}
