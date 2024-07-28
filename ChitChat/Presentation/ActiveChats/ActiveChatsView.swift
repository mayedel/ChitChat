//  ActiveChatsView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 25/6/24.
//

import SwiftUI

struct ActiveChatsView: View {
    @StateObject private var viewModel: ActiveChatsViewModel = ActiveChatsViewModel(chatsListUseCase: ActiveChatsUseCase(chatDataProvider: ChatDataProvider(apiManager: APIManager()), messageDataProvider: MessageDataProvider(apiManager: APIManager()), userDataProvider: UserDataProvider(apiManager: APIManager())))
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    VStack {
                        HStack{
                            Text("ChitChat")
                                .font(.title)
                                .bold()
                            Spacer()
                            NavigationLink(destination: ProfileView()) {
                                Image(ChitChatDefaultsManager.shared.avatar.isEmpty ? "userPicDefault" : ChitChatDefaultsManager.shared.avatar)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 48, height: 48)
                            }
                        }
                        HStack{
                            Text(LocalizedStringKey("Conversaciones"))
                                .font(.headline)
                            Spacer()
                        }
                    }.padding(20)
                    SearchBar(text: $viewModel.searchText).padding(.horizontal,10)
                    if viewModel.filteredConversations.isEmpty {
                        Text("No se han encontrado")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List {
                            ForEach(viewModel.filteredConversations) { conversation in
                                NavigationLink(destination: ChatView(conversation: conversation)) {
                                    ConversationRow(conversation: conversation)
                                }
                                .listRowSeparator(.hidden)
                            }
                            .onDelete(perform: deleteConversation)
                        }
                        .listStyle(PlainListStyle())
                        
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: UsersListView(viewModel: UsersListViewModel(userslistUseCase: UsersListUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()), chatDataProvider: ChatDataProvider(apiManager: APIManager()))))) {
                            Circle()
                                .fill(Color.customBlue)
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Image("addChatIcon")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                )
                        }
                        .padding()
                    }
                    
                }
                .onAppear {
                    viewModel.getActiveChats { _ in }
                }
                
                if viewModel.showCustomAlert {
                    CustomAlert(
                        presentAlert: $viewModel.showCustomAlert,
                        alertType: viewModel.alertType,
                        leftButtonAction: {
                            viewModel.showCustomAlert = false
                        },
                        rightButtonAction: {
                            if let conversation = viewModel.conversationToDelete {
                                viewModel.hideConversation(conversation: conversation)
                            }
                        }
                    )
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    
    
    private func deleteConversation(at offsets: IndexSet) {
        offsets.forEach { index in
            let conversation = viewModel.filteredConversations[index]
            viewModel.showDeleteConfirmation(conversation: conversation)
        }
    }
}


struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack {
            if conversation.isOnline {
                Image("userPicDefault")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .overlay(Image("onlineIcon").resizable())
            } else {
                Image("userPicDefault")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .overlay(Image("offlineIcon").resizable())
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(conversation.name)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(conversation.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .opacity(0.7)
                    .padding(.top, 2)
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    if conversation.isUnread {
                        Circle()
                            .fill(Color.customBlue)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("1")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            )
                    }
                    Text(conversation.time)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 8)
    }
}




struct ActiveChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChatsView()
    }
}
