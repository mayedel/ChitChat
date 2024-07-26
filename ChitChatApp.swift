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
            SplashView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager())), loginWithBiometricUseCase: LoginWithBiometricUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
            //ChatView(conversation: Conversation(id: "1532", name: "Andrés", message: "Hola", time: "", avatar: "avatar1", isUnread: false, isOnline: false, source: "819"))
        }
    }
}
