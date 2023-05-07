//
//  FinaleView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/19/23.
//

import SwiftUI

/// An app view written in SwiftUI!
struct FinaleView: View {
    
    // MARK: View Variables
    @State var showingFinalMessage = false
    let allOpacityTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var allOpacity = 0.0
    
    // MARK: View Body
    var body: some View {
        VStack {
            if !showingFinalMessage {
                HStack {
                    Text("IDDA Agent:")
                        .font(timesNewRomanFont(45))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                
                HStack {
                    Text("In your expert opinion, what do you think in the case of Amanda Becker?")
                        .font(timesNewRomanFont(35))
                        .italic()
                    
                    Spacer()
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    showingFinalMessage = true
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: 350, height: 75)
                        
                        Text("GUILTY!")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(robotoMonoFont(25))
                    }
                }
                
                Button(action: {
                    showingFinalMessage = true
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: 350, height: 75)
                        
                        Text("NOT GUILTY!")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(robotoMonoFont(25))
                    }
                }
                
                Button(action: {
                    showingFinalMessage = true
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: 350, height: 75)
                        
                        Text("IT'S COMPLICATED...")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(robotoMonoFont(25))
                    }
                }
            } else {
                HStack {
                    Text("Whatever you chose, computer forensics is a complicated field. While investigators don't actually do the convicting, the responsibility is great and a little scary...")
                        .font(timesNewRomanFont(35))
                        .italic()
                    
                    Spacer()
                }
                
                Text("THANKS FOR\nPLAYING!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .font(timesNewRomanFont(85))
                    .fontWeight(.bold)
                    .padding(.vertical, 30)
                
                HStack {
                    Text("- IDDA Headquarters, Amanda, and Me! :)\n\nHappy WWDC!")
                        .font(timesNewRomanFont(35))
                        .italic()
                        .foregroundColor(.red)
                    
                    Spacer()
                }
            }
        }
        .opacity(allOpacity)
        .padding(.all)
        .onAppear {
            // Play Clair de Lune again! ❤️
            playAudio(fileName: "Clair de Lune", type: "mp3")
        }
        .onReceive(allOpacityTimer) { _ in
            allOpacity += 0.01
        }
    }
    
    // MARK: View Functions
    // Functions go here! :)
}

// MARK: View Preview
struct FinaleView_Previews: PreviewProvider {
    static var previews: some View {
        FinaleView()
    }
}

// MARK: Support Views
// Support views go here! :)
