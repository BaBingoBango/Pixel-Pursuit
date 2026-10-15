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

    /// The actions offered by walking up to the tables in Amanda's disk, keyed by each table's entity name
    /// in the Reality Composer scene.
    static let tableActions: [String: GameAction] = [
        "Photos Table": .viewPhotos,
        "Desktop Table": .viewDesktop,
        "Web Table": .viewWebHistory,
        "Computer Table": .accessServer
    ]
}
