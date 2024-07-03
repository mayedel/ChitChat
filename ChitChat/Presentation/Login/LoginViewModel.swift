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
    
    @Published var toast: Toast = Toast(style: ToastStyle.error, message: "Algún error")

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
                self.generateToast(message: "Login creado correctamente", style: ToastStyle.error)
            case .failure(let error):
                guard let code = error.code else { return }
                switch code {
                case 401:
                    self.userExist = false
                    self.passCorrect = true
                    self.generateToast(message: error.message ?? "", style: ToastStyle.error)
                case 400:
                    self.userExist = true
                    self.passCorrect = false
                    self.generateToast(message: "Contraseña incorrecta", style: ToastStyle.error)
                default:
                    self.generateToast(message: "Algún error", style: ToastStyle.error)
                }
            }
        }
        completion()
    }
    
    private func generateToast(message: String, style: ToastStyle) {
        toast = Toast(style: style, message: message)
    }
}
