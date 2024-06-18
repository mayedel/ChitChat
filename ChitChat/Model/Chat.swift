//
//  Chat.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import Foundation

struct Chat: Codable {
    let id: String
    let source: String
    let target: String
    let created: String
}

struct ChatResponse: Codable {
    let success: Bool
    let created: Bool
    let chat: Chat
}

struct DeleteChatResponse: Codable {
    let success: Bool
}
