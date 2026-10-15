//
//  GameView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/18/23.
//

import SwiftUI

/// The investigation itself: the augmented-reality view with the I.D.D.A.'s mission interface layered on top.
///
/// The interface is driven by one action button whose label doubles as the game's state (see `GameAction`),
/// Agent W's chat box, and the current objective.
struct GameView: View {
    /// Called when the player reports back from Amanda's secret server, ending the investigation.
    let onFinished: () -> Void

    /// The scene the game has asked for. The AR view swaps scenes in place, in one session.
    @State private var requestedScene = ARSceneID.coaching
    /// The scene actually on screen. The disk table appears once the player has placed it on the floor.
    @State private var presentedScene = ARSceneID.coaching
    @State private var placement = PlacementState.scanning
    @State private var chatIndex = 0
    @State private var speaker = "BOOTING..."
    @State private var objective = "BOOTING..."
    @State private var action: GameAction?
    @State private var interfaceOpacity = 0.0
    @State private var isShowingDecryptDiskView = false
    @State private var isShowingAccessServerView = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        ZStack {
            ARGameView(scene: requestedScene, presentedScene: $presentedScene, placement: $placement, action: $action)
                .ignoresSafeArea()

            if let placementBanner {
                VStack {
                    Text(placementBanner)
                        .font(.robotoMono(30))
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top)

                    Spacer()
                }
            }

