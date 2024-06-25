//
//  ContentView.swift
//  ChitChat
//
//  Created by María Espejo on 30/5/24.
//

import SwiftUI

struct ContentView: View {

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var useBiometrics: Bool = false
    @State private var userExist: Bool = true
    @State private var passCorrect: Bool = true
    @State private var errorMessage: String = ""
    
    var body: some View {
        
        VStack{
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding(.top,20).frame(width: 200)
            VStack(alignment: .leading, spacing: 8) {
                Text("Usuario")
                    .font(.headline)
                TextField("Ingresa tu usuario", text: $username)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(userExist ? Color.gray : Color.red)
                    )
                if(!userExist){
                    Text("Usuario inexistente")
                        .foregroundColor(.red)
                }
                
                Text("Contraseña")
                    .font(.headline)
                TextField("Ingresa tu contraseña", text: $password)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(passCorrect ? Color.gray : Color.red)
                    )
                if(!passCorrect){
                    Text("Contraseña incorrecta").foregroundColor(.red)
                }
                
                
                HStack{
                    Text("Acceso con biometría")
                        .font(.headline)
                    Spacer()
                    Toggle("", isOn: $useBiometrics)
                        .labelsHidden()
                }
                VStack{
                    Button(action: {
                        //login
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 16)
                    Spacer().frame(height: 200)
                    Text("¿No tienes cuenta?")
                    Button(action: {
                        // Acción de registro
                    }) {
                        Text("Regístrate")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                }
            }.padding(.horizontal, 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
