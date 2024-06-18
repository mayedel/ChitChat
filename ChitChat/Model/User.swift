//
//  User.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import Foundation

struct User: Codable {
    let id: String
    let login: String?
    let password: String?
    let nick: String?
    let platform: String?
    let avatar: String
    let uuid: String?
    let token: String?
    let online: Bool
    let created: String?
    let updated: String?
}

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

struct RegisterResponse: Codable {
    let success: Bool
    let user: User
}

struct MessageResponse: Codable {
    let message: String
}
