//
//  RegisterView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 23/6/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var nickname: String = ""
    
    @State var navigate = false
    
    @StateObject private var viewModel: RegisterViewModel
    
    init(viewModel: RegisterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    HStack {
                        Image("back_arrow")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(LocalizedStringKey("UserRegistration").stringValue())
                            .font(.title2)
                    }
                    .padding(5)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        RegistrationTextField(
                            title: LocalizedStringKey("User").stringValue(),
                            text: $username, validation: viewModel.userExistError,
                            hint: LocalizedStringKey("EnterYourUser").stringValue()
                        )
                        if viewModel.userExistError {
                            Text(LocalizedStringKey("UserExist"))
                                .foregroundColor(.red)
                        }
                        if viewModel.userError {
                            Text(LocalizedStringKey("UserError"))
                                .foregroundColor(.red)
                        }
                        
                        RegistrationSecureField(
                            title: LocalizedStringKey("Password").stringValue(),
                            text: $password,
                            hint: LocalizedStringKey("EnterYourPass").stringValue()
                        )
                        if viewModel.passError {
                            Text(LocalizedStringKey("PasswordError"))
                                .foregroundColor(.red)
                        }
                        
                        RegistrationSecureField(title: LocalizedStringKey("RepeatYourPassword").stringValue(), text: $repeatPassword, validation: viewModel.passCorrectRepeatedError, hint: LocalizedStringKey("RepeatYourPassword").stringValue())
                        if viewModel.passCorrectRepeatedError {
                            Text(LocalizedStringKey("PasswordsDontMatch").stringValue())
                                .foregroundColor(.red)
                        }
                        
                        RegistrationTextField(title: "Nick", text: $nickname, validation: viewModel.nickError, hint: LocalizedStringKey("EnterYourNick").stringValue())
                        
                        if viewModel.nickError {
                            Text(LocalizedStringKey("EnterYourNick"))
                                .foregroundColor(.red)
                        }
                        
                        HStack() {
                            Text(LocalizedStringKey("SelectAnAvatar"))
                            Image(viewModel.avatarSelected?.image ?? "empty_avatar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .clipShape(Circle())
                        }
                        
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(viewModel.avatars) { avatar in
                                    Button(action: {
                                        viewModel.avatarSelected = avatar
                                    }, label: {
                                        Image(avatar.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 150)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    })
                                }
                            }
                        }
                    }
                    .padding(15)
                    
                    Button(action: {
                        viewModel.registerUser(
                            login: username,
                            password: password,
                            repeatPassword: repeatPassword,
                            nick: nickname, completion: { success in
                                if success {
                                    navigate = true
                                }
                            }
                        )
                    }) {
                        Text(LocalizedStringKey("Register").stringValue())
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 15)
                    
                    Spacer()
                }
                NavigationLink(destination:ActiveChatsView(viewModel: ActiveChatsViewModel(chatsListUseCase: ActiveChatsUseCase(chatDataProvider: ChatDataProvider(apiManager: APIManager()), messageDataProvider: MessageDataProvider(apiManager: APIManager())))),
                    isActive: $navigate,
                    label: {
                        EmptyView()
                    })
            }
        }
    }
}

struct RegistrationTextField: View {
    var title: String
    @Binding var text: String
    var validation: Bool
    var hint: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            TextField(hint, text: $text)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(!validation ? Color.gray : Color.red)
                )
        }
    }
}

struct RegistrationSecureField: View {
    var title: String
    @Binding var text: String
    var validation: Bool = false
    var hint: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            SecureField(hint ?? "Ingresa tu \(title.lowercased())", text: $text)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(!validation ? Color.gray : Color.red)
                )
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: RegisterViewModel(registerUseCase: RegisterUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))
    }
}
