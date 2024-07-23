//
//  SplashView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 19/7/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    @State private var size = 0.8
    @StateObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
           if isActive {
              LoginView(viewModel: viewModel)
           } else {
               VStack {
                   VStack {
                       Image("logo")
                           .resizable()
                           .scaledToFit()
                           .frame(width: 150,height: 150)
                      
                   }
                   .scaleEffect(size)
                   .opacity(opacity)
                   .onAppear {
                       withAnimation(.easeIn(duration: 1.2)) {
                           self.size = 0.9
                           self.opacity = 1.00
                       }
                   }
               }
               .onAppear {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                       withAnimation {
                           self.isActive = true
                       }
                   }
               }
           }
       }
}
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
    }
}

