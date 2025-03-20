//
//  LoginViewModel.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import Foundation
import Combine
import SwiftUI
import FirebaseAnalytics

protocol LoginViewModelProtocol {
    func userLogin(login: String, password: String, completion: @escaping (Bool) -> Void)
}

class LoginViewModel: LoginViewModelProtocol, ObservableObject {
    
    @Published var userError: Bool = false
    @Published var passError: Bool = false
    @Published var error: String = ""

    private let loginUseCase: LoginUseCase
    private let loginWithBiometricUseCase: LoginWithBiometricUseCase
   
    init(loginUseCase: LoginUseCase, loginWithBiometricUseCase: LoginWithBiometricUseCase) {
        self.loginUseCase = loginUseCase
        self.loginWithBiometricUseCase = loginWithBiometricUseCase
    }

    
    func userLogin(login: String, password: String, completion: @escaping (Bool) -> Void) {
        
        resetErrors()
        
        if login.isEmpty {
            self.userError = true
            self.error = LocalizedStringKey.init("EmptyFieldError").stringValue()
        }
        
        if password.isEmpty {
            self.passError = true
            self.error = LocalizedStringKey.init("EmptyFieldError").stringValue()
        }
        
        if(self.error.isEmpty) {
            loginUseCase.userLogin(login: login, password: password) { response in
                switch response {
                case .success(let data):
                    self.userError = false
                    self.passError = false
                    self.error = LocalizedStringKey.init("LoginSuccess").stringValue()
                    ChitChatDefaultsManager.shared.token = data.token
                    ChitChatDefaultsManager.shared.userId = data.userId
                    completion(true)
                case .failure(let error):
                    guard let code = error.code else { return }
                    switch code {
                    case 401:
                        self.userError = false
                        self.passError = true
                        self.error = LocalizedStringKey.init("PasswordError").stringValue()
                    case 400:
                        self.userError = true
                        self.passError = false
                        self.error = LocalizedStringKey.init("UserError").stringValue()
                    default:
                        self.error = LocalizedStringKey.init("LoginDefaultError").stringValue()
                    }
                    completion(false)
                }
            }
        }
    }
    
    func loginWithBiometric(completion: @escaping (Bool) -> Void) {
        loginWithBiometricUseCase.loginWithBiometric { response in
            switch response {
            case .success(let data):
                ChitChatDefaultsManager.shared.token = data.token
                completion(true)
            case .failure(let error):
                guard let code = error.code else { return }
                switch code {
                case 401:
                    self.userError = true
                    self.passError = false
                    self.error = LocalizedStringKey.init("Unauthorized").stringValue()
                default:
                    self.error = LocalizedStringKey.init("LoginDefaultError").stringValue()
                }
                completion(false)
            }
        }
    }
    
    
    func resetErrors() {
        error = ""
        userError = false
        passError = false
    }
}
