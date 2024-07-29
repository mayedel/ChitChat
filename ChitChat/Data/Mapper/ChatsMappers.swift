//
//  ChatsMappers.swift
//  ChitChat
//
//  Created by María Espejo on 16/7/24.
//

import Foundation

class ChatMapper {
    static func map(chats: [Chat], userProfiles: [String: User], currentUserId: String, lastMessages: [String: (message: String, date: String)], messagesUnread: [String : [Message]]) -> [Conversation] {
        return chats.compactMap { chat in
            let otherUserId = chat.source == currentUserId ? chat.target : chat.source
            guard let otherUser = userProfiles[otherUserId] else {
                return Conversation(id: "", name: "", message: "", messagesUnread: [], time: "", avatar: "", isUnread: false, isOnline: false, source: "")
            }
            
            let lastReadMessage = ChitChatDefaultsManager.shared.getLastReadMessage(chatId: chat.id)
            let lastMessage = lastMessages[chat.id]
            let isUnread = lastReadMessage?.messageId != lastMessage?.message
            
            return Conversation(
                id: chat.id,
                name: otherUser.nick ?? "",
                message: lastMessage?.message ?? "",
                messagesUnread: [],
                time: DateFormatter.formatDate(dateString:  lastMessage?.date ?? chat.created),
                avatar: otherUser.avatar,
                isUnread: false,
                date: lastMessage?.date ?? chat.created,
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


