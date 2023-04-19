//
//  GameView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI

struct GameView: View {
    
    @Binding var sceneCode: Int
    @State var chatCode = 0
    @State var elementOpacity = 0.0
    @State var chatBoxSpeaker = "BOOTING..."
    @State var chatBoxMessage = "Connecting..."
    @State var objectiveMessage = "BOOTING..."
    @State var actionButtonMessage = ""
    @State var currentScene = ARSceneID.coaching
    @State var isShowingDecryptDiskView = false
    @State var isShowingAccessServerView = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            switch currentScene {
            case .coaching:
                ARGameView(scene: .coaching, actionButtonMessage: $actionButtonMessage)
            case .diskTable:
                ARGameView(scene: .diskTable, actionButtonMessage: $actionButtonMessage)
            case .office:
                ARGameView(scene: .office, actionButtonMessage: $actionButtonMessage)
            case .disk:
                ARGameView(scene: .disk, actionButtonMessage: $actionButtonMessage)
            case .photos:
                ARGameView(scene: .photos, actionButtonMessage: $actionButtonMessage)
            case .desktop:
                ARGameView(scene: .desktop, actionButtonMessage: $actionButtonMessage)
            case .webHistory:
                ARGameView(scene: .webHistory, actionButtonMessage: $actionButtonMessage)
            case .secretServer:
                ARGameView(scene: .secretServer, actionButtonMessage: $actionButtonMessage)
            }
            
            VStack {
                if ARsceneID == .coaching {
                    Text(">> SEARCH FOR OPEN FLOOR SPACE <<")
                        .font(robotoMonoFont(30))
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.top)
                }
                
                Spacer()
            }
            
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
                                    switch currentScene {
                                    case .coaching:
                                        return diskTableSceneChats[chatCode]
                                    case .diskTable:
                                        return diskTableSceneChats[chatCode]
                                    case .office:
                                        return officeSceneChats[chatCode]
                                    case .disk:
                                        return diskSceneChats[chatCode]
                                    case .photos:
                                        return photosSceneChats[chatCode]
                                    case .desktop:
                                        return desktopSceneChats[chatCode]
                                    case .webHistory:
                                        return webSceneChats[chatCode]
                                    case .secretServer:
                                        return serverSceneChats[chatCode]
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
                    .padding(.top)
                    
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
                .padding(.top)
                .padding(.top, 10)
                .padding(.top)
                
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
                            
                        case "tap to advance text":
                            if currentScene == .coaching {
                                if chatCode >= 5 { actionButtonMessage = "search amanda's office" }; if chatCode <= 6 { chatCode += 1 }
                            } else if currentScene == .office {
                                if chatCode >= 1 { actionButtonMessage = "search amanda's disk" }; if chatCode <= 2 { chatCode += 1 }
                            } else if currentScene == .disk {
                                if chatCode >= 4 { actionButtonMessage = "enter amanda's server" };
                                if chatCode == 2 { actionButtonMessage = "" }
                                else if chatCode <= 5 { chatCode += 1 }
                            }
                            
                        case "search amanda's office": currentScene = .office; chatCode = 0; objectiveMessage = "Find Amanda's\ndisk password."; actionButtonMessage = "decrypt disk"
                            
                        case "decrypt disk": isShowingDecryptDiskView = true
                            
                        case "search amanda's disk": currentScene = .disk; chatCode = 0; objectiveMessage = "Access Amanda's\nsecret website."; actionButtonMessage = "tap to advance text"
                            
                        // Proximity button handlers!
                        case "view photos":
                            currentScene = .photos
                            chatCode = 0
                            actionButtonMessage = "exit photos"
                        case "view desktop":
                            currentScene = .desktop
                            chatCode = 0
                            actionButtonMessage = "exit desktop"
                        case "view web history":
                            currentScene = .webHistory
                            chatCode = 0
                            actionButtonMessage = "exit web history"
                        case "access server":
                            isShowingAccessServerView = true
                        case "exit photos":
                            currentScene = .disk
                            chatCode = 3
                            actionButtonMessage = ""
                        case "exit desktop":
                            currentScene = .disk
                            chatCode = 3
                            actionButtonMessage = ""
                        case "exit web history":
                            currentScene = .disk
                            chatCode = 3
                            actionButtonMessage = ""
                            
                        case "enter amanda's server":
                            currentScene = .secretServer
                            chatCode = 0
                            objectiveMessage = "Decide about\nAmanda's guilt."
                            actionButtonMessage = "exit server"
                            
                        case "exit server":
                            sceneCode += 1
                            
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
                    .sheet(isPresented: $isShowingDecryptDiskView) {
                        DecryptDiskView(chatCode: $chatCode, objectiveMessage: $objectiveMessage, actionButtonMessage: $actionButtonMessage)
                    }
                    .padding(.trailing)
                }
                .sheet(isPresented: $isShowingAccessServerView) {
                    AccessServerView(chatCode: $chatCode, objectiveMessage: $objectiveMessage, actionButtonMessage: $actionButtonMessage)
                }
            }
            .opacity(elementOpacity)
            .onReceive(timer) { _ in
                if ARsceneID == .diskTable {
                    if elementOpacity >= 0.9 && chatBoxSpeaker == "BOOTING..." {
                        chatBoxSpeaker = "AGENT_W"
                        chatCode += 1
                        objectiveMessage = "Listen to Agent W\nfor instructions."
                        actionButtonMessage = "tap to advance text"
                    } else {
                        elementOpacity += 0.02
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(sceneCode: .constant(0))
    }
}
