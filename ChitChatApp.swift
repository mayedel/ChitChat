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
            SplashView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
            //LoginView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
//            RegisterView(viewModel: RegisterViewModel(registerUseCase: RegisterUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
        }
    }
}
