//
//  LoginMapperDTO.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import Foundation


protocol LoginDTOMapper {
    func map(_ response: UserLoginResponse) -> LoginModel
}

struct LoginDTOMapperImpl: LoginDTOMapper {
    func map(_ response: UserLoginResponse) -> LoginModel {
        .init(token: response.token, userId: response.user.id)
    }
}

struct UserMapper {
    static func map(users: [User]) -> [UserList] {
        return users.map { user in
            UserList(id: user.id, name: user.nick ?? user.login ?? "Unknown", avatar: user.avatar)
        }
    }
}



