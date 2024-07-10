//  ActiveChatsView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 25/6/24.
//

import SwiftUI

struct ActiveChatsView: View {
    @StateObject private var viewModel: ActiveChatsViewModel
    
    init(viewModel: ActiveChatsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("ChitChat")
                        .font(.title)
                        .bold()
                    Spacer()
                    Image("userPicDefault")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                }
                .padding()
                .background(Color.white)
                
                Divider()
                
                HStack {
                    Text(LocalizedStringKey("Conversations"))
                        .font(.headline)
                        .padding(.leading)
                    Spacer()
                  
                }
                .background(Color.white)
                
                SearchBar(text: $viewModel.searchText)
                
                List {
                    ForEach(viewModel.filteredConversations) { conversation in
                        NavigationLink(destination: ConversationView(conversation: conversation)) {
                            ConversationRow(conversation: conversation)
                        }
                    }
                    .onDelete(perform: deleteConversation)
                }
                .listStyle(PlainListStyle())
                
                HStack {
                    Spacer()
                    NavigationLink(destination: UsersListView(viewModel: UsersListViewModel(userslistUseCase: UsersListUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()))))) {
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
            .background(Color.white)
            .navigationBarHidden(true)
            .onAppear {
                viewModel.getActiveChats { _ in }
            }
        }
    }
    
    
    private func deleteConversation(at offsets: IndexSet) {
        offsets.forEach { index in
            let conversation = viewModel.filteredConversations[index]
            viewModel.deleteChat(conversation: conversation)
        }
    }
}


struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        HStack {
            if conversation.isOnline {
                Image(conversation.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .overlay(Image("onlineIcon").resizable())
            } else {
                Image(conversation.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .overlay(Image("offlineIcon").resizable())
            }
            VStack(alignment: .leading) {
                Text(conversation.name)
                    .font(.headline)
                Text(conversation.message)
                    .foregroundColor(.gray)
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
                    if let date = conversation.date {
                        Text(date)
                            .foregroundColor(.gray)
                            .font(.caption)
                    } else {
                        Text(conversation.time)
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

//struct ConversationRowView: View {
//    let chat: Chat
//
//    var body: some View {
//        Text("Conversation with \(chat.name)")
//            .navigationTitle(chat.name)
//    }
//}


struct ActiveChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChatsView(viewModel: ActiveChatsViewModel(chatsListUseCase: ActiveChatsUseCase(chatDataProvider: ChatDataProvider(apiManager: APIManager()))))
    }
}
