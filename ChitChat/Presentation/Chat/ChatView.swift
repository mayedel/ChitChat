//
//  ChatView.swift
//  ChitChat
//
//  Created by Alex Jumbo on 4/7/24.
//

import SwiftUI

// Vista principal de Chat
struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var messageText: String = ""
    @State var textSearch: String = ""
    
    let conversation: Conversation
    
    @ObservedObject var viewModel = ChatViewModel(
        getMessagesListUseCase: GetMessagesListUseCase(messageDataProvider: MessageDataProvider(apiManager: APIManager())),
        createMessageUseCase: CreateMessageUseCase(messageDataProvider: MessageDataProvider(apiManager: APIManager()))
    )
    
    var body: some View {
        NavigationView {
            VStack {
                // Encabezado del chat
                HStack {
                    Button(action: {
                        viewModel.isInChat = false
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("back_arrow").resizable().scaledToFit().frame(width: 40,height: 40)
                    }.padding(.trailing,50)
                    
                    VStack{
                        HStack {
                            Image(conversation.avatar.isEmpty ? "userPicDefault" : conversation.avatar)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            
                            Text(conversation.name)
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    
                }
                .padding(.horizontal)
                .background(Color.white)
                Text(conversation.isOnline ? "En línea" : "")
                    .font(.subheadline)
                    .foregroundColor(conversation.isOnline ? .green : .gray)
                Divider()
                
                ScrollViewReader { scrollView in
                    // Lista de mensajes
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.messages) { message in
                                HStack {
                                    if(ChitChatDefaultsManager.shared.userId != message.source) {
                                        MessageBubble(message: message.message, time: DateFormatter.fixedServerHour(messageTime:  message.date), isReceived: true)
                                        Spacer()
                                    } else {
                                        Spacer()
                                        MessageBubble(message: message.message, time: DateFormatter.fixedServerHour(messageTime:  message.date), isReceived: false)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .onAppear {
                        viewModel.getMessagesService(chatId: conversation.id) {}
                    }
                    .onChange(of: viewModel.messages.count) { count in
                        if let last = viewModel.messages.last {
                            withAnimation {
                                scrollView.scrollTo(last.id)
                            }
                        }
                    }
                }
                
                // Campo de entrada de mensaje
                
                HStack {
                    TextField("Escribe un mensaje...", text: $messageText)
                        .padding()
                        .background(Color(white: 0.95))
                        .cornerRadius(20)
                    
                    Button(action: {
                        viewModel.createNewMessage(message: messageText, chatId: conversation.id) { completion in
                            if completion {
                                viewModel.getMessagesList(chatId: conversation.id) {}
                                messageText = ""
                            }
                        }
                    }) {
                        Image("send_message")
                    }
                }
                .padding()
                .background(Color.white)
            }
        }.navigationBarHidden(true)
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

struct chatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(conversation: Conversation(id: "10", name: "Andres", message: "Hola qué tal?", time: "10/08/2023", avatar: "avatar1", isUnread: true, isOnline: true, source: "10"))
    }
}

