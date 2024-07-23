//
//  GetAllMessagesMapper.swift
//  ChitChat
//
//  Created by Andres Cordón on 22/7/24.
//

import Foundation

protocol GetMessagesListDT0Mapper {
    func map(_ response: MessagesListResponse) -> [Message]
}

struct GetMessagesDTOMapperImpl: GetMessagesListDT0Mapper {
    func map(_ response: MessagesListResponse) -> [Message] {
        .init(response.rows)
    }
}
