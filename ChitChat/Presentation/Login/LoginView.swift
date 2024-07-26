//
//  LoginView.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import SwiftUI
import Combine

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var useBiometrics: Bool = false
    
    @State var presentAlertBiometric = false
    @State var navigate: Bool = false
    
    @StateObject var viewModel: LoginViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .padding(.top,20).frame(width: 200)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey("User"))
                            .font(.headline)
                        TextField(LocalizedStringKey("EnterYourUser"), text: $username)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.userExist ? Color.gray : Color.red)
                            )
                        if(!viewModel.userExist) {
                            Text(viewModel.error)
                                .foregroundColor(.red)
                        }
                        
                        Text(LocalizedStringKey("Password"))
                            .font(.headline)
                        SecureField(LocalizedStringKey("EnterYourPass"), text: $password)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.passCorrect ? Color.gray : Color.red)
                            )
                        if(!viewModel.passCorrect) {
                            Text(viewModel.error).foregroundColor(.red)
                        }
                        
                        VStack{
                            Button(action: {
                                viewModel.userLogin(login: self.username, password: self.password) { success in
                                    if(success) {
                                        username = ""
                                        password = ""
                                        presentAlertBiometric.toggle()
                                    } else {
                                    }
                                }
                            }) {
                                Text(LocalizedStringKey("Login"))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 60)
                            .padding(.top, 16)
                            Spacer().frame(height: 200)
                            
                            if ChitChatDefaultsManager.shared.isBiometricEnabled {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        BiometricAuthentication().authenticationWithBiometric {
                                            viewModel.loginWithBiometric { _ in
                                                username = ""
                                                password = ""
                                                navigate = true
                                            }
                                        } onFailure: { error in
                                            
                                        }
                                    }, label: {
                                        Image("biometric")
                                    })
                                    Spacer()
                                }.padding(.bottom, 20)
                            }
                            
                            Text(LocalizedStringKey("DontHaveAnAccount"))
                            
                            NavigationLink {
                                RegisterView(viewModel: RegisterViewModel(registerUseCase: RegisterUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
                            } label: {
                                Text(LocalizedStringKey("Register"))
                                    .font(.headline)
                                    .foregroundStyle(.black)
                            }
                        }
                    }.padding(.horizontal, 50)
                }
                
                if presentAlertBiometric {
                    CustomAlert(presentAlert: $presentAlertBiometric, alertType: .error(title: LocalizedStringKey("BiometricAccess").stringValue(), message: LocalizedStringKey("BiometricMessage").stringValue(), icon: "message")) {
                        presentAlertBiometric.toggle()
                        ChitChatDefaultsManager.shared.isBiometricEnabled = false
                    } rightButtonAction: {
                        presentAlertBiometric.toggle()
                        ChitChatDefaultsManager.shared.isBiometricEnabled = true
                        navigate = true
                    }
                }
                
                NavigationLink(
                    destination: ActiveChatsView(),
                    isActive: self.$navigate
                ) {
                    EmptyView()
                }.isDetailLink(false)
            }
        }.onAppear {
            if ChitChatDefaultsManager.shared.isBiometricEnabled {
                BiometricAuthentication().authenticationWithBiometric {
                    viewModel.loginWithBiometric { _ in
                        navigate = true
                    }
                } onFailure: { error in
                    
                }
            }
        }.navigationBarHidden(true)
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager())), loginWithBiometricUseCase: LoginWithBiometricUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
    }
}
