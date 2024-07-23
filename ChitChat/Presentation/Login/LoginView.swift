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
    @State var navigate = false
    
    @State var presentAlert = false
    
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
                        TextField(LocalizedStringKey("EnterYourPass"), text: $password)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.passCorrect ? Color.gray : Color.red)
                            )
                        if(!viewModel.passCorrect) {
                            Text(viewModel.error).foregroundColor(.red)
                        }
                        
                        
                        HStack{
                            Text(LocalizedStringKey("Biometric"))
                                .font(.headline)
                            Spacer()
                            Toggle("", isOn: $useBiometrics)
                                .labelsHidden()
                        }
                        VStack{
                            Button(action: {
                                viewModel.userLogin(login: self.username, password: self.password) { success in
                                    if(success) {
                                        navigate = true
                                    } else {
                                        presentAlert.toggle()
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
                    
                    NavigationLink(destination:ActiveChatsView(viewModel: ActiveChatsViewModel(chatsListUseCase: ActiveChatsUseCase(chatDataProvider: ChatDataProvider(apiManager: APIManager()), messageDataProvider: MessageDataProvider(apiManager: APIManager()), userDataProvider: UserDataProvider(apiManager: APIManager())))),
                        isActive: $navigate,
                        label: {
                            EmptyView()
                        })
                }
                
                if presentAlert{
                    CustomAlert(presentAlert: $presentAlert, alertType: .error(title: LocalizedStringKey("Error").stringValue(), message: viewModel.error)) {
                        presentAlert.toggle()
                    } rightButtonAction: {
                        presentAlert.toggle()
                    }
                }
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
    }
}
