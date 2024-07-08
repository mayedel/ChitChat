//
//  RegisterView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 23/6/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var nickname: String = ""
    @State private var avatar: String = ""
    @State private var userExist: Bool = true
    @State private var passCorrectRepeated: Bool = true
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("back_arrow")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(LocalizedStringKey("UserRegistration").stringValue())
                    .font(.title2)
            }
            .padding(5)
            
            VStack(alignment: .leading, spacing: 10) {
                RegistrationTextField(
                    title: LocalizedStringKey("User").stringValue(),
                    text: $username, validation: userExist,
                    hint: LocalizedStringKey("EnterYourUser").stringValue()
                )
                if !userExist {
                    Text(LocalizedStringKey("UserError"))
                        .foregroundColor(.red)
                }
                
                RegistrationSecureField(
                    title: LocalizedStringKey("Password").stringValue(),
                    text: $password,
                    hint: LocalizedStringKey("EnterYourPass").stringValue()
                )
                
                RegistrationSecureField(title: LocalizedStringKey("RepeatYourPassword").stringValue(), text: $repeatPassword, validation: passCorrectRepeated, hint: LocalizedStringKey("RepeatYourPassword").stringValue())
                if !passCorrectRepeated {
                    Text(LocalizedStringKey("PasswordsDontMatch").stringValue())
                        .foregroundColor(.red)
                }
                
                RegistrationTextField(title: "Nick", text: $nickname, validation: true, hint: LocalizedStringKey("EnterYourNick").stringValue())
                
                RegistrationTextField(title: "Avatar", text: $avatar, validation: true, hint: LocalizedStringKey("EnterYourAvatar").stringValue())
            }
            .padding(15)
            
            Button(action: {
                // Register action
            }) {
                Text(LocalizedStringKey("Register").stringValue())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 15)
            
            Spacer()
        }
    }
}

struct RegistrationTextField: View {
    var title: String
    @Binding var text: String
    var validation: Bool
    var hint: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            TextField(hint, text: $text)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(validation ? Color.gray : Color.red)
                )
        }
    }
}

struct RegistrationSecureField: View {
    var title: String
    @Binding var text: String
    var validation: Bool = true
    var hint: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            SecureField(hint ?? "Ingresa tu \(title.lowercased())", text: $text)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(validation ? Color.gray : Color.red)
                )
        }
    }
}

#Preview {
    RegisterView()
}
