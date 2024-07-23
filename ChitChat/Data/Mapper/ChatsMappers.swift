//
//  ChatsMappers.swift
//  ChitChat
//
//  Created by María Espejo on 16/7/24.
//

import Foundation

class ChatMapper {
    static func map(chatViews: [ChatModel]) -> [Conversation] {
        return chatViews.map { chatView in
            let formattedDate = DateFormatter.formatDate(dateString: chatView.chatcreated)

            return Conversation(
                id: chatView.id,
                name: chatView.targetnick,
                message: "",
                time: formattedDate,
                avatar: "userPicDefault",
                isUnread: false,
                date: chatView.chatcreated,
                isOnline: chatView.targetonline
            )
        }
    }
}


