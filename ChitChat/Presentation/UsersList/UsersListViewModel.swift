//
//  UsersListViewModel.swift
//  ChitChat
//
//  Created by María Espejo on 5/7/24.
//

import Foundation
import Combine
import SwiftUI

protocol UsersListViewModelProtocol {
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void)
}

class UsersListViewModel: UsersListViewModelProtocol, ObservableObject {
    @Published var users: [User] = []
    @Published var error: ErrorModel?
    private let userslistUseCase: UsersListUseCase
    
    init(userslistUseCase: UsersListUseCase) {
        self.userslistUseCase = userslistUseCase
    }
    
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void) {
        userslistUseCase.getUsers(token: token) { [weak self] result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self?.users = users
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
    
}
