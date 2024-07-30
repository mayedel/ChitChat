//
//  MessageDataProvider.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

protocol MessageDataProviderProtocol {
    func getAllMessages(token: String, completion: @escaping (Result<[MessageModel], ErrorModel>) -> Void)
    func createMessage(chat: String, source: String, message: String, token: String, completion: @escaping (Result<Bool, ErrorModel>) -> Void)
    func viewMessages(token: String, completion: @escaping (Result<[MessageView], ErrorModel>) -> Void)
    func getMessagesList(token: String, chatId: String, offset: Int, limit: Int, completion: @escaping (Result<[MessageModel], ErrorModel>) -> Void)
}

class MessageDataProvider: MessageDataProviderProtocol {
    
    private let messagesService: MessagesAPIServiceProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.messagesService = MessagesAPIService(apiManager: apiManager)
    }

    func getAllMessages(token: String, completion: @escaping (Result<[MessageModel], ErrorModel>) -> Void) {
        messagesService.getAllMessages(token: token) { result in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createMessage(chat: String, source: String, message: String, token: String, completion: @escaping (Result<Bool, ErrorModel>) -> Void) {
        messagesService.createMessage(chat: chat, source: source, message: message, token: token) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func viewMessages(token: String, completion: @escaping (Result<[MessageView], ErrorModel>) -> Void) {
        messagesService.viewMessages(token: token) { result in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMessagesList(token: String, chatId: String, offset: Int, limit: Int, completion: @escaping (Result<[MessageModel], ErrorModel>) -> Void) {
        messagesService.getMessagesList(token: token, chatId: chatId, offset: offset, limit: limit) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
