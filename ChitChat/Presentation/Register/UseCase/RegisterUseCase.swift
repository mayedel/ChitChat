//
//  RegisterUseCase.swift
//  ChitChat
//
//  Created by Andres Cordón on 18/7/24.
//

import Foundation

typealias RegisterResultClosure = (Result<RegisterModel, ErrorModel>) -> Void

struct RegisterUseCase {
    let userDataProvider: UserDataProvider
    
    init(userDataProvider: UserDataProvider) {
        self.userDataProvider = userDataProvider
    }
    
    func registerUser(user: RegisterUserModel, completion: @escaping RegisterResultClosure) {
        userDataProvider.registerUser(user: user) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
