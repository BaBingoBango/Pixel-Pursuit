//
//  FinaleView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/19/23.
//

import SwiftUI

/// The end of the investigation: the player gives their verdict and gets a thank-you note.
struct FinaleView: View {
    @State private var isShowingFinalMessage = false
    @State private var contentOpacity = 0.0

    var body: some View {
        ViewThatFits(in: .vertical) {
            content
            ScrollView {
                content
            }
        }
        .padding()
        .onAppear {
            // Play Clair de Lune again! ❤️
            GameAudio.playLooping("Clair de Lune")
            withAnimation(.linear(duration: 10)) {
                contentOpacity = 1
            }
        }
    }

    // The fade lives on the content rather than on the container above: its scrolling fallback is
    // UIKit-backed, and UIKit ignores taps on a view while its opacity animates.
    private var content: some View {
        VStack {
            if !isShowingFinalMessage {
                HStack {
                    Text("IDDA Agent:")
                        .font(.timesNewRoman(45))
                        .fontWeight(.bold)

                    Spacer()
                }

                HStack {
                    Text("In your expert opinion, what do you think in the case of Amanda Becker?")
                        .font(.timesNewRoman(35))
                        .italic()

                    Spacer()
                }
                .padding(.bottom, 30)

                // Whatever the player chooses, the ending is the same: the point is that it's complicated.
                verdictButton("GUILTY!")
                verdictButton("NOT GUILTY!")
                verdictButton("IT'S COMPLICATED...")
            } else {
                HStack {
                    Text("Whatever you chose, computer forensics is a complicated field. While investigators don't actually do the convicting, the responsibility is great and a little scary...")
                        .font(.timesNewRoman(35))
                        .italic()

                    Spacer()
                }

                Text("THANKS FOR\nPLAYING!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.red)
                    .font(.timesNewRoman(85))
                    .fontWeight(.bold)
                    .padding(.vertical, 30)

                HStack {
                    Text("- IDDA Headquarters, Amanda, and Me! :)\n\nHappy WWDC!")
                        .font(.timesNewRoman(35))
                        .italic()
                        .foregroundStyle(.red)

                    Spacer()
                }
            }
        }
        .opacity(contentOpacity)
    }

    private func verdictButton(_ title: String) -> some View {
        Button {
            isShowingFinalMessage = true
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .font(.robotoMono(25))
                .frame(maxWidth: 350)
                .frame(height: 75)
                .background(Color.red)
        }
    }
}

#Preview(traits: .landscapeLeft) {
    FinaleView()
}
