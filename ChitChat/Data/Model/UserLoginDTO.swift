//
//  UserLoginResponse.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import Foundation

struct UserLoginResponse: Codable {
    let token: String
    let user: UserPartial
}

struct UserPartial: Codable {
    let id: String
    let nick: String
    let avatar: String
    let online: Bool
}
