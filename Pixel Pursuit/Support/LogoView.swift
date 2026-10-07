//
//  LogoView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI

/// One of the game's agency logos, drawn in solid red like everything else on the I.D.D.A.'s screens.
struct LogoView: View {
    let logo: ImageResource

    var body: some View {
        Image(logo)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(.red)
            .accessibilityHidden(true)
    }
}

#Preview {
    LogoView(logo: .iddaLogo)
        .frame(width: 200)
}
