//
//  ChitChatDefaultsManager.swift
//  ChitChat
//
//  Created by Andres Cordón on 15/7/24.
//

import Foundation

class ChitChatDefaultsManager {
    static let shared = ChitChatDefaultsManager()
    
    private let TOKEN_KEY = "TokenKey"
    private let AVATAR_KEY = "AvatarKey"
    private let USERID_KEY = "UserIdKey"
    private let BIOMETRIC_KEY = "BiometricKey"
    
    private let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    var token: String {
        get {
            if let token = userDefaults.string(forKey: TOKEN_KEY) {
               return token
            }
            return ""
        }
        set {
            userDefaults.setValue(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userId: String {
        get {
            if let token = userDefaults.string(forKey: USERID_KEY) {
               return token
            }
            return ""
        }
        set {
            userDefaults.setValue(newValue, forKey: USERID_KEY)
        }
    }
    
    var avatar: String {
        get {
            if let avatar = userDefaults.string(forKey: AVATAR_KEY) {
               return avatar
            }
            return ""
        }
        set {
            userDefaults.setValue(newValue, forKey: AVATAR_KEY)
        }
    }
    
    
    var isBiometricEnabled: Bool {
        get {
            return userDefaults.bool(forKey: BIOMETRIC_KEY)
        }
        set {
            userDefaults.setValue(newValue, forKey: BIOMETRIC_KEY)
        }
    }
}
