//  ActiveChatsView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 25/6/24.
//

import SwiftUI

// Vista principal
struct ActiveChatsView: View {
    
    // Mas adelante imlementamos un bucle que recorra los chats activos
    let conversations = [
        Conversation(name: "Javier", message: "Hola, cómo estas?", time: "10:47",avatar: "userPicDefault", isUnread: true, date: nil, isOnline: true),
        Conversation(name: "Marta", message: "Bien gracias, y tú?", time: "",avatar: "userPicDefault", isUnread: false, date: "28/05/24", isOnline: false)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Encabezado
                HStack {
                    Text("ChitChat")
                        .font(.title)
                        .bold()
                    Spacer()
                    Image("userPicDefault").resizable().scaledToFit().frame(width: 70,height: 70)
                }
                .padding()
                .background(Color.white)
                
                Divider()
                
                // Subencabezado
                HStack {
                    Text("Conversaciones")
                        .font(.headline)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing)
                }
                .background(Color.white)
                
                // Lista de conversaciones
                List(conversations) { conversation in
                    HStack {
                        if conversation.isOnline {
                            Image(conversation.avatar).resizable().scaledToFit().frame(width: 70,height: 70)
                                .font(.largeTitle)
                                .foregroundColor(.gray).overlay(Image("onlineIcon").resizable())
                        } else{
                            Image(conversation.avatar).resizable().scaledToFit().frame(width: 70,height: 70)
                                .font(.largeTitle)
                                .foregroundColor(.gray).overlay(Image("offlineIcon").resizable())
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
                .listStyle(PlainListStyle())
                
                // Botón flotante
                HStack {
                    Spacer()
                    Button(action: {
                        // Add new conversation action
                    }) {
                        Circle()
                            .fill(Color.customBlue)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image("addChatIcon")
                                    .resizable().frame(width: 30,height: 30)
                                    .font(.title)
                            )
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
}

struct ActiveChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChatsView()
    }
}
