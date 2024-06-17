//
//  UsersApiService.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

import Foundation

protocol UsersAPIServiceProtocol {
    func getUserProfile(token: String, completion: @escaping (Result<User, Error>) -> Void)
    func getUsers(token: String, completion: @escaping (Result<[User], Error>) -> Void)
    func loginUser(login: String, password: String, completion: @escaping (Result<(String, User), Error>) -> Void)
    func biometricLogin(token: String, completion: @escaping (Result<(String, User), Error>) -> Void)
    func logoutUser(token: String, completion: @escaping (Result<String, Error>) -> Void)
    func changeOnlineStatus(token: String, completion: @escaping (Result<String, Error>) -> Void)
    func registerUser(user: User, completion: @escaping (Result<(Bool, User), Error>) -> Void)
    func uploadUser(id: String, token: String, file: Data, completion: @escaping (Result<String, Error>) -> Void)
}

class UsersAPIService: UsersAPIServiceProtocol {
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getUserProfile(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/users/profile", method: "GET", headers: headers, body: nil, completion: completion)
    }
    
    func getUsers(token: String, completion: @escaping (Result<[User], Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/users", method: "GET", headers: headers, body: nil, completion: completion)
    }
    
    func loginUser(login: String, password: String, completion: @escaping (Result<(String, User), Error>) -> Void) {
        let body = ["login": login, "password": password]
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body"])))
            return
        }
        
        apiManager.request(endpoint: "api/users/login", method: "POST", headers: nil, body: bodyData) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success((response.token, response.user)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func biometricLogin(token: String, completion: @escaping (Result<(String, User), Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/users/biometric", method: "POST", headers: headers, body: nil) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success((response.token, response.user)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/users/logout", method: "POST", headers: headers, body: nil) { (result: Result<LogoutResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeOnlineStatus(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/users/online", method: "PUT", headers: headers, body: nil) { (result: Result<OnlineStatusResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerUser(user: User, completion: @escaping (Result<(Bool, User), Error>) -> Void) {
        let body: [String: Any] = [
            "login": user.login,
            "password": user.password,
            "nick": user.nick,
            "avatar": user.avatar,
            "platform": user.platform,
            "uuid": user.uuid ?? "",
            "online": user.online
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body"])))
            return
        }
        
        apiManager.request(endpoint: "api/users/register", method: "POST", headers: nil, body: bodyData) { (result: Result<RegisterResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success((response.success, response.user)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadUser(id: String, token: String, file: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let headers = ["token": token]
        apiManager.request(endpoint: "api/users/upload/\(id)", method: "POST", headers: headers, body: file) { (result: Result<UploadResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
