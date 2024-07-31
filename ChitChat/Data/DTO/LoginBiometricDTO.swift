//
//  LoginBiometricDTO.swift
//  ChitChat
//
//  Created by Andres Cordón on 24/7/24.
//

import Foundation

struct LoginBiometricResponse: Codable {
    let token: String
    let user: UserPartial
}
