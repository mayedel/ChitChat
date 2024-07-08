//
//  ChatView.swift
//  ChitChat
//
//  Created by María Espejo on 8/7/24.
//

import SwiftUI

struct ConversationView: View {
    let contact: UserList
    
    var body: some View {
           VStack {
               Text("Chat with \(contact.name ?? "Unknown")")
                   .font(.largeTitle)
                   .padding()
               
               // Aquí puedes agregar más detalles de la conversación, como mensajes, etc.
               Text("Conversation with \(contact.name ?? "Unknown") will appear here.")
                   .padding()
           }
           .navigationTitle(contact.name ?? "Unknown")
       }
   }

