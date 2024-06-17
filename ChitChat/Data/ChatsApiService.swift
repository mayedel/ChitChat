//
//  ChatsApiService.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

protocol ChatsAPIServiceProtocol {
    func getChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void)
    func createChat(source: String, target: String, token: String, completion: @escaping (Result<(Bool, Bool, Chat), Error>) -> Void)
    func deleteChat(id: String, token: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func getActiveChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void)
}

class ChatsAPIService: ChatsAPIServiceProtocol {
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/chats", method: "GET", headers: headers, body: nil, completion: completion)
    }
    
    func createChat(source: String, target: String, token: String, completion: @escaping (Result<(Bool, Bool, Chat), Error>) -> Void) {
        let headers = ["token": token]
        let body = ["source": source, "target": target]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body"])))
            return
        }
        
        apiManager.request(endpoint: "api/chats", method: "POST", headers: headers, body: bodyData) { (result: Result<CreateChatResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success((response.success, response.created, response.chat)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteChat(id: String, token: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/chats/\(id)", method: "DELETE", headers: headers, body: nil) { (result: Result<DeleteChatResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getActiveChats(token: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/chats/list", method: "GET", headers: headers, body: nil, completion: completion)
    }
}
