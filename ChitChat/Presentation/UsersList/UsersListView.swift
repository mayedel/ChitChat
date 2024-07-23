//
//  UsersListView.swift
//  ChitChat
//
//  Created by María Espejo on 5/7/24.
//

import SwiftUI
import Combine

struct UsersListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: UsersListViewModel
    
    init(viewModel: UsersListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("back_arrow").resizable().scaledToFit().frame(width: 40,height: 40)
                    }
                    
                    
                    Text(LocalizedStringKey("Contacts"))
                        .font(.title)
                }
                .padding()
                .background(Color.white)
                
                SearchBar(text: $viewModel.searchText)
       
                Text("Awesome to Chat With")
                    .font(.headline)
                    .padding([.leading, .top], 16)
                
                List(viewModel.filteredContacts) { user in
                   NavigationLink( destination: LazyView(ChatView(conversation: viewModel.createConversation(for: user))),
                                   label: {
                        ContactRow(contact: user)
                    })
                }
                .listStyle(PlainListStyle())
            }
        }.navigationBarHidden(true)
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Buscar...", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                            .padding(.trailing, 15)
                    }
                )
        }
        .padding(.top, 10)
    }
}

struct ContactRow: View {
    let contact: UserList
    
    var body: some View {
        HStack {
            Image("userPicDefault")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            Text(contact.name)
        }
        .padding(.vertical, 5)
    }
}

struct ChatWithView: View {
    let contact: UserList
    
    var body: some View {
        Text("Chat with \(contact.name)")
            .navigationTitle(contact.name)
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView(viewModel: UsersListViewModel(userslistUseCase: UsersListUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()), chatDataProvider: ChatDataProvider(apiManager: APIManager()))))
    }
}
