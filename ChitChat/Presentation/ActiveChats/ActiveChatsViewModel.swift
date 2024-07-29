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
    @Published var chats: [Chat] = []
    @Published var conversations: [Conversation] = []
    @Published var error: Error?
    @Published var searchText: String = ""
    @Published var showCustomAlert = false
    @Published var alertType: AlertType = .success
    private var hiddenConversations: Set<String> = []
    @Published var conversationToDelete: Conversation?
    private var currentUserId: String?
    
    private let chatsListUseCase: ActiveChatsUseCase
    
    init(chatsListUseCase: ActiveChatsUseCase) {
        self.chatsListUseCase = chatsListUseCase
        getActiveChats { _ in }
        fetchUserProfile()
    }
    
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return conversations.filter { !hiddenConversations.contains($0.id) }
        } else {
            return conversations.filter { !hiddenConversations.contains($0.id) && $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func fetchUserProfile() {
        let token = ChitChatDefaultsManager.shared.token
        chatsListUseCase.getUserProfile(token: token) { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUserId = user.id
                self?.getActiveChats { _ in }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
    func getActiveChats(completion: @escaping (Result<[Conversation], Error>) -> Void) {
        let token = ChitChatDefaultsManager.shared.token
        chatsListUseCase.getActiveChats(token: token) { [weak self] result in
            switch result {
            case .success(let chats):
                DispatchQueue.main.async { [self] in
                    guard let self = self, let currentUserId = self.currentUserId else { return }
                    let filteredChats = chats.filter { $0.source == currentUserId || $0.target == currentUserId }
                    self.processChats(filteredChats, token: token, currentUserId: currentUserId)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                    completion(.failure(error))
                }
            }
        }
    }
    
    func processChats(_ filteredChats: [Chat], token: String, currentUserId: String) {
        chatsListUseCase.getUsersProfile(token: token) { [weak self] result in
            switch result {
            case .success(let users):
                let userProfiles = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
             //   self?.conversations = ChatMapper.map(chats: filteredChats, userProfiles: userProfiles, currentUserId: currentUserId)
                self?.getLastMessage(chats: filteredChats, userProfiles: userProfiles, currentUserId: currentUserId, token: token)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }

    
    func deleteChat(conversation: Conversation) {
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
    
    func showDeleteConfirmation(conversation: Conversation) {
        if conversation.source == currentUserId {
            deleteChat(conversation: conversation)
        } else {
            self.conversationToDelete = conversation
            self.alertType = .error(title: LocalizedStringKey("EliminateChatDialogTitle").stringValue(), message: LocalizedStringKey("EliminateChatDialogMessage").stringValue(), icon: "message")
            self.showCustomAlert = true
        }
    }
    
    func hideConversation(conversation: Conversation) {
        hiddenConversations.insert(conversation.id)
        showCustomAlert = false
    }
    
    func getLastMessage(chats: [Chat], userProfiles: [String: User], currentUserId: String, token: String) {
        let group = DispatchGroup()
        var lastMessages = [String: (message: String, date: String)]()
        
        for chat in chats  {
                    group.enter()
                  //  let chatId = conversation.id
                    chatsListUseCase.getLastMessage(token: token, chatId: chat.id) { result in
                        switch result {
                        case .success(let messageDetails):
                            lastMessages[chat.id] = (message: messageDetails.message, date: messageDetails.date)
                        case .failure(let error):
                            print("Error fetching last message for \(chat.id): \(error)")
                            lastMessages[chat.id] = (message: "No hay mensajes.", date: "")
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.conversations = ChatMapper.map(chats: chats, userProfiles: userProfiles, currentUserId: currentUserId, lastMessages: lastMessages)
               //     self.conversations = ChatMapper.updateConversations(self.conversations, withMessages: messagesDetails)
                }
            }
            
            func markMessageAsRead(chatId: String, messageId: String, date: String) {
                    ChitChatDefaultsManager.shared.saveLastReadMessage(chatId: chatId, messageId: messageId, date: date)
                }
            
    
    
    
}
