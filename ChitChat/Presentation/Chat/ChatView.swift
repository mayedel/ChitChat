//
//  ChatView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 4/7/24.
//

import SwiftUI

// Modelo de mensaje
struct message: Identifiable {
    let id = UUID()
    let text: String
    let isReceived: Bool
    let time: String
}

// Vista principal de Chat
struct chatView: View {
    @State private var messageText: String = ""
    
    let userName: String
    let userImage: String
    let isOnline: Bool
    
    //bucle que recorra mensajes, mensajes de ejemplo:
    let messages: [message] = [
        message(text: "Hola", isReceived: false, time: "20:50"),
        message(text: "Mensaje más largo", isReceived: true, time: "20:55")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Encabezado del chat
                HStack {
                    Button(action: {
                        // Acción del botón de retroceso
                    }) {
                        Image("back_arrow").resizable().scaledToFit().frame(width: 40,height: 40)
                    }.padding(.trailing,50)
                    
                    VStack{
                        HStack {
                            Image(userImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            
                            Text(userName)
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                    }
                    
                }
                .padding()
                .background(Color.white)
                Text(isOnline ? "En línea" : "Desconectado")
                    .font(.subheadline)
                    .foregroundColor(isOnline ? .green : .gray)
                Divider()
                
                // Lista de mensajes
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isReceived {
                                    MessageBubble(message: message.text, time: message.time, isReceived: true)
                                    Spacer()
                                } else {
                                    Spacer()
                                    MessageBubble(message: message.text, time: message.time, isReceived: false)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // Campo de entrada de mensaje
                HStack {
                    TextField("Escribe un mensaje...", text: $messageText)
                        .padding()
                        .background(Color(white: 0.95))
                        .cornerRadius(20)
                    
                    Button(action: {
                        // Acción para enviar el mensaje
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color(red: 0/255, green: 148/255, blue: 184/255))
                    }
                }
                .padding()
                .background(Color.white)
            }
            .navigationBarHidden(true)
        }
    }
}

// Vista para burbujas de mensajes
struct MessageBubble: View {
    let message: String
    let time: String
    let isReceived: Bool
    
    var body: some View {
        VStack(alignment: isReceived ? .leading : .trailing) {
            Text(message)
                .padding()
                .background(isReceived ? Color(white: 0.9) : Color(red: 0/255, green: 148/255, blue: 184/255))
                .foregroundColor(isReceived ? .black : .white)
                .cornerRadius(20)
                .frame(maxWidth: 250, alignment: isReceived ? .leading : .trailing)
            
            Text(time)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(isReceived ? .leading : .trailing, 12)
        }
    }
}

#Preview {
    chatView(userName: "Daniel", userImage: "userPicDefault", isOnline: false)
}
