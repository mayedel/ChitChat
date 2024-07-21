//
//  AlertType.swift
//  ChitChat
//
//  Created by Andres Cordón on 3/7/24.
//

import SwiftUI

enum AlertType {
    case success
    case error(title: String, message: String = "")
    
    func title() -> String {
        switch self {
        case .error(title: let title, message: _):
            return title
        case .success:
            return ""
        }
    }
    
    func message() -> String {
        switch self {
        case .error(_, message: let message):
            return message
        case .success:
            return ""
        }
    }
    
    var leftActionText: String {
        switch self {
        case .error( _, _):
            return LocalizedStringKey("Cancel").stringValue()
        case .success:
            return LocalizedStringKey("Cancel").stringValue()
        }
    }
    
    var rightActionText: String {
        switch self {
        case .error(title: _, message: _):
            return LocalizedStringKey("Accept").stringValue()
        case .success:
            return LocalizedStringKey("Accept").stringValue()
        }
    }
}

