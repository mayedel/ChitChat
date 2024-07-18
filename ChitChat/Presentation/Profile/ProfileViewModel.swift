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
    func showProfile(token: String, completion: @escaping () -> Void)
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
    
    func showProfile(token: String, completion: @escaping () -> Void) {
        
        profileUseCase.showProfile(token: token){
            response in
            switch response {
                
            case .success(let data):
                self.nick=data.nick ?? "null"
                self.avatar=data.avatar
                self.login=data.login ?? "null"
            case .failure(let error):
                guard let code = error.code else { return }
                print("fallo ViewModel")
            }
        }
        completion()
    }
    
    
}
