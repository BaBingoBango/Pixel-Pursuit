//
//  InitializingView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/2/23.
//

import SwiftUI

/// The first screen after power-on. The I.D.D.A. system "calls" its subsystems to boot.
struct InitializingView: View {
    private static let statusMessages = ["Powering On...", "Connecting...", "Booting Subsystem..."]

    @State private var statusIndex = 0

    var body: some View {
        ZStack {
            Text(Self.statusMessages[statusIndex].uppercased())
                .font(.robotoMono(40))
                .foregroundStyle(.red)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(40)
                .border(.red, width: 3)

            VStack {
                Spacer()

                HStack(alignment: .bottom) {
                    Text("International Digital Defense Authority\nMission Communication Subsystem\nSerial No. WWDC2023\nVer. 6.5.23".uppercased())
                        .font(.robotoMono(12.5))
                        .foregroundStyle(.red)

                    Spacer()

                    LogoView(logo: .iddaLogo)
                        .frame(width: 150)
                }
            }
            .padding(.horizontal)
        }
        .task {
            while statusIndex < Self.statusMessages.count - 1 {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { return }
                statusIndex += 1
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    InitializingView()
}
