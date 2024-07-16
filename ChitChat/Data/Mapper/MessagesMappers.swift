//
//  MessagesMappers.swift
//  ChitChat
//
//  Created by María Espejo on 16/7/24.
//

import Foundation
class MessageMapper {
    static func updateConversations(_ conversations: [Conversation], withMessages messages: [String: (message: String, date: String)]) -> [Conversation] {
        return conversations.map { conversation in
            var updatedConversation = conversation
            if let messageDetails = messages[conversation.id] {
                updatedConversation.message = messageDetails.message
                updatedConversation.time = DateFormatter.formatDate(dateString: messageDetails.date)
            }
            return updatedConversation
        }
    }
}
