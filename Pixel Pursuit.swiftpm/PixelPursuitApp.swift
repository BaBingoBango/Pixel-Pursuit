//
//  PixelPursuitApp.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import UIKit
import SwiftUI

@main
struct PixelPursuitApp: App {
    var body: some Scene {
        WindowGroup {
            // MARK: App Entry Point
            DispatchView()
        }
    }
}

// MARK: Global Variables
/// The AR scene that should currently be presented.
var ARsceneID = ARSceneID.coaching

// MARK: App Fonts
/// The Roboto Mono font, downloaded from Google Fonts.
func robotoMonoFont(_ size: Double) -> Font {
    let fontURL = Bundle.main.url(forResource: "RobotoMono", withExtension: "ttf")! as CFURL
    CTFontManagerRegisterFontsForURL(fontURL, CTFontManagerScope.process, nil)
    return Font(UIFont(name: "Roboto Mono", size:  size)!)
}
