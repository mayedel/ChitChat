//
//  CreateMessageUseCase.swift
//  ChitChat
//
//  Created by Andres Cordón on 22/7/24.
//

import Foundation


typealias CreateMessageResultClosure = (Result<Bool, ErrorModel>) -> Void

struct CreateMessageUseCase {
    let messageDataProvider: MessageDataProvider
    
    init(messageDataProvider: MessageDataProvider) {
        self.messageDataProvider = messageDataProvider
    }
    
    func createNewMessage(chatId: String, message: String ,completion: @escaping CreateMessageResultClosure) {
        messageDataProvider.createMessage(chat: chatId, source: ChitChatDefaultsManager.shared.userId, message: message, token: ChitChatDefaultsManager.shared.token) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
