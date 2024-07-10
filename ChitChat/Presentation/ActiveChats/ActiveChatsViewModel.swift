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
    func getActiveChats(completion: @escaping (Result<[Chat], Error>) -> Void)
}

class ActiveChatsViewModel: ObservableObject, ChatsListViewModelProtocol {
    @Published var chats: [Chat] = []
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
    
    func getActiveChats(completion: @escaping (Result<[Chat], Error>) -> Void) {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMyIsImlhdCI6MTcyMDYzNzk4NywiZXhwIjoxNzIzMjI5OTg3fQ.hXfoJkQ7eEgvYBgZ4XG_shUxICO9gM0A5Gc2q51zunE"
        chatsListUseCase.getActiveChats(token: token) { [weak self] result in
            switch result {
            case .success(let chats):
                DispatchQueue.main.async {
                    self?.chats = chats
                    self?.conversations = ChatMapper.map(chats: chats)
                }
                completion(.success(chats))
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
                completion(.failure(error))
            }
        }
    }
    
    func deleteChat(conversation: Conversation) {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMyIsImlhdCI6MTcyMDYzNzk4NywiZXhwIjoxNzIzMjI5OTg3fQ.hXfoJkQ7eEgvYBgZ4XG_shUxICO9gM0A5Gc2q51zunE"
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
    
}
