//
//  ActiveChatsViewModel.swift
//  ChitChat
//
//  Created by María Espejo on 9/7/24.
//

import Foundation
import Combine
import SwiftUI

protocol ChatsListViewModelProtocol {
    func getActiveChats(completion: @escaping (Result<[Chat], Error>) -> Void)
}

class ActiveChatsViewModel: ObservableObject, ChatsListViewModelProtocol {
    @Published var chats: [Chat] = []
    @Published var error: Error?
    private let chatsListUseCase: ChatsListUseCase
    
    init(chatsListUseCase: ChatsListUseCase) {
        self.chatsListUseCase = chatsListUseCase
    }
    
    func getActiveChats(completion: @escaping (Result<[Chat], Error>) -> Void) {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjcyOCIsImlhdCI6MTcyMDQ2NjA0OCwiZXhwIjoxNzIzMDU4MDQ4fQ.687ZoLITfGwkAK9d5DuSnXRhZzj3c5XVKSmzFae9Xc4"
        chatsListUseCase.getActiveChats(token: token) { [weak self] result in
            switch result {
            case .success(let chats):
                DispatchQueue.main.async {
                    self?.chats = chats
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
}
