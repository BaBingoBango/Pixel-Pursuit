//
//  DispatchView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/2/23.
//

import SwiftUI

/// The root view. It shows whichever phase of the game the player is in and moves between them.
struct DispatchView: View {
    @State private var phase = GamePhase.powerSwitch

    var body: some View {
        ZStack {
            switch phase {
            case .powerSwitch:
                PowerSwitchView(onPowerOn: advance)
            case .initializing:
                InitializingView()
            case .bootup:
                BootupView()
            case .arInstructions:
                ARInstructionsView(onActivate: advance)
            case .game:
                GameView(onFinished: advance)
            case .finale:
                FinaleView()
            }
        }
        .task(id: phase) {
            // The "powering on" phases play out on their own; everything else waits for the player.
            guard phase.advancesAutomatically else { return }
            try? await Task.sleep(for: .seconds(3))
            if !Task.isCancelled {
                advance()
            }
        }
    }

    private func advance() {
        phase = phase.next
    }
}

#Preview(traits: .landscapeLeft) {
    DispatchView()
}
