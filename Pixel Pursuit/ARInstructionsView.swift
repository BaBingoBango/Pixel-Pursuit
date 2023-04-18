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
    
    // MARK: View Body
    var body: some View {
        ZStack {
            GIFView(gifName: "staticGIF")
                .aspectRatio(contentMode: .fill)
                .overlay(Color.red.opacity(0.5))
                .frame(height: 0)
                .opacity(0.1)
            
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
                            Image("EOT logo")
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
                
                Text("This system should only accessed by authorized IDDA agents, under penalty of international law.")
                    .font(robotoMonoFont(25))
                    .multilineTextAlignment(.center)
                
                Text("Before activating, please ensure you are facing a wall suitable for augmented reality experiences.")
                    .font(robotoMonoFont(25))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                HStack {
                    Text(">>>")
                        .font(robotoMonoFont(50))
                        .foregroundColor(.red)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: 352, height: 75)
                        
                        Text("Activate System".uppercased())
                            .font(robotoMonoFont(30))
                            .foregroundColor(.black)
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
    }
    
    // MARK: View Functions
    // Functions go here! :)
}

// MARK: View Preview
struct ARInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        ARInstructionsView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

// MARK: Support Views
// Support views go here! :)
