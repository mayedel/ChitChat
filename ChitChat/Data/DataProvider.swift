//
//  DataProvider.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

protocol DataProviderProtocol {
    func getUsers(token: String, completion: @escaping (Result<[User], Error>) -> Void)
    func loginUser(login: String, password: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void)
    func registerUser(user: User, completion: @escaping (Result<User, Error>) -> Void)
    func getChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void)
    func getMessages(for chatId: String, token: String, completion: @escaping (Result<[Message], Error>) -> Void)
}

class DataProvider: DataProviderProtocol {
    private let usersService: UsersAPIServiceProtocol
    private let chatsService: ChatsAPIServiceProtocol
    private let messagesService: MessagesAPIServiceProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.usersService = UsersAPIService(apiManager: apiManager)
        self.chatsService = ChatsAPIService(apiManager: apiManager)
        self.messagesService = MessagesAPIService(apiManager: apiManager)
    }
    
    func getUsers(token: String, completion: @escaping (Result<[User], Error>) -> Void) {
        usersService.getUsers(token: token) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(login: String, password: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void) {
        usersService.loginUser(login: login, password: password, completion: completion)
    }
    
    func registerUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
            usersService.registerUser(user: user, completion: completion)
        }
    
    func getChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        chatsService.getChats(token: token) { result in
            switch result {
            case .success(let chats):
                completion(.success(chats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMessages(for chatId: String, token: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        messagesService.getAllMessages(token: token) { result in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
