//
//  GetMessagesListUseCase.swift
//  ChitChat
//
//  Created by Andres Cordón on 22/7/24.
//

import Foundation

typealias GetMessagesListResultClosure = (Result<[Message], ErrorModel>) -> Void

struct GetMessagesListUseCase {
    let messageDataProvider: MessageDataProvider
    
    init(messageDataProvider: MessageDataProvider) {
        self.messageDataProvider = messageDataProvider
    }
    
    func getMessagesList(chatId: String, offset: Int = 0, limit: Int = 100, completion: @escaping GetMessagesListResultClosure) {
        messageDataProvider.getMessagesList(token: ChitChatDefaultsManager.shared.token, chatId: chatId, offset: offset, limit: limit, completion: { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

