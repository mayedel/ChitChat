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
    @Published var searchText: String = ""
    private let userslistUseCase: UsersListUseCase
    
    init(userslistUseCase: UsersListUseCase) {
        self.userslistUseCase = userslistUseCase
    }
    
    var filteredContacts: [UserList] {
        let mappedUsers = UserMapper.map(users: users)
        
        if searchText.isEmpty {
            return mappedUsers
        } else {
            return mappedUsers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    
    func getUsers(token: String, completion: @escaping (Result<[User], ErrorModel>) -> Void) {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYwMyIsImlhdCI6MTcyMDYzNzk4NywiZXhwIjoxNzIzMjI5OTg3fQ.hXfoJkQ7eEgvYBgZ4XG_shUxICO9gM0A5Gc2q51zunE"
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
