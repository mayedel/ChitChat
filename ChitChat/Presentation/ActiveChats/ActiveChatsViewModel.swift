//
//  ActiveChatsViewModel.swift
//  ChitChat
//
//  Created by María Espejo on 9/7/24.
//

import Foundation
import Combine
import SwiftUI

protocol ChatsListViewModelProtocol {
    func getActiveChats(completion: @escaping (Result<[Conversation], Error>) -> Void)
}

class ActiveChatsViewModel: ObservableObject, ChatsListViewModelProtocol {
    @Published var chats: [ChatView] = []
    @Published var conversations: [Conversation] = []
    @Published var error: Error?
    @Published var searchText: String = ""
    private let chatsListUseCase: ActiveChatsUseCase
    
    init(chatsListUseCase: ActiveChatsUseCase) {
        self.chatsListUseCase = chatsListUseCase
        getActiveChats { _ in }
    }
    
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return conversations
        } else {
            return conversations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func getActiveChats(completion: @escaping (Result<[Conversation], Error>) -> Void) {
        //let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMyIsImlhdCI6MTcyMDYzNzk4NywiZXhwIjoxNzIzMjI5OTg3fQ.hXfoJkQ7eEgvYBgZ4XG_shUxICO9gM0A5Gc2q51zunE"
        let token = ChitChatDefaultsManager.shared.token
        chatsListUseCase.getActiveChats(token: token) { [weak self] result in
            switch result {
            case .success(let chats):
                DispatchQueue.main.async {
                    let conversations = ChatMapper.map(chatViews: chats)
                    self?.conversations = conversations
                    self?.getLastMessage(token: token)
                    completion(.success(conversations))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    func deleteChat(conversation: Conversation) {
      //  let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMyIsImlhdCI6MTcyMDYzNzk4NywiZXhwIjoxNzIzMjI5OTg3fQ.hXfoJkQ7eEgvYBgZ4XG_shUxICO9gM0A5Gc2q51zunE"
        let token = ChitChatDefaultsManager.shared.token
        chatsListUseCase.deleteChat(id: conversation.id, token: token) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.conversations.removeAll { $0.id == conversation.id }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
    func getLastMessage(token: String) {
        let group = DispatchGroup()
        var messagesDetails = [String: (message: String, date: String)]()
        
        for conversation in conversations {
            group.enter()
           // let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMyIsImlhdCI6MTcyMDYzNzk4NywiZXhwIjoxNzIzMjI5OTg3fQ.hXfoJkQ7eEgvYBgZ4XG_shUxICO9gM0A5Gc2q51zunE"
            let token = ChitChatDefaultsManager.shared.token
            let chatId = conversation.id
            chatsListUseCase.getLastMessage(token: token, chatId: chatId) { result in
                switch result {
                case .success(let messageDetails):
                    messagesDetails[chatId] = (message: messageDetails.message, date: messageDetails.date)
                case .failure(let error):
                    print("Error fetching last message for \(chatId): \(error)")
                    messagesDetails[chatId] = (message: "No hay mensajes.", date: "")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.conversations = self.conversations.map { conversation in
                var updatedConversation = conversation
                if let details = messagesDetails[conversation.id] {
                    updatedConversation.message = details.message
                    updatedConversation.time = DateFormatter.formatDate(dateString: details.date)
                }
                return updatedConversation
            }
        }
    }
    
    
    
}
