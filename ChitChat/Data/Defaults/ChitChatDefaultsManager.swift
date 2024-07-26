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
    private let LAST_READ_MESSAGE_KEY_PREFIX = "LastReadMessage_"
    
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
    
    func saveLastReceivedMessage(chatId: String, messageId: String, date: String) {
            let key = "\(LAST_READ_MESSAGE_KEY_PREFIX)\(chatId)"
            let data = ["messageId": messageId, "date": date]
            print("Saving last received message for chat: \(chatId) with data: \(data)")
            userDefaults.setValue(data, forKey: key)
        }

        
        func saveLastReadMessage(chatId: String, messageId: String, date: String) {
            let key = "\(LAST_READ_MESSAGE_KEY_PREFIX)\(chatId)"
            let data = ["messageId": messageId, "date": date]
            print("CCDM. Saving last read message for chat: \(chatId) with data: \(data)")
            userDefaults.setValue(data, forKey: key)
        }
        
        func getLastReadMessage(chatId: String) -> (messageId: String, date: String)? {
            let key = "\(LAST_READ_MESSAGE_KEY_PREFIX)\(chatId)"
            if let data = userDefaults.dictionary(forKey: key) as? [String: String],
               let messageId = data["messageId"],
               let date = data["date"] {
                return (messageId, date)
            }
            return nil
        }
}
