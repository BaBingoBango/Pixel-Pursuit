//
//  InitalizingView.swift
//  Mission Overflow
//
//  Created by Ethan Marshall on 4/2/23.
//

import SwiftUI

/// The first screen of the game. Makes "calls" to bootup the "system".
struct InitalizingView: View {
    
    // MARK: View Variables
    @State var initalizingText = [
        "Connecting...",
        "Booting Subsystem..."
    ]
    let initalizingTextUpdateTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var currentInitalizingText = "Powering On..."
    
    // MARK: View Body
    var body: some View {
        ZStack {
            Group {
                Text(currentInitalizingText.uppercased())
                    .font(robotoMonoFont(40))
                    .foregroundColor(.red)
            }
            .padding(40)
            .border(.red, width: 3)
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    Text("International Digital Defense Authority\nMission Communication Subsystem\nSerial No. WWDC2023\nVer. 6.5.23".uppercased())
                        .font(robotoMonoFont(12.5))
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(.red)
                        .mask(
                            Image("IDDA logo")
                                .resizable()
                        )
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 150)
                }
            }
            .padding(.horizontal)
        }
        .onReceive(initalizingTextUpdateTimer) { _ in
            if !initalizingText.isEmpty {
                currentInitalizingText = initalizingText.remove(at: 0)
            }
        }
    }
    
    // MARK: View Functions
    // Functions go here! :)
}

// MARK: View Preview
struct InitalizingView_Previews: PreviewProvider {
    static var previews: some View {
        InitalizingView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

// MARK: Support Views
// Support views go here! :)
