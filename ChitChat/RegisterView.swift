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
                Text("User Registration")
                    .font(.title2)
            }
            .padding(5)
            
            VStack(alignment: .leading, spacing: 10) {
                RegistrationTextField(title: "Usuario", text: $username, validation: userExist)
                if !userExist {
                    Text("Usuario no disponible")
                        .foregroundColor(.red)
                }
                
                RegistrationSecureField(title: "Contraseña", text: $password)
                
                RegistrationSecureField(title: "Repite tu contraseña", text: $repeatPassword, validation: passCorrectRepeated, hint: "Repite tu contraseña")
                if !passCorrectRepeated {
                    Text("Las contraseñas no coinciden")
                        .foregroundColor(.red)
                }
                
                RegistrationTextField(title: "Nick", text: $nickname, validation: true)
                
                RegistrationTextField(title: "Avatar", text: $avatar, validation: true)
            }
            .padding(15)
            
            Button(action: {
                // Register action
            }) {
                Text("Registrar")
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            TextField("Ingresa tu \(title.lowercased())", text: $text)
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
