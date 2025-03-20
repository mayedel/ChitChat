//
//  MessagesApiService.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation
import Alamofire

protocol MessagesAPIServiceProtocol {
    func getAllMessages(token: String, completion: @escaping (Result<[MessageModel], ErrorModel>) -> Void)
    func createMessage(chat: String, source: String, message: String, token: String, completion: @escaping (Result<Bool, ErrorModel>) -> Void)
    func viewMessages(token: String, completion: @escaping (Result<[MessageView], ErrorModel>) -> Void)
    func getMessagesList(token: String, chatId: String, offset: Int, limit: Int, completion: @escaping (Result<[MessageModel], ErrorModel>) -> Void)
}

class MessagesAPIService: MessagesAPIServiceProtocol {
    
    private let apiManager: APIManagerProtocol
    private let errorMapper: ErrorMapper = ErrorMapper()
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    //Problema redireccionamiento a HTTP
    func getAllMessages(token: String, completion: @escaping (Result<[MessageModel], ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/messages/", method: .get, headers: headers, body: nil, completion: { (result: Result<MessagesListResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(GetMessagesDTOMapperImpl().map(response)))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
            
        })
    }
    
    func createMessage(chat: String, source: String, message: String, token: String, completion: @escaping (Result<Bool, ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        let body: [String: Any] = ["chat": chat, "source": source, "message": message]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(errorMapper.mapErrorResponse(error: AFError.parameterEncoderFailed(reason: AFError.ParameterEncoderFailureReason.encoderFailed(error: "Invalid Error" as! Error)))))
            return
        }
        
        apiManager.request(endpoint: "api/messages/new", method: .post, headers: headers, body: bodyData) { (result: Result<CreateMessageResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        }
    }
    
    func viewMessages(token: String, completion: @escaping (Result<[MessageView], ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/messages/view", method: .get, headers: headers, body: nil, completion: { (result: Result<[MessageView], AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        })
    }
    
    func getMessagesList(token: String, chatId: String, offset: Int, limit: Int, completion: @escaping (Result<[MessageModel], ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        let endpoint = "api/messages/list/\(chatId)?offset=\(offset)&limit=\(limit)"
        apiManager.request(endpoint: endpoint, method: .get, headers: headers, body: nil, completion: {  (result: Result<MessagesListResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(GetMessagesDTOMapperImpl().map(response)))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        })
    }

}
