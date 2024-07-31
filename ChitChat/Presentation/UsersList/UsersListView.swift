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
    @State var navigate: Bool = false
    
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
                        Image("back_arrow").resizable().scaledToFit().frame(width: 20,height: 20)
                    }.padding(.horizontal, 10)
                    
                    
                    Text(LocalizedStringKey("Contacts"))
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(10)
                .background(Color.white)
                
                Text(LocalizedStringKey("FindSomeoneToChat").stringValue())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding(.leading, 20)
                    .padding(.top, 16)
                
                SearchBar(text: $viewModel.searchText, textSearchBar: LocalizedStringKey("SearchContact").stringValue()).padding(.horizontal, 10)
                
                List {
                    ForEach(viewModel.filteredContacts) { user in
                        ContactRow(contact: user)
                            .onTapGesture {
                                viewModel.createConversation(for: user) { success in
                                    if success {
                                        navigate.toggle()
                                    }
                                }
                            }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    viewModel.getUsers()
                }
                
                NavigationLink(
                    destination: LazyView(ChatView(conversation: viewModel.createdConversation)),
                    isActive: $navigate,
                    label: {
                        EmptyView()
                    })
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
    var textSearchBar: String = LocalizedStringKey("SearchConversation").stringValue()
    
    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text(textSearchBar).foregroundColor(.gray))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal, 10)
                .overlay (
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                        .padding(.horizontal, 10)
                )
                .overlay (
                    HStack {
                        Spacer()
                        Image("magnifyingglass")
                            .padding(.horizontal, 25)
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
    }
}

struct ChatWithView: View {
    let contact: UserList
    
    var body: some View {
        Text(LocalizedStringKey("AwesomeToChatWith \(contact.name)"))
            .navigationTitle(contact.name)
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView(viewModel: UsersListViewModel(userslistUseCase: UsersListUseCase(userDataProvider: UserDataProvider(apiManager: APIManager()), chatDataProvider: ChatDataProvider(apiManager: APIManager()))))
    }
}
