//
//  LoginView.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import SwiftUI
import Combine
import Firebase
import FirebaseAnalytics

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var useBiometrics: Bool = false
    
    @State var presentAlertBiometric = false
    @State var navigate: Bool = false
    
    @FocusState private var textfieldIsFocused: Bool
    
    @StateObject var viewModel: LoginViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound, .badge]) { success, error in
            if success {
                print("permission granted")
            }else if let error {
                print (error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .padding(.top,20).frame(width: 143, height: 143)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(LocalizedStringKey("User"))
                            .font(.headline)
                        TextField(LocalizedStringKey("EnterYourUser"), text: $username)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(!viewModel.userError ? Color.gray : Color.red)
                            )
                            .focused($textfieldIsFocused)
                        if(viewModel.userError) {
                            Text(viewModel.error)
                                .foregroundColor(.red)
                        }
                        
                        Text(LocalizedStringKey("Password"))
                            .font(.headline)
                        SecureField(LocalizedStringKey("EnterYourPass"), text: $password)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(!viewModel.passError ? Color.gray : Color.red)
                            )
                            .focused($textfieldIsFocused)
                        if(viewModel.passError) {
                            Text(viewModel.error).foregroundColor(.red)
                        }
                        
                        VStack{
                            Button(action: {
                                viewModel.userLogin(login: self.username, password: self.password) { success in
                                    if(success) {
                                        username = ""
                                        password = ""
                                        presentAlertBiometric.toggle()
                                        Analytics.logEvent(AnalyticsEventScreenView,
                                                                   parameters: [AnalyticsParameterScreenName: "\(LoginView.self)",
                                                                                AnalyticsParameterScreenClass: "\(LoginView.self)"])
                                    
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
                                            .padding(.top, 12)
                                    })
                                    Spacer()
                                }
                            }
                            
                            Text(LocalizedStringKey("DontHaveAnAccount"))
                                .padding(.top,12)
                            
                            NavigationLink {
                                RegisterView(viewModel: RegisterViewModel(registerUseCase: RegisterUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
                            } label: {
                                Text(LocalizedStringKey("Register"))
                                    .font(.headline)
                                    .foregroundStyle(.black)
                            }.padding(.top, 12)
                        }
                    }.padding(.horizontal, 50)
                    Spacer()
                }
                
                if presentAlertBiometric {
                    CustomAlert(presentAlert: $presentAlertBiometric, alertType: .error(title: LocalizedStringKey("BiometricAccess").stringValue(), message: LocalizedStringKey("BiometricMessage").stringValue(), icon: "biometric")) {
                        presentAlertBiometric.toggle()
                        ChitChatDefaultsManager.shared.isBiometricEnabled = false
                        navigate = true
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
        .onTapGesture {
            textfieldIsFocused = false
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager())), loginWithBiometricUseCase: LoginWithBiometricUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
    }
}
