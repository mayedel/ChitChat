//
//  RegisterDTOMapper.swift
//  ChitChat
//
//  Created by Andres Cordón on 18/7/24.
//

import Foundation

protocol RegisterDTOMapper {
    func map(_ response: UserRegisterResponse) -> RegisterModel
}

struct RegisterDTOMapperImpl: RegisterDTOMapper {
    func map(_ response: UserRegisterResponse) -> RegisterModel {
        .init(token: response.user.token)
    }
}
