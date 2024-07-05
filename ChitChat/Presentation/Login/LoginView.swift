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
    
    @State var presentAlert = false
    
    @ObservedObject var viewModel: LoginViewModelImpl = LoginViewModelImpl(loginUseCase: LoginUseCase(userDataProvider: UserDataProvider(apiManager: APIManager())))
    
    private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        ZStack {
            VStack{
                Image("")
                    .resizable()
                    .scaledToFit()
                    .padding(.top,20).frame(width: 200)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Usuario")
                        .font(.headline)
                    TextField("Ingresa tu usuario", text: $username)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.userExist ? Color.gray : Color.red)
                        )
                    if(!viewModel.userExist) {
                        Text("Usuario inexistente")
                            .foregroundColor(.red)
                    }
                    
                    Text("Contraseña")
                        .font(.headline)
                    TextField("Ingresa tu contraseña", text: $password)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.passCorrect ? Color.gray : Color.red)
                        )
                    if(!viewModel.passCorrect) {
                        Text("Contraseña incorrecta").foregroundColor(.red)
                    }
                    
                    
                    HStack{
                        Text("Acceso con biometría")
                            .font(.headline)
                        Spacer()
                        Toggle("", isOn: $useBiometrics)
                            .labelsHidden()
                    }
                    VStack{
                        Button(action: {
                            viewModel.userLogin(login: self.username, password: self.password) {
                                presentAlert.toggle()
                            }
                        }) {
                            Text("Login")
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
                        Text("¿No tienes cuenta?")
                        Button(action: {
                            // Acción de registro
                        }) {
                            Text("Regístrate")
                                .font(.headline)
                                .foregroundStyle(.black)
                        }
                    }
                }.padding(.horizontal, 50)
            }
            
            if presentAlert{
                CustomAlert(presentAlert: $presentAlert, alertType: .error(title: "Error", message: viewModel.error)) {
                    presentAlert.toggle()
                } rightButtonAction: {
                    presentAlert.toggle()
                }
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
