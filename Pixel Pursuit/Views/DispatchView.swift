//
//  DispatchView.swift
//  Mission Overflow
//
//  Created by Ethan Marshall on 4/2/23.
//

import SwiftUI

/// The root view for the app. It dispatches out to all other views!
struct DispatchView: View {
    
    // MARK: View Variables
    @State var sceneCode = 1
    let viewSwitchTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    // MARK: View Body
    var body: some View {
        Group {
            if sceneCode == 1 {
                InitalizingView()
            } else if sceneCode == 2 {
                BootupView()
            } else if sceneCode == 3 {
                ARInstructionsView(sceneCode: $sceneCode)
            } else {
                GameView()
            }
        }
        .onReceive(viewSwitchTimer) { _ in
            if sceneCode <= 2 {
                sceneCode += 1
            }
        }
    }
    
    // MARK: View Functions
    // Functions go here! :)
}

// MARK: View Preview
struct DispatchView_Previews: PreviewProvider {
    static var previews: some View {
        DispatchView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

// MARK: Support Views
// Support views go here! :)
