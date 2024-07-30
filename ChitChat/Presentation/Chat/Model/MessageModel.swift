//
//  MessageModel.swift
//  ChitChat
//
//  Created by Andres Cordón on 29/7/24.
//

import Foundation

struct MessageModel: Identifiable, Equatable, Codable {
    let id: String
    let chat: String
    let source: String
    let message: String
    let date: String
    var isRead: Bool = false
}
