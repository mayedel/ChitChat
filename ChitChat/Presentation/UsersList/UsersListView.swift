//
//  UsersListView.swift
//  ChitChat
//
//  Created by María Espejo on 5/7/24.
//

import SwiftUI
import Combine

struct UsersListView: View {
    @StateObject private var viewModel = UsersListViewModel(userslistUseCase: UsersListUseCase(userDataProvider: UserDataProvider(apiManager: UsersAPIService(apiManager: APIManager()) as UsersAPIServiceProtocol as! APIManagerProtocol as! APIManagerProtocol) as UserDataProviderProtocol as! UserDataProvider as! UserDataProvider as! UserDataProvider))
    
    //    @State private var searchText = ""
    //    @State private var contacts: [Contact] = [
    //        Contact(name: "John Doe", avatar: "avatar_placeholder"),
    //    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                    Text("Contactos")
                        .font(.largeTitle)
                        .bold()
                }
                .padding([.top, .horizontal])
                .background(Color(.systemGray6))
                
                SearchBar(text: $viewModel.searchText)
                
                Text("Find someone to chat with")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                
                Text("Awesome to Chat With")
                    .font(.headline)
                    .padding([.leading, .top], 16)
                
                List(viewModel.filteredContacts) { contact in
                    //                 NavigationLink(destination: ChatView(contact: contact)) {
                    //                    ContactRow(contact: contact)
                    //                }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
            .onAppear {
        //        viewModel.getUsers(token: )
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search for people", text: $text)
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
    let contact: Contact
    
    var body: some View {
        HStack {
            //            Circle()
            //                .fill(Color.gray)
            //                .frame(width: 40, height: 40)
            Image(contact.avatar)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            Text(contact.name)
        }
        .padding(.vertical, 5)
    }
}

struct ChatWithView: View {
    let contact: Contact
    
    var body: some View {
        Text("Chat with \(contact.name)")
            .navigationTitle(contact.name)
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
