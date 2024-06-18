////
////  APIUser.swift
////  ChitChat
////
////  Created by María Espejo on 18/6/24.
////
//
//import Foundation
//
//struct APIUser: Codable {
//    let id: String
//    let login: String
//    let password: String
//    let nick: String
//    let platform: String
//    let avatar: String
//    let uuid: String?
//    let token: String
//    let online: Bool
//    let created: String
//    let updated: String
//}
//
//struct APILoginResponse: Codable {
//    let token: String
//    let user: APIUserPartial
//}
//
//struct APIUserPartial: Codable {
//    let id: String
//    let nick: String
//    let avatar: String
//    let online: Bool
//}
//
//struct APIRegisterResponse: Codable {
//    let success: Bool
//    let user: APIUser
//}
//
//struct APIMessageResponse: Codable {
//    let message: String
//}
//
