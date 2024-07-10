//
//  ActiveChatsModel.swift
//  ChitChat
//
//  Created by María Espejo on 5/7/24.
//

import Foundation

struct Conversation: Identifiable {
    let id = UUID()
    let name: String
    let message: String
    let time: String
    let avatar: String
    let isUnread: Bool
    let date: String?
    let isOnline: Bool
}
