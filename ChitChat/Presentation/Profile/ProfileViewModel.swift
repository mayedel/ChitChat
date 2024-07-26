//
//  ProfileViewModel.swift
//  ChitChat
//
//  Created by Alex Jumbo on 12/7/24.
//

import Foundation
import Combine
import SwiftUI

protocol ProfileViewModel {
    func showProfile()
}
class ProfileViewModelImpl: ProfileViewModel, ObservableObject {
    
    @Published var nick: String = ""
    @Published var login: String = ""
    @Published var avatar: String = ""
    @Published var error: String = ""

    private let profileUseCase: ProfileUseCase
    private let logoutUseCase: LogoutUseCase
    private let changeOnlineStatusUseCase: ChangeOnlineStatusUseCase
    
    init(profileUseCase: ProfileUseCase, logoutUseCase: LogoutUseCase, changeOnlineStatusUseCase: ChangeOnlineStatusUseCase) {
        self.profileUseCase = profileUseCase
        self.logoutUseCase = logoutUseCase
        self.changeOnlineStatusUseCase = changeOnlineStatusUseCase
    }
    
    func showProfile() {
        profileUseCase.showProfile(token: ChitChatDefaultsManager.shared.token){
            response in
            switch response {
                
            case .success(let data):
                self.nick = data.nick ?? "null"
                self.avatar = ChitChatDefaultsManager.shared.avatar
                self.login = data.login ?? "null"
            case .failure(_):
                print("fallo ViewModel")
            }
        }
    }
    
    func logout(completion: @escaping () -> Void) {
        logoutUseCase.logout { response in
            switch response {
            case .success(_):
                ChitChatDefaultsManager.shared.isBiometricEnabled = false
                ChitChatDefaultsManager.shared.token = ""
                ChitChatDefaultsManager.shared.avatar = ""
                ChitChatDefaultsManager.shared.userId = ""
                self.changeOnlineStatus(status: false)
                completion()
            case .failure(let error):
                guard let code = error.code else { return }
                switch code {
                case 401:
                    self.error = LocalizedStringKey.init("Unauthorized").stringValue()
                default:
                    self.error = LocalizedStringKey.init("LoginDefaultError").stringValue()
                }
            }
        }
    }
    
    func onBiometricToggleTouch(newValue: Bool) {
        ChitChatDefaultsManager.shared.isBiometricEnabled = newValue
    }
    
    func changeOnlineStatus(status: Bool) {
        changeOnlineStatusUseCase.changeOnlineStatusUseCase(status: status) { response in
            switch response {
            case .success(_): break
            case .failure(let error):
                guard let code = error.code else { return }
                switch code {
                case 400:
                    self.error = LocalizedStringKey.init("UnknowParameterError").stringValue()
                case 401:
                    self.error = LocalizedStringKey.init("Unauthorized").stringValue()
                default:
                    self.error = LocalizedStringKey.init("LoginDefaultError").stringValue()
                }
            }
        }
    }
    
}
