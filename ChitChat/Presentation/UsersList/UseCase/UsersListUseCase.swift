//
//  UsersListUseCase.swift
//  ChitChat
//
//  Created by María Espejo on 5/7/24.
//

import Foundation

struct UsersListUseCase {
    let userDataProvider: UserDataProvider
    
    init(userDataProvider: UserDataProvider) {
        self.userDataProvider = userDataProvider
    }
    
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void) {
        userDataProvider.getUsers(token: token) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
