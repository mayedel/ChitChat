//
//  RegisterUserModel.swift
//  ChitChat
//
//  Created by Andres Cordón on 18/7/24.
//

import Foundation

struct RegisterUserModel {
    let login: String
    let password: String
    let nick: String
    let platform: String = "iOS"
    let online: Bool = true
}
