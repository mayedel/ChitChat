//
//  ChatDataProvider.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

protocol ChatDataProviderProtocol {
    func getChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void)
    func createChat(source: String, target: String, token: String, completion: @escaping (Result<(Bool, Bool, Chat), Error>) -> Void)
    func deleteChat(id: Int, token: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func getChatViews(token: String, completion: @escaping (Result<[ChatView], Error>) -> Void)
    func getActiveChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void)
}

class ChatDataProvider: ChatDataProviderProtocol {
    private let chatsService: ChatsAPIServiceProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.chatsService = ChatsAPIService(apiManager: apiManager)
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
    
    func createChat(source: String, target: String, token: String, completion: @escaping (Result<(Bool, Bool, Chat), Error>) -> Void) {
        chatsService.createChat(source: source, target: target, token: token) { result in
            switch result {
            case .success(let chatResponse):
                completion(.success(chatResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteChat(id: Int, token: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        chatsService.deleteChat(id: id, token: token) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getChatViews(token: String, completion: @escaping (Result<[ChatView], Error>) -> Void) {
        chatsService.getChatViews(token: token) { result in
            switch result {
            case .success(let chatViews):
                completion(.success(chatViews))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getActiveChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        chatsService.getActiveChats(token: token) { result in
            switch result {
            case .success(let chats):
                completion(.success(chats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
