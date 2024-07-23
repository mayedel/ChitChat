//
//  Message.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import Foundation

struct Message: Identifiable, Codable, Hashable {
    let id: String
    let chat: String
    let source: String
    let message: String
    let date: String
}

struct MessageView: Codable {
    let id: String
    let chat: String
    let source: String
    let nick: String
    let avatar: String
    let message: String
    let date: String
}

struct CreateMessageResponse: Codable {
    let success: Bool
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isReceived: Bool
    let time: String
}
