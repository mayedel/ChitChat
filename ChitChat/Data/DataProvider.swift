//
//  DataProvider.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

protocol DataProviderProtocol {
    func getUserProfile(token: String, completion: @escaping (Result<User, Error>) -> Void)
    func getUsers(token: String, completion: @escaping (Result<[User], Error>) -> Void)
    func loginUser(login: String, password: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void)
    func registerUser(user: User, completion: @escaping (Result<User, Error>) -> Void)
    func biometricLogin(token: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void)
    func logoutUser(token: String, completion: @escaping (Result<String, Error>) -> Void)
    func changeOnlineStatus(token: String, completion: @escaping (Result<String, Error>) -> Void)
    func uploadUser(id: String, token: String, parameters: [String: String], file: Data?, completion: @escaping (Result<String, Error>) -> Void)
        
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
    
    func getUserProfile(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        usersService.getUserProfile(token: token) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
        usersService.loginUser(login: login, password: password) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        usersService.registerUser(user: user) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func biometricLogin(token: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void){
        usersService.biometricLogin(token: token) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        usersService.logoutUser(token: token) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeOnlineStatus(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        usersService.changeOnlineStatus(token: token) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadUser(id: String, token: String, parameters: [String: String], file: Data?, completion: @escaping (Result<String, Error>) -> Void) {
        usersService.uploadUser(id: id, token: token, parameters: parameters, file: file) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
