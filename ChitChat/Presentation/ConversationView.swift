//
//  ChatView.swift
//  ChitChat
//
//  Created by María Espejo on 8/7/24.
//

import SwiftUI

struct ConversationView: View {
  
    let conversation: Conversation
    
    var body: some View {
           VStack {

               Text("Conversation with \(conversation.name)")
                           .navigationTitle(conversation.name)
           }

       }
   }

