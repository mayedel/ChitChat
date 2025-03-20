//
//  GetAllMessagesMapper.swift
//  ChitChat
//
//  Created by Andres Cordón on 22/7/24.
//

import Foundation

protocol GetMessagesListDT0Mapper {
    func map(_ response: MessagesListResponse) -> [MessageModel]
}

struct GetMessagesDTOMapperImpl: GetMessagesListDT0Mapper {
    func map(_ response: MessagesListResponse) -> [MessageModel] {
        return response.rows.map { message in
            MessageModel(id: message.id, chat: message.chat, source: message.source, message: message.message, date: message.date)
        }
    }
}
