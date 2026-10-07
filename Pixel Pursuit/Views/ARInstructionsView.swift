//
//  ARInstructionsView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/2/23.
//

import SwiftUI

/// The I.D.D.A.'s system access warning, which doubles as the instructions for setting up the AR play space.
struct ARInstructionsView: View {
    /// Called when the player activates the system.
    let onActivate: () -> Void

    @State private var contentOpacity = 0.0

    var body: some View {
        ZStack {
            AnimatedImageView(assetName: "staticGIF")
                .overlay(Color.red.opacity(0.5))
                .opacity(0.1 * contentOpacity)
                .scaleEffect(1.2)
                .ignoresSafeArea()

            // The fade is applied inside `warning` rather than to this container: the scrolling fallback is
            // UIKit-backed, and UIKit ignores taps on a view while its opacity animates.
            ViewThatFits(in: .vertical) {
                warning
                ScrollView {
                    warning
                }
            }
            .padding()
            .border(.red.opacity(contentOpacity), width: 3)
        }
        .padding()
        .onAppear {
            GameAudio.playLooping("static sound effect")
            withAnimation(.linear(duration: 10)) {
                contentOpacity = 1
            }
        }
        .onDisappear {
            // The game is starting: swap the static for the investigation's soundtrack.
            GameAudio.stop()
            GameAudio.playLooping("Retro Funk")
        }
    }

    private var warning: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()

                LogoView(logo: .iddaLogo)
                    .padding()
                    .frame(maxWidth: 200)

                Spacer(minLength: 20)
                    .frame(maxWidth: 200)

                LogoView(logo: .eotLogo)
                    .padding()
                    .frame(maxWidth: 200)

                Spacer()
            }

            Text("System Access Warning".uppercased())
                .foregroundStyle(.red)
                .font(.robotoMono(75))
                .multilineTextAlignment(.center)

            Spacer()

            Text("This is a system for investigating cyber crimes. Only authorized IDDA agents and approved contractors are allowed to access it, under penalty of international law.")
                .font(.robotoMono(25))
                .multilineTextAlignment(.center)

            Text("Before activating, please ensure you have a floor space suitable for medium-to-large(ish) augmented reality activities - good luck! :)")
                .font(.robotoMono(25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
                .padding(.top)

            Text("AR SCANNING TIP: Look at the space you want to play in, then walk there after the game environment has loaded!")
                .foregroundStyle(.red)
                .font(.robotoMono(25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
                .padding(.top, 30)

            Spacer()

            HStack {
                Text(">>>")
                    .font(.robotoMono(50))
                    .foregroundStyle(.red)

                Button(action: onActivate) {
                    Text("Activate System".uppercased())
                        .font(.robotoMono(30))
                        .foregroundStyle(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: 352)
                        .frame(height: 75)
                        .background(Color.red)
                }

                Text("<<<")
                    .font(.robotoMono(50))
                    .foregroundStyle(.red)
            }
            .padding(.bottom)
        }
        .opacity(contentOpacity)
    }
}

#Preview(traits: .landscapeLeft) {
    ARInstructionsView(onActivate: {})
}
