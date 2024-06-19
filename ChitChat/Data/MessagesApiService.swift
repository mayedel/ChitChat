//
//  MessagesApiService.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation
import Alamofire

protocol MessagesAPIServiceProtocol {
    func getAllMessages(token: String, completion: @escaping (Result<[Message], Error>) -> Void)
    func createMessage(chat: String, source: String, message: String, token: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func viewMessages(token: String, completion: @escaping (Result<[MessageView], Error>) -> Void)
    func getMessagesList(token: String, offset: Int, limit: Int, completion: @escaping (Result<MessagesListResponse, Error>) -> Void)
}

class MessagesAPIService: MessagesAPIServiceProtocol {
    private let apiManager: APIManagerProtocol
        
        init(apiManager: APIManagerProtocol) {
            self.apiManager = apiManager
        }
        
        func getAllMessages(token: String, completion: @escaping (Result<[Message], Error>) -> Void) {
            let headers: HTTPHeaders = ["Authorization": "\(token)"]
            apiManager.request(endpoint: "api/messages", method: .get, headers: headers, body: nil, completion: completion)
        }
    
    func createMessage(chat: String, source: String, message: String, token: String, completion: @escaping (Result<Bool, Error>) -> Void) {
           let headers: HTTPHeaders = ["Authorization": "\(token)"]
           let body: [String: Any] = ["chat": chat, "source": source, "message": message]
           
           guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
               completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body"])))
               return
           }
           
           apiManager.request(endpoint: "api/messages/new", method: .post, headers: headers, body: bodyData) { (result: Result<CreateMessageResponse, Error>) in
               switch result {
               case .success(let response):
                   completion(.success(response.success))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
    func viewMessages(token: String, completion: @escaping (Result<[MessageView], Error>) -> Void) {
           let headers: HTTPHeaders = ["Authorization": "\(token)"]
           apiManager.request(endpoint: "api/messages/view", method: .get, headers: headers, body: nil, completion: completion)
       }
       
       func getMessagesList(token: String, offset: Int, limit: Int, completion: @escaping (Result<MessagesListResponse, Error>) -> Void) {
           let headers: HTTPHeaders = ["Authorization": "\(token)"]
           let endpoint = "api/messages/list?offset=\(offset)&limit=\(limit)"
           apiManager.request(endpoint: endpoint, method: .get, headers: headers, body: nil, completion: completion)
       }
   }
