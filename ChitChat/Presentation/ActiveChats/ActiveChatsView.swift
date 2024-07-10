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
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing)
                }
                .background(Color.white)
                
                List(viewModel.chats) { chat in
                    NavigationLink(destination: ConversationView(contact: chat)) {
                        ContactRow(contact: chat)
                    }
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
                viewModel.getActiveChats { result in
                    if case .failure(let error) = result {
                        print("Error al cargar chats: \(error)")
                    }
                }
            }
        }
    }
}

struct ChatRow: View {
    let chat: Chat
    
    var body: some View {
        HStack {
            if chat.isOnline {
                Image(chat.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .overlay(Image("onlineIcon").resizable())
            } else {
                Image(chat.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .overlay(Image("offlineIcon").resizable())
            }
            VStack(alignment: .leading) {
                Text(chat.name)
                    .font(.headline)
                Text(chat.lastMessage)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    if chat.isUnread {
                        Circle()
                            .fill(Color.customBlue)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("1")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            )
                    }
                    if let date = chat.date {
                        Text(date)
                            .foregroundColor(.gray)
                            .font(.caption)
                    } else {
                        Text(chat.time)
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct ConversationView: View {
    let chat: Chat
    
    var body: some View {
        Text("Conversation with \(chat.name)")
            .navigationTitle(chat.name)
    }
}


struct ActiveChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChatsView(viewModel: ActiveChatsViewModel(activechatstUseCase: ActiveChatsUseCase(chatDataProvider: ChatDataProvider(apiManager: APIManager()))))
    }
}
