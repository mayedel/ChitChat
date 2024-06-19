//
//  Prueba.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import SwiftUI

struct Prueba: View {
        @State private var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1MyIsImlhdCI6MTcxODcyMjc4MSwiZXhwIjoxNzIxMzE0NzgxfQ.uN6s5CGApRUqjl58Lpfro6lpUlvlaL0u4fvGYK6cQC4"
        @State private var resultMessage = ""
    @State private var messages: [Message] = []
   
    private let messageDataProvider: MessageDataProviderProtocol = {
            let apiManager = APIManager()
            return MessageDataProvider(apiManager: apiManager)
        }()
        
        var body: some View {
            VStack {
                Button(action: getAllMessages) {
                    Text("Get All Messages")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                List(messages, id: \.id) { message in
                    VStack(alignment: .leading) {
                        Text("Source: \(message.source)")
                        Text("Message: \(message.message)")
                        Text("Date: \(message.date)")
                    }
                }
                
                Text(resultMessage)
                    .padding()
                    .foregroundColor(.red)
            }
            .padding()
        }
        
        func getAllMessages() {
            messageDataProvider.getAllMessages(token: token) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let messages):
                        self.messages = messages
                        self.resultMessage = "Messages retrieved successfully"
                    case .failure(let error):
                        self.resultMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
