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
    
    @Published var loginError: Bool = false
    @Published var passwordError: Bool = false
    @Published var repeatPasswordError: Bool = false
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
        resetErrors()
        
        let newUser = RegisterUserModel(login: login, password: password, nick: nick)
        
        if login.isEmpty {
            loginError = true
            errorMessage = LocalizedStringKey.init("EmptyFieldError").stringValue()
        }
        
        if password.isEmpty {
            passwordError = true
            errorMessage = LocalizedStringKey.init("EmptyFieldError").stringValue()
        }
        
        if repeatPassword.isEmpty {
            repeatPasswordError = true
            errorMessage = LocalizedStringKey.init("EmptyFieldError").stringValue()
        }
        
        if nick.isEmpty {
            nickError = true
            errorMessage = LocalizedStringKey.init("EmptyFieldError").stringValue()
        }
        
        
        if (password != repeatPassword && errorMessage.isEmpty) {
            self.repeatPasswordError = true
            errorMessage = LocalizedStringKey.init("PasswordsDontMatch").stringValue()
        } else if (errorMessage.isEmpty && login.count > 25) {
            self.loginError = true
            errorMessage = LocalizedStringKey.init("UserLengthError").stringValue()
        } else if (errorMessage.isEmpty && nick.count > 25) {
            self.nickError = true
            errorMessage = LocalizedStringKey.init("NickLengthError").stringValue()
        } else if errorMessage.isEmpty {
            self.registerUseCase.registerUser(user: newUser) { response in
                switch response {
                case .success(let data):
                    self.errorMessage = LocalizedStringKey.init("LoginSuccess").stringValue()
                    ChitChatDefaultsManager.shared.token = data.token
                    ChitChatDefaultsManager.shared.avatar = self.avatarSelected?.image ?? "empty_avatar"
                    completion(true)
                case .failure(let error):
                    guard let code = error.code else { return }
                    switch code {
                    case 401:
                        self.loginError = true
                        self.repeatPasswordError = false
                        self.passwordError = false
                        self.nickError = false
                        self.errorMessage = LocalizedStringKey.init("UserError").stringValue()
                    default:
                        self.errorMessage = LocalizedStringKey.init("LoginDefaultError").stringValue()
                    }
                    completion(false)
               }
            }
        }
    }
    
    func resetErrors() {
        errorMessage = ""
        loginError = false
        nickError = false
        passwordError = false
        repeatPasswordError = false
    }
}
