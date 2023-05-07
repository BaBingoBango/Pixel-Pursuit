//
//  ARInstructionsView.swift
//  Mission Overflow
//
//  Created by Ethan Marshall on 4/2/23.
//

import SwiftUI

/// An app view written in SwiftUI!
struct ARInstructionsView: View {
    
    // MARK: View Variables
    let opacityTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var viewOpacity = 0.0
    @Binding var sceneCode: Int
    
    // MARK: View Body
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                HStack(spacing: 200) {
                    Rectangle()
                        .foregroundColor(.red)
                        .mask(
                            Image("IDDA logo")
                                .resizable()
                        )
                        .aspectRatio(1, contentMode: .fit)
                        .padding()
                        .frame(width: 200)
                    
                    Rectangle()
                        .foregroundColor(.red)
                        .mask(
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                        )
                        .aspectRatio(1, contentMode: .fit)
                        .padding()
                        .frame(width: 200)
                }
                
                Text("System Access Warning".uppercased())
                    .foregroundColor(.red)
                    .font(robotoMonoFont(75))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("This is a system for investigating cyber crimes. Only authorized IDDA agents and approved contractors are allowed to access it, under penalty of international law.")
                    .font(robotoMonoFont(25))
                    .multilineTextAlignment(.center)
                
                Text("Before activating, please ensure you have a floor space suitable for medium-to-large(ish) augmented reality activities - good luck! :)")
                    .font(robotoMonoFont(25))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.top)
                
                Text("AR SCANNING TIP: Look at the space you want to play in, then walk there after the game environment has loaded!")
                    .foregroundColor(.red)
                    .font(robotoMonoFont(25))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.top, 30)
                
                Spacer()
                
                HStack {
                    Text(">>>")
                        .font(robotoMonoFont(50))
                        .foregroundColor(.red)
                    
                    Button(action: {
                        sceneCode += 1
                    }) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.red)
                                .frame(width: 352, height: 75)
                            
                            Text("Activate System".uppercased())
                                .font(robotoMonoFont(30))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Text("<<<")
                        .font(robotoMonoFont(50))
                        .foregroundColor(.red)
                }
                .padding(.bottom)
            }
            .padding()
            .border(.red, width: 3)
        }
        .padding()
        .opacity(viewOpacity)
        .onReceive(opacityTimer) { _ in
            viewOpacity += 0.01
        }
        .onAppear {
            playAudio(fileName: "static sound effect", type: "mp3")
        }
        .onDisappear() {
            stopAudio()
            playAudio(fileName: "Retro Funk", type: "mp3")
        }
    }
    
    // MARK: View Functions
    // Functions go here! :)
}

// MARK: View Preview
struct ARInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        ARInstructionsView(sceneCode: .constant(3))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

// MARK: Support Views
// Support views go here! :)
