//
//  GetAllMessagesDTO.swift
//  ChitChat
//
//  Created by Andres Cordón on 22/7/24.
//

import Foundation

struct MessagesListResponse: Codable {
    let count: Int
    let rows: [Message]
}
