//
//  AlertType.swift
//  ChitChat
//
//  Created by Andres Cordón on 3/7/24.
//

import SwiftUI

enum AlertType {
    case success
    case error(title: String, message: String, icon: String)
    
    var title: String {
        switch self {
        case .error(let title, _, _):
            return title
        case .success:
            return ""
        }
    }
    
    var message: String {
        switch self {
        case .error(_, let message, _):
            return message
        case .success:
            return ""
        }
    }
    
    var icon: String {
        switch self {
        case .error(_, _, let icon):
            return icon
        case .success:
            return ""
        }
    }
    
    var leftActionText: String {
        return LocalizedStringKey("Cancel").stringValue()
    }
    
    var rightActionText: String {
        return LocalizedStringKey("Accept").stringValue()
    }
}
