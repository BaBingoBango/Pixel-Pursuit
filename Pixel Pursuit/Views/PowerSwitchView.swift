//
//  PowerSwitchView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/19/23.
//

import SwiftUI

/// An app view written in SwiftUI!
struct PowerSwitchView: View {
    
    // MARK: View Variables
    @Binding var sceneCode: Int
    let allOpacityTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var allOpacity = 0.0
    let powerButtonRedOpacityTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var powerButtonRedOpacity = 0.0
    @State var isPowerButtonRedOpacityIncreasing = true
    
    // MARK: View Body
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("computer forensics")
                .foregroundColor(.red)
                .fontWeight(.bold)
                .italic()
                .font(timesNewRomanFont(55))
                .padding(.top, 20)
            
            Text("the discipline that combines elements of law and computer science to collect and analyze data from computer systems, networks, wireless communications, and storage devices in a way that is admissible as evidence in a court of law")
                .font(timesNewRomanFont(30))
            
            Text("- U.S. Cybersecurity & Infrastructure Agency")
                .font(timesNewRomanFont(30))
                .italic()
            
            Spacer()
            
            HStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        sceneCode += 1
                    }) {
                        ZStack {
                            Image(systemName: "power.circle")
                                .fontWeight(.thin)
                                .font(.system(size: 125))
                                .foregroundColor(.primary)
                            
                            Image(systemName: "power.circle")
                                .fontWeight(.thin)
                                .font(.system(size: 125))
                                .foregroundColor(.red)
                                .opacity(powerButtonRedOpacity)
                        }
                    }
                    
                    Text("MAIN POWER ON")
                        .font(robotoMonoFont(35))
                }
                
                Spacer()
            }
            .onReceive(allOpacityTimer) { _ in
                allOpacity += 0.01
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
        .padding(.horizontal)
        .onReceive(powerButtonRedOpacityTimer) { _ in
            if isPowerButtonRedOpacityIncreasing {
                powerButtonRedOpacity += 0.05
            } else {
                powerButtonRedOpacity -= 0.05
            }
            
            if powerButtonRedOpacity >= 1.0 {
                isPowerButtonRedOpacityIncreasing = false
            }
            
            if powerButtonRedOpacity <= 0.0 {
                isPowerButtonRedOpacityIncreasing = true
            }
        }
        .opacity(allOpacity)
        .onAppear {
            // Play Clair de Lune! ❤️
            playAudio(fileName: "Clair de Lune", type: "mp3")
        }
        .onDisappear {
            // Stop, Debussy! ‼️
            stopAudio()
        }
    }
    
    // MARK: View Functions
    // Functions go here! :)
}

// MARK: View Preview
struct PowerSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        PowerSwitchView(sceneCode: .constant(0))
    }
}

// MARK: Support Views
// Support views go here! :)
