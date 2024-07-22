//
//  UsersListUseCase.swift
//  ChitChat
//
//  Created by María Espejo on 5/7/24.
//

import Foundation

struct UsersListUseCase {
    let userDataProvider: UserDataProvider
    let chatDataProvider: ChatDataProvider
    
    init(userDataProvider: UserDataProvider, chatDataProvider: ChatDataProvider) {
        self.userDataProvider = userDataProvider
        self.chatDataProvider = chatDataProvider
    }
    
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void) {
        userDataProvider.getUsers(token: token) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserProfile(token: String, completion: @escaping (Result<User, ErrorModel>) -> Void) {
        userDataProvider.getUserProfile(token: token, completion: completion)
    }
    
    func createChat(source: String, target: String, token: String, completion: @escaping (Result<Chat, ErrorModel>) -> Void) {
        chatDataProvider.createChat(source: source, target: target, token: token) { result in
            switch result {
            case .success(let chatResponse):
                let chat = chatResponse.2
                completion(.success(chat))
            case .failure(let error):
                let errorModel = ErrorModel(code: Int?(Int()), message: error.localizedDescription)
                completion(.failure(errorModel))
            }
        }
    }
}
