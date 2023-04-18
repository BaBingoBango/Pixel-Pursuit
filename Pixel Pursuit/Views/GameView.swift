//
//  GameView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI

struct GameView: View {
    
    @State var chatCode = 0
    @State var elementOpacity = 0.0
    @State var chatBoxSpeaker = "BOOTING..."
    @State var chatBoxMessage = "Connecting..."
    @State var objectiveMessage = "BOOTING..."
    @State var actionButtonMessage = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            var ARgameView = ARGameView(scene: .coaching)
            ARgameView
            
            VStack {
                HStack(alignment: .top) {
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
                                Text(chatBoxSpeaker)
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                                    .font(robotoMonoFont(20))
                                
                                Text(verbatim: {
                                    switch ARsceneID {
                                    case .coaching:
                                        return diskTableSceneChats[chatCode]
                                    case .diskTable:
                                        return diskTableSceneChats[chatCode]
                                    case .office:
                                        return diskTableSceneChats[chatCode]
                                    case .disk:
                                        return diskTableSceneChats[chatCode]
                                    case .photos:
                                        return diskTableSceneChats[chatCode]
                                    case .desktop:
                                        return diskTableSceneChats[chatCode]
                                    case .webHistory:
                                        return diskTableSceneChats[chatCode]
                                    case .secretServer:
                                        return diskTableSceneChats[chatCode]
                                    }
                                }())
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.red)
                                    .font(robotoMonoFont(17.5))
                            }
                            
                            Spacer()
                        }
                        .padding(10)
                    }
                    .frame(width: 500, height: 125)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("[OBJECTIVE]")
                            .font(robotoMonoFont(30))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Text(objectiveMessage)
                            .font(robotoMonoFont(25))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.trailing)
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    let cornerTextView = Text("International Digital Defense Authority\nMission Visualization Interface\nSerial No. WWDC2023\nVer. 6.5.23".uppercased())
                        .font(robotoMonoFont(12.5))
                        .foregroundColor(.red)
                        .padding(.leading)
                    cornerTextView
                    
                    Spacer()
                    
                    Button(action: {
                        switch actionButtonMessage {
                        case "[tap to advance text]": chatCode += 1
                        case "[search amanda's office]": ARsceneID = .office; ARgameView = ARGameView(scene: .office)
                        default: print("unknown action requested! oops!")
                        }
                    }) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.red)
                                .frame(width: 350, height: 75)
                            
                            Text(actionButtonMessage)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(robotoMonoFont(25))
                        }
                        .padding(.bottom)
                        .opacity(actionButtonMessage.isEmpty ? 0 : 1)
                    }
                    
                    Spacer()
                    
                    cornerTextView
                        .hidden()
                }
            }
            .onReceive(timer) { _ in
                if ARsceneID == .diskTable {
                    if elementOpacity >= 0.9 && chatBoxSpeaker == "BOOTING..." {
                        chatBoxSpeaker = "AGENT_W"
                        chatCode += 1
                        objectiveMessage = "Listen to Agent W\nfor instructions."
                        actionButtonMessage = "[tap to advance text]"
                    } else {
                        elementOpacity += 0.02
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .opacity(elementOpacity)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
