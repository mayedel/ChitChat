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
     @State private var nick = ""
     @State private var avatar = ""
     @State private var platform = "iOS"
     @State private var uuid = UUID().uuidString
     @State private var online = true
     @State private var resultMessage = ""

     let apiManager = APIManager()
     var usersAPIService: UsersAPIServiceProtocol {
         UsersAPIService(apiManager: apiManager)
     }

     var body: some View {
         VStack {
             TextField("Login", text: $login)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()

             SecureField("Password", text: $password)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()

             TextField("Nick", text: $nick)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()

             TextField("Avatar", text: $avatar)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()

             Button(action: registerUser) {
                 Text("Register")
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

     func registerUser() {
         let user = User(
             id: UUID().uuidString,
             login: login,
             password: password,
             nick: nick,
             platform: platform,
             avatar: avatar,
             uuid: uuid,
             token: "",
             online: online,
             created: "",
             updated: ""
         )

         usersAPIService.registerUser(user: user) { result in
             DispatchQueue.main.async {
                 switch result {
                 case .success(let registeredUser):
                     resultMessage = "Registered user: \(registeredUser.nick)"
                 case .failure(let error):
                     resultMessage = "Error: \(error.localizedDescription)"
                 }
             }
         }
     }
 }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Prueba()
    }
}
