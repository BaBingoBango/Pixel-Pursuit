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
        // Full size when it fits, smaller logos and tighter spacing when the screen is short (an iPad mini in
        // landscape), and a scrolling page only as a last resort. The fade is applied inside `warning` rather
        // than here: the scroll view is UIKit-backed, and UIKit ignores taps on a view while its opacity animates.
        GeometryReader { geometry in
            ViewThatFits(in: .vertical) {
                warning(compact: false)
                warning(compact: true)
                ScrollView {
                    warning(compact: true)
                        .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .border(.red.opacity(contentOpacity), width: 3)
        .padding()
        .background {
            // A background rather than a sibling, so the static can never dictate the screen's size.
            AnimatedImageView(assetName: "staticGIF")
                .overlay(Color.red.opacity(0.5))
                .opacity(0.1 * contentOpacity)
                .scaleEffect(1.2)
                .ignoresSafeArea()
        }
        .onAppear {
            GameAudio.playLooping("static sound effect")
            withAnimation(.linear(duration: 4)) {
                contentOpacity = 1
            }
        }
        .onDisappear {
            // The game is starting: swap the static for the investigation's soundtrack.
            GameAudio.stop()
            GameAudio.playLooping("Retro Funk")
        }
    }

    /// The warning itself. The compact form keeps the type sizes and shrinks only the logos and the spacing.
    private func warning(compact: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()

                LogoView(logo: .iddaLogo)
                    .padding()
                    .frame(maxWidth: compact ? 130 : 200)

                Spacer(minLength: 20)
                    .frame(maxWidth: 200)

                LogoView(logo: .eotLogo)
                    .padding()
                    .frame(maxWidth: compact ? 130 : 200)

                Spacer()
            }

            // Wrapped text keeps its full height here: inside ViewThatFits a Text can otherwise be handed a
            // single line and truncate.
            Text("System Access Warning".uppercased())
                .foregroundStyle(.red)
                .font(.robotoMono(75))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Text("This is a system for investigating cyber crimes. Only authorized IDDA agents and approved contractors are allowed to access it, under penalty of international law.")
                .font(.robotoMono(25))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text("Before activating, please ensure you have a floor space suitable for medium-to-large(ish) augmented reality activities - good luck! :)")
                .font(.robotoMono(25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(compact ? 6 : 16)
                .padding(.top, compact ? 6 : 16)

            Text("AR TIP: Once the floor scan finishes, point at some open floor and tap to place the scene. MOVE SCENE lets you put it somewhere else any time!")
                .foregroundStyle(.red)
                .font(.robotoMono(25))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(compact ? 6 : 16)
                .padding(.top, compact ? 10 : 30)

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
