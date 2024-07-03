//
//  LoginUseCase.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import Foundation

typealias LoginResultClosure = (Result<LoginModel, ErrorModel>) -> Void

struct LoginUseCase {
    let userDataProvider: UserDataProvider
    
    init(userDataProvider: UserDataProvider) {
        self.userDataProvider = userDataProvider
    }
    
    func userLogin(login: String, password: String, completion: @escaping LoginResultClosure) {
        userDataProvider.loginUser(login: login, password: password) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}



