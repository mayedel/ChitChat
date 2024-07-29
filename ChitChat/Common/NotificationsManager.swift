//
//  NotificationsManager.swift
//  ChitChat
//
//  Created by Andres Cordón on 28/7/24.
//

import Foundation
import UserNotifications

struct NotificationsManager {
    static func sendNotification(message: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Nuevo mensaje"
        content.body = message
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
