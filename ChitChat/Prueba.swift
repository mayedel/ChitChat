//
//  Prueba.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import SwiftUI

struct Prueba: View {
    @State private var token = "eeyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NSIsImlhdCI6MTcxODczNjkzMywiZXhwIjoxNzIxMzI4OTMzfQ.dGEfm2X0j89ykk7I1T8EiLA8-3y69jivQC-x6tDS8lU"
       @State private var resultMessage = ""
    @State private var messages: [Message] = []
        
    private let dataProvider: DataProviderProtocol = {
        let apiManager = APIManager()
        return DataProvider(apiManager: apiManager)
    }()
    
    var body: some View {
        VStack {
            Button(action: getMessages) {
                            Text("Get All Messages")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()

                        if !messages.isEmpty {
                            List(messages) { message in
                                VStack(alignment: .leading) {
                                    Text("Message ID: \(message.id)")
                                    Text("Chat ID: \(message.chat)")
                                    Text("Source: \(message.source)")
                                    Text("Message: \(message.message)")
                                    Text("Date: \(message.date)")
                                }
                            }
                        } else {
                            Text(resultMessage)
                                .padding()
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                }

                func getMessages() {
                    dataProvider.getMessages(for: "", token: token) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let messages):
                                self.messages = messages
                                self.resultMessage = "Messages fetched successfully"
                            case .failure(let error):
                                self.resultMessage = "Error: \(error.localizedDescription)"
                            }
                        }
                    }
                }
            }
