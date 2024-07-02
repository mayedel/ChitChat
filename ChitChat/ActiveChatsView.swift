//  ActiveChatsView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 25/6/24.
//

import SwiftUI

// Definición de colores personalizados
extension Color {
    static let customBlue = Color(red: 45/255, green: 156/255, blue: 219/255)
    static let customGreen = Color(red: 76/255, green: 175/255, blue: 80/255)
}

// Modelo de conversación
struct Conversation: Identifiable {
    let id = UUID()
    let name: String
    let message: String
    let time: String
    let avatar: String
    let isUnread: Bool
    let date: String?
    let isOnline: Bool
}

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

#Preview {
    ActiveChatsView()
}
