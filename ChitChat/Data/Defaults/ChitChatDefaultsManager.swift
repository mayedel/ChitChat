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
    private let USERIDKEY = "UserIdKey"
    private let LAST_READ_MESSAGE_KEY_PREFIX = "LastReadMessage_"
    
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
    
    var userId: String {
        get {
            if let token = userDefaults.string(forKey: USERIDKEY) {
                return token
            }
            return ""
        }
        set {
            userDefaults.setValue(newValue, forKey: USERIDKEY)
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
    
    func saveLastReadMessage(chatId: String, messageId: String, date: String) {
        let key = "\(LAST_READ_MESSAGE_KEY_PREFIX)\(chatId)"
        let data = ["messageId": messageId, "date": date]
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
