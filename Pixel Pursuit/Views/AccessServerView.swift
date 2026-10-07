//
//  AccessServerView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/19/23.
//

import SwiftUI

/// Amanda's web browser. The player enters the secret server's address and passcode from the clues on her disk.
struct AccessServerView: View {
    @Binding var chatIndex: Int
    @Binding var objective: String
    @Binding var action: GameAction?

    @Environment(\.dismiss) private var dismiss
    @State private var themeColor = Color.blue
    @State private var enteredSiteName = ""
    @State private var enteredPasscode = ""
    @State private var hasGottenInformationWrong = false

    var body: some View {
        VStack {
            Text("↓ swipe to dismiss ↓")
                .font(.robotoMono(25))
                .fontWeight(.bold)
                .foregroundStyle(themeColor)
                .padding(.top)

            Spacer()

            Text("🌎 cool web browser 2000! 🌏")
                .font(.title)
                .foregroundStyle(.cyan)
                .fontWeight(.bold)
                .padding(.bottom)

            Text(hasGottenInformationWrong ? "Hmm...maybe try something else?" : "Navigate To Server!")
                .font(.robotoMono(30))
                .fontWeight(.bold)
                .foregroundStyle(themeColor)

            fieldLabel("DOMAIN NAME")

            TextField("example.com", text: $enteredSiteName)
                .keyboardType(.URL)
                .modifier(BrowserFieldStyle(themeColor: themeColor))
                .accessibilityLabel("Domain name")

            fieldLabel("4-DIGIT PASSCODE")

            TextField("0000", text: $enteredPasscode)
                .submitLabel(.go)
                .onSubmit(navigateToServer)
                .modifier(BrowserFieldStyle(themeColor: themeColor))
                .accessibilityLabel("Four-digit passcode")

            Button(action: navigateToServer) {
                Text("GO!")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.robotoMono(25))
                    .frame(width: 250, height: 75)
                    .background(themeColor)
            }
            .padding(.top)

            Spacer()
        }
    }

    private func fieldLabel(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.robotoMono(17.5))
                .foregroundStyle(themeColor)

            Spacer()
        }
        .padding([.leading, .top])
    }

    private func navigateToServer() {
        // The address came from Amanda's web history; the passcode from her desktop notes.
        if enteredSiteName.lowercased() == "nothingtoseehere.net" && enteredPasscode.lowercased() == "4231" {
            // We're in! Hand the player back to Agent W.
            themeColor = .green
            chatIndex = 4
            objective = "Listen to Agent W\nfor instructions."
            action = .advanceText
            dismiss()
        } else {
            // Oops! Wrong answer!
            hasGottenInformationWrong = true
        }
    }
}

/// The boxed, monospaced look shared by the browser's text fields.
private struct BrowserFieldStyle: ViewModifier {
    let themeColor: Color

    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .font(.robotoMono(30))
            .fontWeight(.bold)
            .foregroundStyle(themeColor)
            .textFieldStyle(.plain)
            .padding()
            .border(themeColor, width: 4)
            .padding(.horizontal)
    }
}

#Preview {
    AccessServerView(chatIndex: .constant(0), objective: .constant(""), action: .constant(nil))
}
