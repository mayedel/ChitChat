//
//  ChatsApiService.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation
import Alamofire

protocol ChatsAPIServiceProtocol {
    func getChats(token: String, completion: @escaping (Result<[Chat], ErrorModel>) -> Void)
    func createChat(source: String, target: String, token: String, completion: @escaping (Result<(Bool, Bool, Chat), ErrorModel>) -> Void)
    func deleteChat(id: String, token: String, completion: @escaping (Result<Bool, ErrorModel>) -> Void)
    func getChatViews(token: String, completion: @escaping (Result<[ChatView], ErrorModel>) -> Void)
    func getActiveChats(token: String, completion: @escaping (Result<[Chat], ErrorModel>) -> Void)
}

class ChatsAPIService: ChatsAPIServiceProtocol {
    private let apiManager: APIManagerProtocol
    private let errorMapper: ErrorMapper = ErrorMapper()
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getChats(token: String, completion: @escaping (Result<[Chat], ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/chats", method: .get, headers: headers, body: nil, completion: { (result: Result<[Chat], AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
            
        })
    }
    
    func createChat(source: String, target: String, token: String, completion: @escaping (Result<(Bool, Bool, Chat), ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        let body = ["source": source, "target": target]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(errorMapper.mapErrorResponse(error: AFError.parameterEncoderFailed(reason: AFError.ParameterEncoderFailureReason.encoderFailed(error: "Invalid Error" as! Error)))))
            return
        }
        
        apiManager.request(endpoint: "api/chats", method: .post, headers: headers, body: bodyData) { (result: Result<ChatResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success((response.success, response.created, response.chat)))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        }
    }
    
    func deleteChat(id: String, token: String, completion: @escaping (Result<Bool, ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/chats/\(id)", method: .delete, headers: headers, body: nil) { (result: Result<DeleteChatResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        }
    }
    
    func getChatViews(token: String, completion: @escaping (Result<[ChatView], ErrorModel>) -> Void) {
            let headers: HTTPHeaders = ["Authorization": "\(token)"]
            apiManager.request(endpoint: "api/chats/view", method: .get, headers: headers, body: nil, completion: { (result: Result<[ChatView], AFError>) in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
                }
            })
        }
    
    func getActiveChats(token: String, completion: @escaping (Result<[Chat], ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/chats/list", method: .get, headers: headers, body: nil, completion: { (result: Result<[Chat], AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        })
    }
}
