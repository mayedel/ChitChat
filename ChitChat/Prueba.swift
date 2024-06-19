//
//  Prueba.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import SwiftUI

struct Prueba: View {
    @State private var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NSIsImlhdCI6MTcxODczNjkzMywiZXhwIjoxNzIxMzI4OTMzfQ.dGEfm2X0j89ykk7I1T8EiLA8-3y69jivQC-x6tDS8lU"
       @State private var resultMessage = ""
       
    
    private let dataProvider: DataProviderProtocol = {
        let apiManager = APIManager()
        return DataProvider(apiManager: apiManager)
    }()
    
    var body: some View {
        VStack {
            Button(action: uploadUser) {
                            Text("Petición")
                               .padding()
                               .background(Color.green)
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

    func uploadUser() {
            let id = "665"
            let parameters = [
                "login": "newLogin",
                "password": "newPassword",
                "nick": "newNick",
                "avatar": "newAvatar",
                "platform": "iOS",
                "uuid": "newUUID",
                "online": "true"
            ]
            
            let fileContent = "newPassword=12345"
            let fileData = fileContent.data(using: .utf8)
            
            dataProvider.uploadUser(id: id, token: token, parameters: parameters, file: fileData) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        resultMessage = "Upload success: \(message)"
                   case .failure(let error):
                        resultMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

