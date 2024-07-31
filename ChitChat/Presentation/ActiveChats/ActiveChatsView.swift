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
                            Text(LocalizedStringKey("Title"))
                                .font(.title)
                                .bold()
                            Spacer()
                            Button {
                                viewModel.isInChatsActiveScreen = false
                            } label: {
                                NavigationLink(destination: ProfileView()) {
                                    Image(ChitChatDefaultsManager.shared.avatar.isEmpty ? "userPicDefault" : ChitChatDefaultsManager.shared.avatar)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 48, height: 48)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        
                        HStack{
                            Text(LocalizedStringKey("Conversaciones"))
                                .font(.headline)
                                .fontWeight(.medium)
                            Spacer()
                        }.padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                    SearchBar(text: $viewModel.searchText).padding(.bottom, 12).padding(.horizontal, 10)
                    
                    if viewModel.filteredConversations.isEmpty {
                        Text(LocalizedStringKey("ConversationsNotFound"))
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List() {
                            ForEach(viewModel.filteredConversations) { conversation in
                                ZStack {
                                    ConversationRow(conversation: conversation)
                                        
                                    NavigationLink(destination: ChatView(conversation: conversation)) {
                                        EmptyView()
                                    }
                                    .opacity(0.0)
                                    .onTapGesture {
                                        viewModel.isInChatsActiveScreen = false
                                    }
                                }.listRowSeparator(.hidden)
                            }
                            .onDelete(perform: deleteConversation)
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.getActiveChats { _ in }
                        }
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
                        .onTapGesture {
                            viewModel.isInChatsActiveScreen = false
                        }
                    }
                    
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
            }.onAppear {
                viewModel.getActiveChatsService()
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
                    .fontWeight(.medium)
                Text(conversation.message)
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .opacity(0.7)
                    .padding(.top, 2)
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    if !conversation.unreadMessages.isEmpty {
                        Circle()
                            .fill(Color.customBlue)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("\(conversation.unreadMessages.count)")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            )
                    }
                    Text(conversation.time)
                        .font(.caption)
                }
            }
        }
    }
}




struct ActiveChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChatsView()
    }
}
