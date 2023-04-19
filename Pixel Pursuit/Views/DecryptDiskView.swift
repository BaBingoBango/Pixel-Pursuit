//
//  DecryptDiskView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/19/23.
//

import SwiftUI

/// An app view written in SwiftUI!
struct DecryptDiskView: View {
    
    // MARK: View Variables
    @Binding var chatCode: Int
    @Binding var objectiveMessage: String
    @Binding var actionButtonMessage: String
    @SwiftUI.Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var themeColor = Color.red
    @State var enteredPassword = ""
    @State var hasGottenPasswordWrong = false
    
    // MARK: View Body
    var body: some View {
        VStack {
            Text("↓ swipe to dismiss ↓")
                .font(robotoMonoFont(25))
                .fontWeight(.bold)
                .foregroundColor(themeColor)
                .padding(.top)
            
            Spacer()
            
            Text("💕 amanda's computer 💕")
                .font(.title)
                .foregroundColor(.pink)
                .fontWeight(.bold)
                .padding(.bottom)
            
            Text(!hasGottenPasswordWrong ? "ENTER DISK PASSWORD:" : "INCORRECT! PLEASE TRY AGAIN!")
                .font(robotoMonoFont(30))
                .fontWeight(.bold)
                .foregroundColor(themeColor)
            
            TextField("", text: $enteredPassword)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(robotoMonoFont(30))
                .fontWeight(.bold)
                .foregroundColor(themeColor)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .border(themeColor, width: 4)
                .padding(.horizontal)
            
            Button(action: {
                // Check if the password is right!
                if enteredPassword.lowercased() == "mike4neva" {
                    
                    // If it is, dismiss and change to the next scene
                    themeColor = .green
                    chatCode = 1
                    objectiveMessage = "Listen to Agent W\nfor instructions."
                    actionButtonMessage = "tap to advance text"
                    presentationMode.wrappedValue.dismiss()
                } else {
                    
                    // Oops! Wrong answer!
                    hasGottenPasswordWrong = true
                }
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(themeColor)
                        .frame(width: 250, height: 75)
                    
                    Text("SUBMIT")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(robotoMonoFont(25))
                }
            }
            .padding(.top)
            
            Spacer()
        }
    }
    
    // MARK: View Functions
    // Functions go here! :)
}

// MARK: View Preview
struct DecryptDiskView_Previews: PreviewProvider {
    static var previews: some View {
        DecryptDiskView(chatCode: .constant(0), objectiveMessage: .constant(""), actionButtonMessage: .constant(""))
    }
}

// MARK: Support Views
// Support views go here! :)
