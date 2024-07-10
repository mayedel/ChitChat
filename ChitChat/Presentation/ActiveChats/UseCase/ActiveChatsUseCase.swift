//
//  ActiveChatsUseCase.swift
//  ChitChat
//
//  Created by María Espejo on 9/7/24.
//

import Foundation

struct ActiveChatsUseCase {
    let chatDataProvider: ChatDataProvider
    
    init(chatDataProvider: ChatDataProvider) {
        self.chatDataProvider = chatDataProvider
    }
    
    func getActiveChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        chatDataProvider.getActiveChats(token: token, completion: completion)
    }
}
