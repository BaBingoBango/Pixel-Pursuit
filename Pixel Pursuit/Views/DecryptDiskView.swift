//
//  DecryptDiskView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/19/23.
//

import SwiftUI

/// Amanda's login screen. The player types the disk password they found in her office.
struct DecryptDiskView: View {
    @Binding var chatIndex: Int
    @Binding var objective: String
    @Binding var action: GameAction?

    @Environment(\.dismiss) private var dismiss
    @State private var themeColor = Color.red
    @State private var enteredPassword = ""
    @State private var hasGottenPasswordWrong = false

    var body: some View {
        VStack {
            Text("↓ swipe to dismiss ↓")
                .font(.robotoMono(25))
                .fontWeight(.bold)
                .foregroundStyle(themeColor)
                .padding(.top)

            Spacer()

            Text("💕 amanda's computer 💕")
                .font(.title)
                .foregroundStyle(.pink)
                .fontWeight(.bold)
                .padding(.bottom)

            Text(hasGottenPasswordWrong ? "INCORRECT! PLEASE TRY AGAIN!" : "ENTER DISK PASSWORD:")
                .font(.robotoMono(30))
                .fontWeight(.bold)
                .foregroundStyle(themeColor)

            TextField("", text: $enteredPassword)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.go)
                .onSubmit(submitPassword)
                .font(.robotoMono(30))
                .fontWeight(.bold)
                .foregroundStyle(themeColor)
                .textFieldStyle(.plain)
                .padding()
                .border(themeColor, width: 4)
                .padding(.horizontal)
                .accessibilityLabel("Disk password")

            Button(action: submitPassword) {
                Text("SUBMIT")
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

    private func submitPassword() {
        // Amanda left her password somewhere in her office. 💕
        if enteredPassword.lowercased() == "mike4neva" {
            // Unlocked! Hand the player back to Agent W.
            themeColor = .green
            chatIndex = 1
            objective = "Listen to Agent W\nfor instructions."
            action = .advanceText
            dismiss()
        } else {
            // Oops! Wrong answer!
            hasGottenPasswordWrong = true
        }
    }
}

#Preview {
    DecryptDiskView(chatIndex: .constant(0), objective: .constant(""), action: .constant(nil))
}
