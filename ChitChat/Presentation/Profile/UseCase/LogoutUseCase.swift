//
//  LogOutUseCase.swift
//  ChitChat
//
//  Created by Andres Cordón on 24/7/24.
//

import Foundation

typealias LogoutResultClosure = (Result<String, ErrorModel>) -> Void

struct LogoutUseCase {
    let userDataProvider: UserDataProvider
    
    init(userDataProvider: UserDataProvider) {
        self.userDataProvider = userDataProvider
    }
    
    func logout(completion: @escaping LogoutResultClosure) {
        userDataProvider.logoutUser(token: ChitChatDefaultsManager.shared.token) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
