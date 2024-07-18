//
//  ChitChatApp.swift
//  ChitChat
//
//  Created by María Espejo on 30/5/24.
//

import SwiftUI

@main
struct ChitChatApp: App {
    var body: some Scene {
        WindowGroup {
            //LoginView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
            RegisterView(viewModel: RegisterViewModel(registerUseCase: RegisterUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
        }
    }
}
