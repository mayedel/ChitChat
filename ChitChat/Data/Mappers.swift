//
//  Mappers.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation

struct UserMapper {
    static func map(apiUser: APIUser) -> User {
        return User(id: apiUser.id, login: apiUser.login, password: apiUser.password, nick: apiUser.nick, platform: apiUser.platform, avatar: apiUser.avatar, uuid: apiUser.uuid, token: apiUser.token, online: apiUser.online, created: apiUser.created, updated: apiUser.updated)
    }
}

struct ChatMapper {
    static func map(apiChat: APIChat) -> Chat {
        return Chat(id: apiChat.id, source: apiChat.source, target: apiChat.target, created: apiChat.created)
    }
}

struct MessageMapper {
    static func map(apiMessage: APIMessage) -> Message {
        return Message(id: apiMessage.id, chat: apiMessage.chat, source: apiMessage.source, message: apiMessage.message, date: apiMessage.date)
    }
}

struct MessageViewMapper {
    static func map(apiMessageView: APIMessageView) -> MessageView {
        return MessageView(id: apiMessageView.id, chat: apiMessageView.chat, source: apiMessageView.source, nick: apiMessageView.nick, avatar: apiMessageView.avatar, message: apiMessageView.message, date: apiMessageView.date)
    }
}
