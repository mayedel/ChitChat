//
//  ActiveChatsUseCase.swift
//  ChitChat
//
//  Created by María Espejo on 9/7/24.
//

import Foundation

struct ActiveChatsUseCase {
    let chatDataProvider: ChatDataProvider
    let messageDataProvider: MessageDataProvider
    private let userDataProvider: UserDataProvider
    
    init(chatDataProvider: ChatDataProvider, messageDataProvider: MessageDataProvider, userDataProvider: UserDataProvider) {
        self.chatDataProvider = chatDataProvider
        self.messageDataProvider = messageDataProvider
        self.userDataProvider = userDataProvider
    }
    
    func getActiveChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
            chatDataProvider.getChats(token: token, completion: completion)
        }
    
    func deleteChat(id: String, token: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        chatDataProvider.deleteChat(id: id, token: token, completion: completion)
    }
    
    func getLastMessages(token: String, chatId: String, completion: @escaping (Result<[Message], ErrorModel>) -> Void) {
        messageDataProvider.getMessagesList(token: token, chatId: chatId, offset: 0, limit: 50) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserProfile(token: String, completion: @escaping (Result<User, ErrorModel>) -> Void) {
        userDataProvider.getUserProfile(token: token, completion: completion)
    }


    func getUsersProfile(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void) {
        userDataProvider.getUsers(token: token, completion: completion)
    }

}
