//
//  AccessServerView.swift
//  Pixel Pursuit
//
//  Created by Ethan Marshall on 4/19/23.
//

import SwiftUI

/// An app view written in SwiftUI!
struct AccessServerView: View {
    
    // MARK: View Variables
    @Binding var chatCode: Int
    @Binding var objectiveMessage: String
    @Binding var actionButtonMessage: String
    @SwiftUI.Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var themeColor = Color.blue
    @State var enteredSiteName = ""
    @State var enteredPassword = ""
    @State var hasGottenInformationWrong = false
    
    // MARK: View Body
    var body: some View {
        VStack {
            Text("↓ swipe to dismiss ↓")
                .font(robotoMonoFont(25))
                .fontWeight(.bold)
                .foregroundColor(themeColor)
                .padding(.top)
            
            Spacer()
            
            Text("🌎 cool web browser 2000! 🌏")
                .font(.title)
                .foregroundColor(.cyan)
                .fontWeight(.bold)
                .padding(.bottom)
            
            Text(!hasGottenInformationWrong ? "Navigate To Server!" : "Hmm...maybe try something else?")
                .font(robotoMonoFont(30))
                .fontWeight(.bold)
                .foregroundColor(themeColor)
            
            HStack {
                Text("DOMAIN NAME")
                    .font(robotoMonoFont(17.5))
                    .foregroundColor(themeColor)
                Spacer()
            }
            .padding([.leading, .top])
            
            TextField("example.com", text: $enteredSiteName)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .font(robotoMonoFont(30))
                .fontWeight(.bold)
                .foregroundColor(themeColor)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .border(themeColor, width: 4)
                .padding(.horizontal)
            
            HStack {
                Text("4-DIGIT PASSCODE")
                    .font(robotoMonoFont(17.5))
                    .foregroundColor(themeColor)
                Spacer()
            }
            .padding([.leading, .top])
            
            TextField("0000", text: $enteredPassword)
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
                if enteredSiteName.lowercased() == "nothingtoseehere.net" && enteredPassword.lowercased() == "4231" {
                    
                    // If it is, dismiss and change to the next scene
                    themeColor = .green
                    chatCode = 4
                    objectiveMessage = "Listen to Agent W\nfor instructions."
                    actionButtonMessage = "tap to advance text"
                    presentationMode.wrappedValue.dismiss()
                } else {
                    
                    // Oops! Wrong answer!
                    hasGottenInformationWrong = true
                }
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(themeColor)
                        .frame(width: 250, height: 75)
                    
                    Text("GO!")
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
struct AccessServerView_Previews: PreviewProvider {
    static var previews: some View {
        AccessServerView(chatCode: .constant(0), objectiveMessage: .constant(""), actionButtonMessage: .constant(""))
    }
}

// MARK: Support Views
// Support views go here! :)
