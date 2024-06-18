//
//  Prueba.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import SwiftUI

struct Prueba: View {
    @State private var login = ""
    @State private var password = ""
    @State private var resultMessage = ""
    
    let apiManager = APIManager()
    var dataProvider: DataProviderProtocol {
        DataProvider(apiManager: apiManager)
    }
    
    var body: some View {
        Text("Hello, world!")
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
        }
    }
}