            missionInterface
                .opacity(interfaceOpacity)
        }
        .task(id: presentedScene) {
            await bringInterfaceOnlineIfNeeded()
        }
        .sheet(isPresented: $isShowingDecryptDiskView) {
            DecryptDiskView(chatIndex: $chatIndex, objective: $objective, action: $action)
        }
        .sheet(isPresented: $isShowingAccessServerView) {
            AccessServerView(chatIndex: $chatIndex, objective: $objective, action: $action)
        }
    }

    // MARK: - Mission interface

    private var missionInterface: some View {
        VStack {
            if horizontalSizeClass == .compact {
                VStack(alignment: .leading, spacing: 12) {
                    chatBox
                    objectivePanel(alignment: .leading)
                }
            } else {
                HStack(alignment: .top) {
                    chatBox
                        .layoutPriority(1)

                    Spacer(minLength: 16)

                    objectivePanel(alignment: .trailing)
                }
            }

            Spacer()

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 12) {
                    if placement == .placed {
                        moveSceneButton
                    }

                    if horizontalSizeClass != .compact {
                        Text("International Digital Defense Authority\nMission Visualization Interface\nSerial No. WWDC2023\nVer. 6.5.23".uppercased())
                            .font(.robotoMono(12.5))
                            .foregroundStyle(.red)
                    }
                }
                .padding(.leading)

                Spacer(minLength: 16)

                actionButton
            }
        }
        .padding()
        .padding(.top, 24)
    }

    private var chatBox: some View {
        HStack {
            LogoView(logo: .iddaLogo)
                .frame(width: 75)
                .padding(.leading, 5)

            VStack(alignment: .leading) {
                Text(speaker)
                    .foregroundStyle(.red)
                    .fontWeight(.bold)
                    .font(.robotoMono(20))

                Text(verbatim: currentChatLine)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(.red)
                    .font(.robotoMono(17.5))
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .frame(maxWidth: 500)
        .frame(height: 125)
        .background(Color.red.opacity(0.1))
        .border(.red, width: 4)
        .padding(.top)
    }

    private func objectivePanel(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 0) {
            Text("[OBJECTIVE]")
                .font(.robotoMono(30))
                .fontWeight(.bold)
                .foregroundStyle(.red)

            Text(objective)
                .font(.robotoMono(25))
                .foregroundStyle(.red)
                .multilineTextAlignment(alignment == .trailing ? .trailing : .leading)
        }
    }

    private var actionButton: some View {
        Button {
            if let action {
                perform(action)
            }
        } label: {
            Text(action?.rawValue ?? "")
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .font(.robotoMono(25))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(maxWidth: 350)
                .frame(height: 75)
                .background(Color.red)
        }
        .disabled(action == nil)
        .opacity(action == nil ? 0 : 1)
        .padding(.bottom)
        .padding(.trailing)
    }

    private var moveSceneButton: some View {
        Button {
            placement = .placing
        } label: {
            Label("MOVE SCENE", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
                .font(.robotoMono(15))
                .fontWeight(.bold)
                .foregroundStyle(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .border(.red, width: 2)
        }
        .accessibilityHint("Then tap the floor where the scene should go.")
    }

    /// What to tell the player while the scene isn't on the floor yet.
    private var placementBanner: String? {
        switch placement {
        case .scanning: ">> SEARCH FOR OPEN FLOOR SPACE <<"
        case .placing: ">> TAP THE FLOOR TO PLACE THE SCENE <<"
        case .placed: nil
        }
    }

    /// Agent W's current line for the scene the player is in.
    private var currentChatLine: String {
        let lines = Dialogue.lines(for: requestedScene)
        return lines.indices.contains(chatIndex) ? lines[chatIndex] : ""
    }

    // MARK: - Game flow

    /// Fades the interface in once the disk table has been placed, then hands the player over to Agent W.
    private func bringInterfaceOnlineIfNeeded() async {
        guard presentedScene == .diskTable, speaker == "BOOTING..." else { return }

        // The interface stays slightly translucent so the camera feed shows through.
        withAnimation(.linear(duration: 4.5)) {
            interfaceOpacity = 0.9
        }
        try? await Task.sleep(for: .seconds(4.6))
        guard !Task.isCancelled else { return }

        speaker = "AGENT_W"
        chatIndex += 1
        objective = "Listen to Agent W\nfor instructions."
        action = .advanceText
    }

    private func perform(_ action: GameAction) {
        switch action {
        case .advanceText:
            advanceText()

        case .searchOffice:
            requestedScene = .office
            chatIndex = 0
            objective = "Find Amanda's\ndisk password."
            self.action = .decryptDisk

        case .decryptDisk:
            isShowingDecryptDiskView = true

        case .searchDisk:
            requestedScene = .disk
            chatIndex = 0
            objective = "Access Amanda's\nsecret website."
            self.action = .advanceText

        // Offered by the proximity triggers in Amanda's disk.
        case .viewPhotos:
            requestedScene = .photos
            chatIndex = 0
            self.action = .exitPhotos

        case .viewDesktop:
            requestedScene = .desktop
            chatIndex = 0
            self.action = .exitDesktop

        case .viewWebHistory:
            requestedScene = .webHistory
            chatIndex = 0
            self.action = .exitWebHistory

        case .accessServer:
            isShowingAccessServerView = true

        case .exitPhotos, .exitDesktop, .exitWebHistory:
            requestedScene = .disk
            chatIndex = 3
            self.action = nil

        case .enterServer:
            requestedScene = .secretServer
            chatIndex = 0
            objective = "Decide about\nAmanda's guilt."
            self.action = .exitServer

        case .exitServer:
            onFinished()
        }
    }

    /// Steps through Agent W's lines for the current scene, offering the next action once the story has been told.
    private func advanceText() {
        switch requestedScene {
        case .coaching:
            if chatIndex >= 5 { action = .searchOffice }
            if chatIndex <= 6 { chatIndex += 1 }

        case .office:
            if chatIndex >= 1 { action = .searchDisk }
            if chatIndex <= 2 { chatIndex += 1 }

        case .disk:
            if chatIndex >= 4 { action = .enterServer }
            if chatIndex == 2 {
                // Agent W has said enough: the player has to walk the disk to find the next clue.
                action = nil
            } else if chatIndex <= 5 {
                chatIndex += 1
            }

        default:
            break
        }
    }
}

#Preview(traits: .landscapeLeft) {
    GameView(onFinished: {})
}
