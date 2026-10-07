//
//  ARSceneID.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

/// The augmented-reality scenes that make up the game, in the order the player meets them.
nonisolated enum ARSceneID: String, CaseIterable {
    /// The AR coaching stage. Nothing is loaded until the player has found a floor.
    case coaching
    /// Agent W's briefing table, holding Amanda's encrypted disk.
    case diskTable = "disktable"
    /// Amanda's home office, where her disk password is hiding.
    case office
    /// Inside Amanda's hard drive: four tables, four leads.
    case disk
    /// Amanda's photo library.
    case photos
    /// The files Amanda left on her desktop.
    case desktop
    /// Amanda's web history.
    case webHistory = "history"
    /// Amanda's secret server, where the stolen data lives.
    case secretServer = "server"

    /// The name of the matching scene in `Pixel Pursuit.reality`, or `nil` for the coaching stage.
    var realitySceneName: String? {
        self == .coaching ? nil : rawValue
    }
}
