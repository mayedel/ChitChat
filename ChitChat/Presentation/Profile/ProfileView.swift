//
//  ProfilePic.swift
//  ChitChat
//
//  Created by Alex Jumbo on 2/7/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: ProfileViewModelImpl = ProfileViewModelImpl(profileUseCase: ProfileUseCase(userDataProvider: UserDataProvider(apiManager: APIManager())), logoutUseCase: LogoutUseCase(userDataProvider: UserDataProvider(apiManager: APIManager())))
    
    @Binding var popToLogin: Bool
    
    @State var isBiometric = ChitChatDefaultsManager.shared.isBiometricEnabled
    
    var body: some View {
        
        NavigationView {
            VStack {
                // Header
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("back_arrow").resizable().scaledToFit().frame(width: 40,height: 40)
                    }
                    
                    
                    Text(LocalizedStringKey("Profile"))
                        .font(.title)
                    
                    Spacer()
                    
                    Button(action: {
                        // Acción del botón de notificaciones
                    }) {
                        Image("notificationIcon").resizable().scaledToFit().frame(width: 30,height: 30)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color.white)
                
                Divider()
                
                // Profile Picture and Info
                HStack() {
                    ZStack{
                        Image(viewModel.avatar.isEmpty ? "userPicDefault" : viewModel.avatar)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                    VStack(){
                        Text(viewModel.nick)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(viewModel.login)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    Spacer()
                }.padding(10)
                
                // Opciones
                VStack(spacing: 0) {
                    
                    HStack{
                        Text(LocalizedStringKey("Biometric"))
                            .font(.headline)
                        Spacer()
                        Toggle("", isOn: $isBiometric)
                            .labelsHidden()
                    }.padding(20)
//                    OptionRow(iconName: "passwordIcon", text: "Cambiar contraseña")
//                    
//                    Divider().padding(.leading, 16)

                    Button(action: {
                        viewModel.logout {
                            self.popToLogin = false
                        }
                    }, label: {
                        OptionRow(iconName: "logoutIcon", text: "Cerrar sesión")
                    })
                    
                    Divider().padding(.leading, 16)
                    
                    
                }
                .padding()
                
                Spacer()
            }
            .background(Color.white)
        }.navigationBarHidden(true).onAppear {
            viewModel.showProfile()
        }
        .onChange(of: isBiometric) { isBiometric in
            viewModel.onBiometricToggleTouch(newValue: isBiometric)
        }
    }
}

struct OptionRow: View {
    let iconName: String
    let text: String
    
    var body: some View {
        HStack {
            Image(iconName).resizable().scaledToFit().padding(10)
                .frame(width: 43, height: 43)
                .background(Color.customBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(text)
                .foregroundColor(.black)
                .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

