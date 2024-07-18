//
//  UsersApiService.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation
import Alamofire

protocol UsersAPIServiceProtocol {
    func getUserProfile(token: String, completion: @escaping (Result<User, ErrorModel>) -> Void)
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void)
    func loginUser(login: String, password: String, completion: @escaping (Result<LoginModel, ErrorModel>) -> Void)
    func biometricLogin(token: String, completion: @escaping (Result<(String, UserPartial), ErrorModel>) -> Void)
    func logoutUser(token: String, completion: @escaping (Result<String, ErrorModel>) -> Void)
    func changeOnlineStatus(token: String, completion: @escaping (Result<String, ErrorModel>) -> Void)
    func registerUser(user: RegisterUserModel, completion: @escaping (Result<RegisterModel, ErrorModel>) -> Void)
    func uploadUser(id: String, token: String, parameters: [String: String], file: Data?, completion: @escaping (Result<String, ErrorModel>) -> Void)
}

class UsersAPIService: UsersAPIServiceProtocol {
    private let apiManager: APIManagerProtocol
    private let errorMapper: ErrorMapper = ErrorMapper()
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getUserProfile(token: String, completion: @escaping (Result<User, ErrorModel>) -> Void) {
        let headers: HTTPHeaders =  ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users/profile", method: .get, headers: headers, body: nil, completion: { (result: Result<User, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        })
    }
    
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users", method: .get, headers: headers, body: nil, completion: { (result: Result<[User], AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
            
        })
    }
    
    func loginUser(login: String, password: String, completion: @escaping (Result<LoginModel, ErrorModel>) -> Void) {
        let body: [String: Any] = ["login": login, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(errorMapper.mapErrorResponse(error: AFError.parameterEncoderFailed(reason: AFError.ParameterEncoderFailureReason.encoderFailed(error: "Invalid Error" as! Error)))))
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "*/*"
        ]
        
        apiManager.request(endpoint: "api/users/login", method: .post, headers: headers, body: bodyData) { (result: Result<UserLoginResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(LoginDTOMapperImpl().map(response)))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        }
    }
    
    func biometricLogin(token: String, completion: @escaping (Result<(String, UserPartial), ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users/biometric", method: .post, headers: headers, body: nil) { (result: Result<UserLoginResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success((response.token, response.user)))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        }
    }
    
    func logoutUser(token: String, completion: @escaping (Result<String, ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users/logout", method: .post, headers: headers, body: nil) { (result: Result<MessageResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response.message))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        }
    }
    
    func changeOnlineStatus(token: String, completion: @escaping (Result<String, ErrorModel>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users/online/true", method: .put, headers: headers, body: nil) { (result: Result<MessageResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(response.message))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        }
    }
    
    func registerUser(user: RegisterUserModel, completion: @escaping (Result<RegisterModel, ErrorModel>) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "*/*"
        ]
        let body: [String: Any] = [
            "login": user.login,
            "password": user.password,
            "nick": user.nick,
            "platform": user.platform,
            "online": user.online
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(errorMapper.mapErrorResponse(error: AFError.parameterEncoderFailed(reason: AFError.ParameterEncoderFailureReason.encoderFailed(error: "Invalid Error" as! Error)))))
            return
        }
        
        apiManager.request(endpoint: "api/users/register", method: .post, headers: headers, body: bodyData) { (result: Result<UserRegisterResponse, AFError>) in
            switch result {
            case .success(let response):
                completion(.success(RegisterDTOMapperImpl().map(response)))
            case .failure(let error):
                completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
            }
        }
    }
    
    func uploadUser(id: String, token: String, parameters: [String: String], file: Data?, completion: @escaping (Result<String, ErrorModel>) -> Void) {
            let headers: HTTPHeaders = [
                "Authorization": "\(token)",
                "Content-Type": "multipart/form-data"
            ]
            
            apiManager.upload(endpoint: "api/users/upload?id=\(id)", headers: headers, parameters: parameters, file: file) { (result: Result<MessageResponse, AFError>) in
                switch result {
                case .success(let response):
                    completion(.success(response.message))
                case .failure(let error):
                    completion(.failure(self.errorMapper.mapErrorResponse(error: error)))
                }
            }
        }
}
