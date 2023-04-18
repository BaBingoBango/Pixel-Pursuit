//
//  GameView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        ZStack {
            ARGameView()
            
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(width: 700, height: 55)
                        .opacity(0.1)
                        .border(.red, width: 5)
                    
                    Text("Example Objective".uppercased())
                        .foregroundColor(.red)
                        .font(robotoMonoFont(35))
                        .fontWeight(.bold)
                }
                .padding(.top)
                
                HStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .opacity(0.1)
                            .border(.red, width: 4)
                        
                        HStack {
                            Rectangle()
                                .foregroundColor(.red)
                                .mask(
                                    Image("IDDA logo")
                                        .resizable()
                                )
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 75)
                                .padding(.leading, 5)
                            
                            VStack(alignment: .leading) {
                                Text("Agent W")
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                                    .font(robotoMonoFont(20))
                                
                                Text("Hello there, Agent! This is some example text of what Agent W might say.")
                                    .foregroundColor(.red)
                                    .font(robotoMonoFont(15))
                            }
                        }
                        .padding(10)
                    }
                    .frame(width: 400, height: 125)
                    
                    Spacer()
                }
                
                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(width: 350, height: 75)
                    
                    Text("EXAMPLE ACTION")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(robotoMonoFont(30))
                }
                .padding(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
