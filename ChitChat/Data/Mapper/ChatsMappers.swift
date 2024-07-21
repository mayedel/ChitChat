//
//  ChatsMappers.swift
//  ChitChat
//
//  Created by María Espejo on 16/7/24.
//

import Foundation

class ChatMapper {
    static func map(chats: [Chat], userProfiles: [String: User], currentUserId: String) -> [Conversation] {
        return chats.compactMap { chat in
            let otherUserId = chat.source == currentUserId ? chat.target : chat.source
            guard let otherUser = userProfiles[otherUserId] else {
                print("CHATMAPPER. No user profile found for user ID: \(otherUserId)")
                return nil
            }
            print("CHATMAPPER. Mapping chat with ID: \(chat.id), other user ID: \(otherUserId)")
            return Conversation(
                id: chat.id,
                name: otherUser.nick ?? "",
                message: "",
                time: DateFormatter.formatDate(dateString: chat.created),
                avatar: otherUser.avatar,
                isUnread: false,
                date: chat.created,
                isOnline: otherUser.online,
                source: chat.source
            )
        }
    }
    
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


