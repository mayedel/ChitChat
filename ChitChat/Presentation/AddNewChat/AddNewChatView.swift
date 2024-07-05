//
//  AddNewChatView\.swift
//  ChitChat
//
//  Created by Alex Jumbo on 2/7/24.
//

import SwiftUI

// Vista principal
struct AddNewChatView: View {
    let contacts = [
        Contact(name: "John Doe",avatar: "userPicDefault"),
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Encabezado
                HStack {
                    Image("back_arrow").resizable().scaledToFit().frame(width: 40,height: 40)
                    
                    Text("Contactos")
                        .font(.title)
                        .bold()
                    Spacer()

                }
                .padding()
                .background(Color.white)
                
                Divider()
                
                // Barra de búsqueda
                HStack {
                    TextField("Search for people", text: .constant(""))
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    Button(action: {
                        // Acción de búsqueda
                    }) {
                        Image("searchIcon").resizable().scaledToFit()
                            .frame(width: 40,height: 40)
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                // Texto secundario
                HStack {
                    Text("Find someone to chat with")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                
                // Lista de contactos
                HStack {
                    Text("Awesome to Chat With")
                        .font(.headline)
                        .padding(.leading)
                    Spacer()
                }
                .padding(.top, 8)
                
                List(contacts) { contact in
                    HStack {
                        Image("userPicDefault").resizable().scaledToFit().frame(width: 70,height: 70)
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text(contact.name)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .listStyle(PlainListStyle())
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
}


struct AddNewChatView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewChatView()
    }
}
