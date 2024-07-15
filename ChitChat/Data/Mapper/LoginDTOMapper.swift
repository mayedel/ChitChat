//
//  LoginMapperDTO.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import Foundation


protocol LoginDTOMapper {
    func map(_ response: UserLoginResponse) -> LoginModel
}

struct LoginDTOMapperImpl: LoginDTOMapper {
    func map(_ response: UserLoginResponse) -> LoginModel {
        .init(token: response.token)
    }
}

struct UserMapper {
    static func map(users: [User]) -> [UserList] {
        return users.map { user in
            UserList(id: UUID(), name: user.nick ?? user.login ?? "Unknown", avatar: user.avatar)
        }
    }
}


class ChatMapper {
    static func map(chatViews: [ChatView]) -> [Conversation] {
        return chatViews.map { chatView in
            Conversation(
                id: chatView.id,
                name: chatView.sourcenick,  // o chatView.targetnick
                message: "", // Aquí iría el último mensaje si estuviera disponible
                time: "", // Aquí iría la hora del último mensaje si estuviera disponible
                avatar: chatView.sourceavatar,  // o chatView.targetavatar
                isUnread: false, // Esto dependerá de tu lógica
                date: chatView.chatcreated,
                isOnline: chatView.sourceonline  // o chatView.targetonline
            )
        }
    }
    
    static func map(chats: [Chat]) -> [Conversation] {
        return chats.map { chat in
            Conversation(
                id: chat.id,
                name: chat.source,  // o chat.target
                message: "", // Aquí iría el último mensaje si estuviera disponible
                time: "", // Aquí iría la hora del último mensaje si estuviera disponible
                avatar: "", // Aquí iría el avatar correspondiente
                isUnread: false, // Esto dependerá de tu lógica
                date: chat.created,
                isOnline: false // Aquí iría el estado online correspondiente
            )
        }
    }
}
