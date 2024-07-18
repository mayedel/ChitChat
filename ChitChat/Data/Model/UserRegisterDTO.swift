//
//  UserRegisterDTO.swift
//  ChitChat
//
//  Created by Andres Cordón on 18/7/24.
//

import Foundation

struct UserRegisterResponse: Codable {
    let success: Bool
    let user: UserRegister
}

struct UserRegister: Codable {
    let id: String
    let login: String?
    let password: String?
    let nick: String?
    let platform: String?
    let avatar: String
    let uuid: String?
    let token: String
    let online: Bool
    let created: String?
    let updated: String?
}
