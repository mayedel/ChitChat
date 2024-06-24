//
//  UsersApiService.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation
import Alamofire

protocol UsersAPIServiceProtocol {
    func getUserProfile(token: String, completion: @escaping (Result<User, Error>) -> Void)
    func getUsers(token: String, completion: @escaping (Result<[User], Error>) -> Void)
    func loginUser(login: String, password: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void)
    func biometricLogin(token: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void)
    func logoutUser(token: String, completion: @escaping (Result<String, Error>) -> Void)
    func changeOnlineStatus(token: String, completion: @escaping (Result<String, Error>) -> Void)
    func registerUser(user: User, completion: @escaping (Result<User, Error>) -> Void)
    func uploadUser(id: String, token: String, parameters: [String: String], file: Data?, completion: @escaping (Result<String, Error>) -> Void)
}

class UsersAPIService: UsersAPIServiceProtocol {
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getUserProfile(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        let headers: HTTPHeaders =  ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users/profile", method: .get, headers: headers, body: nil, completion: completion)
    }
    
    func getUsers(token: String, completion: @escaping (Result<[User], Error>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users", method: .get, headers: headers, body: nil, completion: completion)
    }
    
    func loginUser(login: String, password: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void) {
        let body: [String: Any] = ["login": login, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body"])))
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "*/*"
        ]
        
        apiManager.request(endpoint: "api/users/login", method: .post, headers: headers, body: bodyData) { (result: Result<UserLoginResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success((response.token, response.user)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func biometricLogin(token: String, completion: @escaping (Result<(String, UserPartial), Error>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users/biometric", method: .post, headers: headers, body: nil) { (result: Result<UserLoginResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success((response.token, response.user)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users/logout", method: .post, headers: headers, body: nil) { (result: Result<MessageResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeOnlineStatus(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        let headers: HTTPHeaders = ["Authorization": "\(token)"]
        apiManager.request(endpoint: "api/users/online/true", method: .put, headers: headers, body: nil) { (result: Result<MessageResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "*/*"
        ]
        let body: [String: Any] = [
            "login": user.login ?? " ",
            "password": user.password ?? " ",
            "nick": user.nick ?? " ",
            "avatar": user.avatar,
            "platform": user.platform ?? " ",
            "uuid": user.uuid ?? "",
            "online": user.online
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body"])))
            return
        }
        
        apiManager.request(endpoint: "api/users/register", method: .post, headers: headers, body: bodyData) { (result: Result<RegisterResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success((response.user)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadUser(id: String, token: String, parameters: [String: String], file: Data?, completion: @escaping (Result<String, Error>) -> Void) {
            let headers: HTTPHeaders = [
                "Authorization": "\(token)",
                "Content-Type": "multipart/form-data"
            ]
            
            apiManager.upload(endpoint: "api/users/upload?id=\(id)", headers: headers, parameters: parameters, file: file) { (result: Result<MessageResponse, Error>) in
                switch result {
                case .success(let response):
                    completion(.success(response.message))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
