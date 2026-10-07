//
//  Dialogue.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

/// Agent W's lines, scene by scene. The game steps through each list one tap at a time.
nonisolated enum Dialogue {
    static let diskTable: [String] = [
        "Connecting...",
        "Hello? Can you hear me?",
        "Hello, Agent! So glad you could make it here to help us.",
        "We're chasing one Amanda Becker, suspected of hacking the IDDA and stealing extremely sensitive information!",
        "We'd like to do computer forensics on her machine here, but her disk is encrypted.",
        "If you can, look around Amanda's office for anywhere her disk password might be hidden!",
        "Good luck, Agent! The IDDA thanks you!"
    ]

    static let office: [String] = [
        "This is Amanda's home office! Look around for a password for her hard disk.",
        "Excellent work! Now we can dive into Amanda's hard drive.",
        "Are you ready, Agent? Amanda's secrets await!"
    ]

    static let disk: [String] = [
        "Here we are inside Amanda's files! Feel free to take a look around.",
        "We have word that Amanda's been using a secret server to house the data she steals.",
        "If you can find anything on that, we'll be golden!",
        "Look around the different folders and approach the computer if you think you have something.",
        "Amazing work!! It looks like we're ready to access Amanda's secret server.",
        "Time to see what this thief stole from the IDDA!"
    ]

    static let photos: [String] = [
        "Here's Amanda's photos! I wonder what sort of camera these were taken with..."
    ]

    static let desktop: [String] = [
        "Amanda seems to have left some important files on her desktop...see anything we can use?"
    ]

    static let webHistory: [String] = [
        "Ah, search history! Check for any clues to her secret website...or favorite animals?"
    ]

    static let secretServer: [String] = [
        "We made it! Decide about Amanda and then tap to report your findings to the IDDA!"
    ]

    /// The lines for a scene. The coaching stage shares the disk table's lines, since that's where it leads.
    static func lines(for scene: ARSceneID) -> [String] {
        switch scene {
        case .coaching, .diskTable: diskTable
        case .office: office
        case .disk: disk
        case .photos: photos
        case .desktop: desktop
        case .webHistory: webHistory
        case .secretServer: secretServer
        }
    }
}
