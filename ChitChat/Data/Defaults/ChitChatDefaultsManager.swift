//
//  ChitChatDefaultsManager.swift
//  ChitChat
//
//  Created by Andres Cordón on 15/7/24.
//

import Foundation

class ChitChatDefaultsManager {
    static let shared = ChitChatDefaultsManager()
    
    private let TOKENKEY = "TokenKey"
    private let AVATARKEY = "AvatarKey"
    
    private let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    var token: String {
        get {
            if let token = userDefaults.string(forKey: TOKENKEY) {
               return token
            }
            return ""
        }
        set {
            userDefaults.setValue(newValue, forKey: TOKENKEY)
        }
    }
    
    var avatar: String {
        get {
            if let avatar = userDefaults.string(forKey: AVATARKEY) {
               return avatar
            }
            return ""
        }
        set {
            userDefaults.setValue(newValue, forKey: AVATARKEY)
        }
    }
}
