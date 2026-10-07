//
//  PixelPursuitApp.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI

/// The app's entry point. Everything starts at the dispatch view, which walks the player through the game's phases.
@main
struct PixelPursuitApp: App {
    var body: some Scene {
        WindowGroup {
            DispatchView()
                .statusBarHidden()
        }
    }
}
