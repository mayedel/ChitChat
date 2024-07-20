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
    //@Published var error: String = ""

    private let profileUseCase: ProfileUseCase
    
    init(profileUsecase: ProfileUseCase) {
        self.profileUseCase = profileUsecase
    }
    
    func showProfile() {
        
        profileUseCase.showProfile(token: ChitChatDefaultsManager.shared.token){
            response in
            switch response {
                
            case .success(let data):
                self.nick = data.nick ?? "null"
                self.avatar = ChitChatDefaultsManager.shared.avatar
                self.login = data.login ?? "null"
            case .failure(let error):
                print("fallo ViewModel")
            }
        }
    }
    
    
}
