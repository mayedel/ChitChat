//
//  Extensions.swift
//  ChitChat
//
//  Created by Andres Cordón on 3/7/24.
//

import Foundation
import SwiftUI

extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
}

extension String {
    static func localizedString(for key: String,
                                locale: Locale = .current) -> String {
        
        let language = locale.languageCode
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
}

extension LocalizedStringKey {
    func stringValue(locale: Locale = .current) -> String {
        return .localizedString(for: self.stringKey!, locale: locale)
    }
}

extension Color {
    static let customBlue = Color(red: 49 / 255, green: 177 / 255, blue: 205 / 255)
    static let customGreen = Color(red: 76/255, green: 175/255, blue: 80/255)
    
}


extension DateFormatter {
    static func formatDate(dateString: String?) -> String {
        guard let dateString = dateString, !dateString.isEmpty else {
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: dateString) {
            if Calendar.current.isDateInToday(date) {
                return fixedServerHour(messageTime: dateString)
            } else {
                dateFormatter.dateFormat = "dd/MM/yy" 
            }
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    static func getActualDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    static func fixedServerHour(messageTime: String?) -> String {
        guard let messageTime = messageTime else { return "" }
        
        let deviceTime = Date()
        let offsetInSeconds = TimeZone.current.secondsFromGMT(for: deviceTime)
        let offsetInHours = Double(offsetInSeconds) / 3600.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let zonedDateTime = dateFormatter.date(from: messageTime) {
            
            let updatedZonedDateTime = zonedDateTime.addingTimeInterval((2 + offsetInHours) * 3600)
            
            dateFormatter.dateFormat = "HH:mm"
            
            return dateFormatter.string(from: updatedZonedDateTime)
        }
        
        return "Fecha incorrecta"
    }
    
    static func convertStringToDate(date: String) -> Date {

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.date(from: date) ?? Date()
    }
}


