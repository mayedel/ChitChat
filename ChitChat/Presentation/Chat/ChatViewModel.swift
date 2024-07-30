//
//  ChatViewModel.swift
//  ChitChat
//
//  Created by Andres Cordón on 22/7/24.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var messages: [MessageModel] = []
    @Published var error: String = ""
    @Published var isInChat: Bool = true
    
    private let getMessagesListUseCase: GetMessagesListUseCase
    private let createMessageUseCase: CreateMessageUseCase
    
    init(getMessagesListUseCase: GetMessagesListUseCase, createMessageUseCase: CreateMessageUseCase) {
        self.getMessagesListUseCase = getMessagesListUseCase
        self.createMessageUseCase = createMessageUseCase
    }
    
    func getMessagesService(chatId: String, completion: @escaping () -> Void) {
        self.getMessagesList(chatId: chatId, completion: completion)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: isInChat) { timer in
            self.getMessagesList(chatId: chatId, completion: completion)
        }
    }
    
    
    func getMessagesList(chatId: String, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.getMessagesListUseCase.getMessagesList(chatId: chatId) { response in
                switch response {
                case .success(let data):
                    self.messages = data.sorted(by: { message, message2 in
                        message.date < message2.date
                    })
                    completion()
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
    }
    
    func createNewMessage(message: String, chatId: String, completion: @escaping (Bool) -> Void) {
        createMessageUseCase.createNewMessage(chatId: chatId, message: message) { response in
            switch response {
            case .success(let data):
                NotificationsManager.sendNotification(message: message)
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
    
    func eliminateAllUnreadMessages(conversation: Conversation) {
        var conversations = ChitChatDefaultsManager.shared.conversations
        if let updatedConversation = conversations.firstIndex(of: conversation) {
            
            var messages = ChitChatDefaultsManager.shared.messages
            var conversationMessages = messages.filter { message in
                message.chat == conversation.id
            }
            
            messages.removeAll { message in
                message.chat == conversation.id
            }
            
            conversationMessages.indices.forEach { index in
                conversationMessages[index].isRead = true
            }
            
            messages.append(contentsOf: conversationMessages)
            
            ChitChatDefaultsManager.shared.messages = messages

            conversations[updatedConversation].unreadMessages.removeAll()
            
        }
        ChitChatDefaultsManager.shared.conversations = conversations
    }
}
