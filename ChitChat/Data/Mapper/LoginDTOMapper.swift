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
        .init(token: response.token)
    }
}

