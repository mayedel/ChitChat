//
//  Chat.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import Foundation

struct Chat: Identifiable, Codable {
    let id: Int
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

struct ChatView: Identifiable, Decodable {
    let id: Int
    let chat: String
    let source: String
    let sourcenick: String
    let sourceavatar: String
    let sourceonline: Bool
    let sourcetoken: String?
    let target: String
    let targetnick: String
    let targetavatar: String
    let targetonline: Bool
    let targettoken: String?
    let chatcreated: String

    enum CodingKeys: String, CodingKey {
        case chat, source, sourcenick, sourceavatar, sourceonline, sourcetoken, target, targetnick, targetavatar, targetonline, targettoken, chatcreated
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.chat = try container.decode(String.self, forKey: .chat)
            self.id = Int(self.chat) ?? 0
            self.source = try container.decode(String.self, forKey: .source)
            self.sourcenick = try container.decode(String.self, forKey: .sourcenick)
            self.sourceavatar = try container.decode(String.self, forKey: .sourceavatar)
            self.sourceonline = try container.decode(Bool.self, forKey: .sourceonline)
            self.sourcetoken = try container.decodeIfPresent(String.self, forKey: .sourcetoken)
            self.target = try container.decode(String.self, forKey: .target)
            self.targetnick = try container.decode(String.self, forKey: .targetnick)
            self.targetavatar = try container.decode(String.self, forKey: .targetavatar)
            self.targetonline = try container.decode(Bool.self, forKey: .targetonline)
            self.targettoken = try container.decodeIfPresent(String.self, forKey: .targettoken)
            self.chatcreated = try container.decode(String.self, forKey: .chatcreated)
        }
    
}
