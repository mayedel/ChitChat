//
//  DataProvider.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

protocol DataProviderProtocol {
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void)
    func getChats(completion: @escaping (Result<[Chat], Error>) -> Void)
    func getMessages(for chatId: String, completion: @escaping (Result<[Message], Error]) -> Void)
}

class DataProvider: DataProviderProtocol {
    private let usersService: UsersAPIServiceProtocol
    private let chatsService: ChatsAPIServiceProtocol
    private let messagesService: MessagesAPIServiceProtocol
    
    init(usersService: UsersAPIServiceProtocol, chatsService: ChatsAPIServiceProtocol, messagesService: MessagesAPIServiceProtocol) {
        self.usersService = usersService
        self.chatsService = chatsService
        self.messagesService = messagesService
    }
    
    func getUsers(completion: @escaping (Result<[User], Error]) -> Void) {
        usersService.getUsers(token: "YOUR_TOKEN") { result in
            switch result {
            case .success(let apiUsers):
                let users = apiUsers.map { UserMapper.map(apiUser: $0) }
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getChats(completion: @escaping (Result<[Chat], Error]) -> Void) {
        chatsService.getChats(token: "YOUR_TOKEN") { result in
            switch result {
            case .success(let apiChats):
                let chats = apiChats.map { ChatMapper.map(apiChat: $0) }
                completion(.success(chats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMessages(for chatId: String, completion: @escaping (Result<[Message], Error]) -> Void) {
        messagesService.getAllMessages(token: "YOUR_TOKEN") { result in
            switch result {
            case .success(let apiMessages):
                let messages = apiMessages.map { MessageMapper.map(apiMessage: $0) }
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

