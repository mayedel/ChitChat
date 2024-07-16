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
            ActiveChatsView(viewModel: ActiveChatsViewModel(chatsListUseCase: ActiveChatsUseCase(chatDataProvider: ChatDataProvider(apiManager: APIManager()), messageDataProvider: MessageDataProvider(apiManager: APIManager()))))
        }
    }
}
