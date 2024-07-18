//
//  ProfilePic.swift
//  ChitChat
//
//  Created by Alex Jumbo on 2/7/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModelImpl = ProfileViewModelImpl(profileUsecase: ProfileUseCase(userDataProvider: UserDataProvider(apiManager: APIManager())))
    
    @State private var nick: String = ""
    @State private var avatar: String = ""
    @State private var login: String = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                // Header
                HStack {
                    Button(action: {
                        // Acción del botón de retroceso
                        
                    }) {
                        Image("back_arrow").resizable().scaledToFit().frame(width: 40,height: 40)
                    }
                    
                    
                    Text(LocalizedStringKey("Profile"))
                        .font(.title)
                    
                    Spacer()
                    
                    Button(action: {
                        // Acción del botón de notificaciones
                        viewModel.showProfile(token:  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNCIsImlhdCI6MTcxODM1MDg3NywiZXhwIjoxNzIwOTQyODc3fQ.kg0sIg7KmVMg0-ExOnC9P2UhWCi43lDbemu0zX0y_MY"){
                            nick = viewModel.nick
                            avatar = viewModel.avatar
                            login = viewModel.login
                        }
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
                        Image("userPicDefault")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding(6)
                            .background(Color.customBlue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .offset(x: 30, y: 20)
                    }
                    VStack(){
                        Text(nick)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(login)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    Spacer()
                }.padding(10)
                
                // Opciones
                VStack(spacing: 0) {
                    OptionRow(iconName: "passwordIcon", text: "Cambiar contraseña")
                    
                    Divider().padding(.leading, 16)
                    
                    OptionRow(iconName: "logoutIcon", text: "Cerrar sesión")
                }
                .padding()
                
                Spacer()
            }
            .background(Color.white)
            .navigationBarHidden(true).onAppear {
                viewModel.showProfile(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1MyIsImlhdCI6MTcxODcyMjc4MSwiZXhwIjoxNzIxMzE0NzgxfQ.uN6s5CGApRUqjl58Lpfro6lpUlvlaL0u4fvGYK6cQC4") {
                    nick = viewModel.nick
                    avatar = viewModel.avatar
                    login = viewModel.login
                }
            }
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

