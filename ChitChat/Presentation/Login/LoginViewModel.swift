//
//  LoginViewModel.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import Foundation
import Combine
import SwiftUI

protocol LoginViewModel {
    func userLogin(login: String, password: String, completion: @escaping () -> Void)
}

class LoginViewModelImpl: LoginViewModel, ObservableObject {
    
    
    @Published var token: String = ""
    
    @Published var userExist: Bool = true
    @Published var passCorrect: Bool = true
    @Published var error: String = ""

    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    
    func userLogin(login: String, password: String, completion: @escaping () -> Void) {
        loginUseCase.userLogin(login: login, password: password) { response in
            switch response {
            case .success(let data):
                self.userExist = true
                self.passCorrect = true
                self.token = data.token
                self.error = LocalizedStringKey.init("LoginSuccess").stringValue()
            case .failure(let error):
                guard let code = error.code else { return }
                switch code {
                case 401:
                    self.userExist = true
                    self.passCorrect = false
                    self.error = LocalizedStringKey.init("PasswordError").stringValue()
                case 400:
                    self.userExist = false
                    self.passCorrect = true
                    self.error = LocalizedStringKey.init("UserError").stringValue()
                default:
                    self.error = LocalizedStringKey.init("LoginDefaultError").stringValue()
                }
            }
        }
        completion()
    }
}
