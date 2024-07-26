//
//  ChangeOnlineStatusUseCase.swift
//  ChitChat
//
//  Created by Andres Cordón on 26/7/24.
//

import Foundation

typealias ChangeOnlineStatusResultClosure = (Result<String, ErrorModel>) -> Void

struct  ChangeOnlineStatusUseCase {
    let userDataProvider: UserDataProvider
    
    init(userDataProvider: UserDataProvider) {
        self.userDataProvider = userDataProvider
    }
    
    func changeOnlineStatusUseCase(status: Bool, completion: @escaping ChangeOnlineStatusResultClosure) {
        userDataProvider.changeOnlineStatus(status: status, token: ChitChatDefaultsManager.shared.token) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
