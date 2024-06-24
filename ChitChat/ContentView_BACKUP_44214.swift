//
//  ContentView.swift
//  ChitChat
//
//  Created by María Espejo on 30/5/24.
//

import SwiftUI

<<<<<<< HEAD
struct Prueba: View {
<<<<<<< HEAD
    @State private var login = ""
    @State private var password = ""
    @State private var resultMessage = ""

    let apiManager = APIManager()
    var dataProvider: DataProviderProtocol {
        DataProvider(apiManager: apiManager)
    }

    var body: some View {
        VStack {
            TextField("Login", text: $login)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: loginUser) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            Text(resultMessage)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
    }

    func loginUser() {
        dataProvider.loginUser(login: login, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (token, userPartial)):
                    resultMessage = "Logged in! Token: \(token), User ID: \(userPartial.id)"
                case .failure(let error):
                    resultMessage = "Error: \(error.localizedDescription)"
                }
            }
=======
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var useBiometrics: Bool = false
    @State private var userExist: Bool = true
    @State private var passCorrect: Bool = true
    
    
    var body: some View {
=======
struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var useBiometrics: Bool = false
    @State private var userExist: Bool = true
    @State private var passCorrect: Bool = true
    
    
    var body: some View {
>>>>>>> 712d39e4166b63a5953b99d800c9d717f420ff08
        
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
                        // Acción de login
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
<<<<<<< HEAD
                        Text("Regístrate")                            .font(.headline)
=======
                        Text("Regístrate")
                            .font(.headline)
>>>>>>> 712d39e4166b63a5953b99d800c9d717f420ff08
                            .foregroundStyle(.black)
                    }
                }
            }.padding(.horizontal, 50)
<<<<<<< HEAD
>>>>>>> b1c44b92287349f69a99401134cad3d7404c8c3a
=======
>>>>>>> 712d39e4166b63a5953b99d800c9d717f420ff08
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
