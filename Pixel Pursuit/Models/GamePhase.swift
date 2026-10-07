//
//  GamePhase.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/2/23.
//

/// The phases of a play session, in order. The dispatch view shows one phase at a time.
nonisolated enum GamePhase: Int, CaseIterable {
    /// The "main power" title screen, set to Clair de Lune.
    case powerSwitch
    /// The I.D.D.A. system is "powering on".
    case initializing
    /// A wall of boot log text races past.
    case bootup
    /// The system access warning, which doubles as the AR setup instructions.
    case arInstructions
    /// The augmented-reality investigation itself.
    case game
    /// The verdict and the thank-you note.
    case finale

    /// The phase that follows this one. The finale is the end of the line.
    var next: GamePhase {
        GamePhase(rawValue: rawValue + 1) ?? .finale
    }

    /// Whether the game moves on from this phase by itself after a few seconds.
    var advancesAutomatically: Bool {
        switch self {
        case .initializing, .bootup: true
        default: false
        }
    }
}
