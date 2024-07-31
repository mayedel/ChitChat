//
//  LoginErrorModel.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import Foundation

struct ErrorModel: Error {
    let code: Int?
    let message: String?
}
