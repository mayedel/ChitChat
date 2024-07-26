//
//  LoginWithBiometricUseCase.swift
//  ChitChat
//
//  Created by Andres Cordón on 24/7/24.
//

import Foundation

struct LoginWithBiometricUseCase {
    
    typealias LoginWithBiometricResultClosure = (Result<LoginBiometricModel, ErrorModel>) -> Void
    
    let userDataProvider: UserDataProvider
    
    init(userDataProvider: UserDataProvider) {
        self.userDataProvider = userDataProvider
    }
    
    func loginWithBiometric(completion: @escaping LoginWithBiometricResultClosure) {
        userDataProvider.biometricLogin(token: ChitChatDefaultsManager.shared.token) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
