//
//  PowerSwitchView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/19/23.
//

import SwiftUI

/// The title screen: a definition of computer forensics and a big power button that starts the game.
struct PowerSwitchView: View {
    /// Called when the player presses the power button.
    let onPowerOn: () -> Void

    @State private var contentOpacity = 0.0
    @State private var isPowerLightPulsing = false

    var body: some View {
        ViewThatFits(in: .vertical) {
            content
            ScrollView {
                content
            }
        }
        .padding(.horizontal)
        .onAppear {
            // Play Clair de Lune! ❤️
            GameAudio.playLooping("Clair de Lune")
            withAnimation(.linear(duration: 10)) {
                contentOpacity = 1
            }
            isPowerLightPulsing = true
        }
        .onDisappear {
            // Stop, Debussy! ‼️
            GameAudio.stop()
        }
    }

    // The fade lives on the content rather than on the container above: its scrolling fallback is
    // UIKit-backed, and UIKit ignores taps on a view while its opacity animates.
    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("computer forensics")
                .foregroundStyle(.red)
                .fontWeight(.bold)
                .italic()
                .font(.timesNewRoman(55))
                .padding(.top, 20)

            Text("the discipline that combines elements of law and computer science to collect and analyze data from computer systems, networks, wireless communications, and storage devices in a way that is admissible as evidence in a court of law")
                .font(.timesNewRoman(30))

            Text("- U.S. Cybersecurity & Infrastructure Agency")
                .font(.timesNewRoman(30))
                .italic()

            Spacer()

            HStack {
                Spacer()

                VStack {
                    Button(action: onPowerOn) {
                        ZStack {
                            Image(systemName: "power.circle")
                                .font(.system(size: 125, weight: .thin))
                                .foregroundStyle(.primary)

                            Image(systemName: "power.circle")
                                .font(.system(size: 125, weight: .thin))
                                .foregroundStyle(.red)
                                .opacity(isPowerLightPulsing ? 1 : 0)
                                .animation(.linear(duration: 2).repeatForever(autoreverses: true), value: isPowerLightPulsing)
                        }
                    }
                    .accessibilityLabel("Main power on")

                    Text("MAIN POWER ON")
                        .font(.robotoMono(35))
                }

                Spacer()
            }

            Spacer()

            HStack {
                Image(systemName: "bell.and.waves.left.and.right.fill")
                    .font(.system(size: 50))

                VStack(alignment: .leading) {
                    Text("Please turn on your audio for the best experience!")
                        .font(.system(size: 30))
                        .fontWeight(.bold)

                    Text("You should hear some pretty piano music ❤️")
                        .font(.system(size: 20))
                }
                .padding(.leading)
            }
        }
        .opacity(contentOpacity)
    }
}

#Preview(traits: .landscapeLeft) {
    PowerSwitchView(onPowerOn: {})
}
