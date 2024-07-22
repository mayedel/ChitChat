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
           // SplashView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
            ActiveChatsView(viewModel: ActiveChatsViewModel(chatsListUseCase: ActiveChatsUseCase(chatDataProvider: ChatDataProvider(apiManager: APIManager()), messageDataProvider: MessageDataProvider(apiManager: APIManager()), userDataProvider: UserDataProvider(apiManager: APIManager()))))
        }
    }
}
