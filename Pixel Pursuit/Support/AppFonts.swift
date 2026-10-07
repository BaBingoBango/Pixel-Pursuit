//
//  AppFonts.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI

extension Font {
    /// Roboto Mono (from Google Fonts), the typeface of every I.D.D.A. terminal. The font file lives in
    /// Fonts/ and is registered through the UIAppFonts key in the Info.plist.
    static func robotoMono(_ size: CGFloat) -> Font {
        .custom("RobotoMono-Regular", fixedSize: size)
    }

    /// Times New Roman, for the game's "printed page" moments. iOS ships this font, bold and italic faces included.
    static func timesNewRoman(_ size: CGFloat) -> Font {
        .custom("TimesNewRomanPSMT", fixedSize: size)
    }
}
