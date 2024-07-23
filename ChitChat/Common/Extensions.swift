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
    static let customBlue = Color(red: 45/255, green: 156/255, blue: 219/255)
    static let customGreen = Color(red: 76/255, green: 175/255, blue: 80/255)
    
}


extension DateFormatter {
    static func formatDate(dateString: String?, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> String {
        guard let dateString = dateString, !dateString.isEmpty else {
            return "Hora no disponible"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: dateString) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "dd/MM/yy" 
            }
            return dateFormatter.string(from: date)
        }
        return "Fecha incorrecta"
    }
    
    static func getActualDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}


