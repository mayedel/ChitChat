//
//  RegisterViewModel.swift
//  ChitChat
//
//  Created by Andres Cordón on 18/7/24.
//

import Foundation
import SwiftUI

class RegisterViewModel: ObservableObject {
    
    @Published var avatars = [
        AvatarItem(id: 0, image: "avatar1"),
        AvatarItem(id: 1, image: "avatar2"),
        AvatarItem(id: 2, image: "avatar3"),
        AvatarItem(id: 4, image: "avatar4"),
        AvatarItem(id: 5, image: "avatar5"),
        AvatarItem(id: 6, image: "avatar6")
    ]
    
    @Published var avatarSelected: AvatarItem? = nil
    
    @Published var userExistError: Bool = false
    @Published var userError: Bool = false
    @Published var passError: Bool = false
    @Published var passCorrectRepeatedError: Bool = false
    @Published var nickError: Bool = false
    @Published var errorMessage: String = ""
    
    private let registerUseCase: RegisterUseCase
   
    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }
    
    func registerUser(
        login: String,
        password: String,
        repeatPassword: String,
        nick: String,
        completion: @escaping (Bool) -> Void
    ) {
        let newUser = RegisterUserModel(login: login, password: password, nick: nick)
        
        if (login.isEmpty) {
            userError = true
            passError = false
            passCorrectRepeatedError = false
            nickError = false
        } else if (password.isEmpty) {
            userError = false
            passError = true
            passCorrectRepeatedError = false
            nickError = false
        } else if (password != repeatPassword) {
            userError = false
            passError = false
            passCorrectRepeatedError = true
            nickError = false
        } else if (nick.isEmpty)  {
            userError = false
            passError = false
            passCorrectRepeatedError = false
            nickError = true
        } else {
            registerUseCase.registerUser(user: newUser) { response in
                switch response {
                case .success(let data):
                    self.userExistError = false
                    self.passCorrectRepeatedError = false
                    self.errorMessage = LocalizedStringKey.init("LoginSuccess").stringValue()
                    ChitChatDefaultsManager.shared.token = data.token
                    ChitChatDefaultsManager.shared.avatar = self.avatarSelected?.image ?? "empty_avatar"
                    completion(true)
                case .failure(let error):
                    guard let code = error.code else { return }
                    switch code {
                    case 401:
                        self.userExistError = true
                        self.passCorrectRepeatedError = false
                        self.errorMessage = LocalizedStringKey.init("UserError").stringValue()
                    default:
                        self.errorMessage = LocalizedStringKey.init("LoginDefaultError").stringValue()
                    }
                    completion(false)
               }
            }
        }
    }
}
