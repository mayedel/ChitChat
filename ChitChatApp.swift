//
//  ChitChatApp.swift
//  ChitChat
//
//  Created by María Espejo on 30/5/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ChitChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            SplashView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager())), loginWithBiometricUseCase: LoginWithBiometricUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
            //ChatView(conversation: Conversation(id: "1532", name: "Andrés", message: "Hola", time: "", avatar: "avatar1", isUnread: false, isOnline: false, source: "819"))
        }
    }
}
