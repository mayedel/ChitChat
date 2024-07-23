//
//  ChatViewModel.swift
//  ChitChat
//
//  Created by Andres Cordón on 22/7/24.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var error: String = ""
    
    private let getMessagesListUseCase: GetMessagesListUseCase
    private let createMessageUseCase: CreateMessageUseCase
    
    init(getMessagesListUseCase: GetMessagesListUseCase, createMessageUseCase: CreateMessageUseCase) {
        self.getMessagesListUseCase = getMessagesListUseCase
        self.createMessageUseCase = createMessageUseCase
    }
    
    func getMessagesList() {
        getMessagesListUseCase.getMessagesList(chatId: "1532") { response in
            switch response {
            case .success(let data):
                self.messages = data.sorted(by: { message, message2 in
                    message.date < message2.date
                })
                print(data)
            case .failure(let error):
                guard let code = error.code else { return }
                switch code {
                case 401:
                    self.error = LocalizedStringKey.init("Unauthorized").stringValue()
                case 400:
                    self.error = LocalizedStringKey.init("NoQueryParams").stringValue()
                default:
                    self.error = LocalizedStringKey.init("LoginDefaultError").stringValue()
                }
            }
        }
    }
    
    func createNewMessage(message: String, completion: @escaping (Bool) -> Void) {
        createMessageUseCase.createNewMessage(chatId: "1532", message: message) { response in
            switch response {
            case .success(let data):
                completion(data)
            case .failure(let error):
                guard let code = error.code else { return }
                switch code {
                case 401:
                    self.error = LocalizedStringKey.init("Unauthorized").stringValue()
                default:
                    self.error = LocalizedStringKey.init("LoginDefaultError").stringValue()
                }
            }
        }
    }
}
