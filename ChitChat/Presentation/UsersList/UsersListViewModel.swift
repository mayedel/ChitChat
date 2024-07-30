//
//  UsersListViewModel.swift
//  ChitChat
//
//  Created by María Espejo on 5/7/24.
//

import Foundation
import Combine
import SwiftUI

protocol UsersListViewModelProtocol {
    func getUsers()
    func createChatWith(user: User, completion: @escaping (Result<Conversation, ErrorModel>) -> Void)
}

class UsersListViewModel: UsersListViewModelProtocol, ObservableObject {
    @Published var users: [User] = []
    @Published var error: ErrorModel?
    @Published var searchText: String = ""
    @Published var createdConversation: Conversation = Conversation(id: "", name: "", message: "", unreadMessages: [], time: "", avatar: "", isUnread: false, date: "", isOnline: false, source: "")
    private var currentUserId: String?
    private let userslistUseCase: UsersListUseCase   
    
    init(userslistUseCase: UsersListUseCase) {
        self.userslistUseCase = userslistUseCase
        fetchUserProfile()
        getUsers()
    }
    
    var filteredContacts: [UserList] {
        let mappedUsers = UserMapper.map(users: users)
        if searchText.isEmpty {
            return mappedUsers
        } else {
            return mappedUsers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    
    func getUsers() {
        let token = ChitChatDefaultsManager.shared.token
        userslistUseCase.getUsers(token: token) { [weak self] result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self?.users = users
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
    func fetchUserProfile() {
        let token = ChitChatDefaultsManager.shared.token
        userslistUseCase.getUserProfile(token: token) { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUserId = user.id
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
    func createChatWith(user: User, completion: @escaping (Result<Conversation, ErrorModel>) -> Void) {
        let token = ChitChatDefaultsManager.shared.token
        userslistUseCase.createChat(source: ChitChatDefaultsManager.shared.userId, target: user.id, token: token) { result in
            switch result {
            case .success(let chatResponse):
                let conversation = Conversation(
                    id: chatResponse.id,
                    name: user.nick ?? "",
                    message: "", unreadMessages: [],
                    time: DateFormatter.formatDate(dateString: chatResponse.created),
                    avatar: user.avatar,
                    isUnread: false,
                    date: chatResponse.created,
                    isOnline: user.online,
                    source: chatResponse.source
                )
                completion(.success(conversation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createConversation(for userList: UserList, completion: @escaping (Bool) -> Void) {
        guard let user = users.first(where: { $0.id == userList.id }) else {
            return
        }
        
        createChatWith(user: user) { result in
            switch result {
            case .success(let conversation):
                self.createdConversation = conversation
                completion(true)
            case .failure(let error):
                print("Failed to create conversation: \(error)")
                completion(false)
            }
        }
    }
    
}
