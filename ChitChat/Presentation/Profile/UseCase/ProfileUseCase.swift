//
//  ProfileUseCase.swift
//  ChitChat
//
//  Created by Alex Jumbo on 12/7/24.
//

import Foundation

typealias ProfileResultClosure = (Result<User, ErrorModel>) -> Void

struct ProfileUseCase {
    let userDataProvider: UserDataProvider
    
    init(userDataProvider: UserDataProvider) {
        self.userDataProvider = userDataProvider
    }
    
    func showProfile(token:String, completion: @escaping
                     ProfileResultClosure){
        userDataProvider.getUserProfile(token: token){result in
            switch result {
            case .success(let data):
                print("VALE")
                completion(.success(data))
            case .failure(let error):
                print("NO VALE")
                completion(.failure(error))
            }
            
        }
    }
}
