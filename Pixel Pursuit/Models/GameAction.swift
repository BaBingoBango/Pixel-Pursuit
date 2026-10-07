//
//  GameAction.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

/// Everything the game's single action button can do. The raw value is the label the player sees,
/// so the button's text and the game's logic can never drift apart.
nonisolated enum GameAction: String {
    case advanceText = "tap to advance text"
    case searchOffice = "search amanda's office"
    case decryptDisk = "decrypt disk"
    case searchDisk = "search amanda's disk"
    case viewPhotos = "view photos"
    case viewDesktop = "view desktop"
    case viewWebHistory = "view web history"
    case accessServer = "access server"
    case exitPhotos = "exit photos"
    case exitDesktop = "exit desktop"
    case exitWebHistory = "exit web history"
    case enterServer = "enter amanda's server"
    case exitServer = "exit server"

    /// The action offered when the player walks up to a table in Amanda's disk, keyed by the
    /// identifier of the "Notify" behavior that fires in the Reality Composer scene.
    init?(notifyActionIdentifier identifier: String) {
        switch identifier {
        case "Approach Photos Table": self = .viewPhotos
        case "Approach Desktop Table": self = .viewDesktop
        case "Approach Web Table": self = .viewWebHistory
        case "Approach Computer Table": self = .accessServer
        default: return nil
        }
    }
}
