//
//  UserDataProvider.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

protocol UserDataProviderProtocol {
    func getUserProfile(token: String, completion: @escaping (Result<User, ErrorModel>) -> Void)
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void)
    func loginUser(login: String, password: String, completion: @escaping (Result<LoginModel, ErrorModel>) -> Void)
    func registerUser(user: RegisterUserModel, completion: @escaping (Result<RegisterModel, ErrorModel>) -> Void)
    func biometricLogin(token: String, completion: @escaping (Result<LoginBiometricModel, ErrorModel>) -> Void)
    func logoutUser(token: String, completion: @escaping (Result<String, ErrorModel>) -> Void)
    func changeOnlineStatus(status: Bool, token: String, completion: @escaping (Result<String, ErrorModel>) -> Void)
    func uploadUser(id: String, token: String, parameters: [String: String], file: Data?, completion: @escaping (Result<String, ErrorModel>) -> Void)
}

class UserDataProvider: UserDataProviderProtocol {
    
    private let usersService: UsersAPIServiceProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.usersService = UsersAPIService(apiManager: apiManager)
    }
    
    func getUserProfile(token: String, completion: @escaping (Result<User, ErrorModel>) -> Void) {
        usersService.getUserProfile(token: token) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void) {
        usersService.getUsers(token: token) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(login: String, password: String, completion: @escaping (Result<LoginModel, ErrorModel>) -> Void) {
        usersService.loginUser(login: login, password: password) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registerUser(user: RegisterUserModel, completion: @escaping (Result<RegisterModel, ErrorModel>) -> Void) {
        usersService.registerUser(user: user) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func biometricLogin(token: String, completion: @escaping (Result<LoginBiometricModel, ErrorModel>) -> Void){
        usersService.biometricLogin(token: token) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logoutUser(token: String, completion: @escaping (Result<String, ErrorModel>) -> Void) {
        usersService.logoutUser(token: token) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeOnlineStatus(status: Bool, token: String, completion: @escaping (Result<String, ErrorModel>) -> Void) {
        usersService.changeOnlineStatus(status: status, token: token) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadUser(id: String, token: String, parameters: [String: String], file: Data?, completion: @escaping (Result<String, ErrorModel>) -> Void) {
        usersService.uploadUser(id: id, token: token, parameters: parameters, file: file) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
