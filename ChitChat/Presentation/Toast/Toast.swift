//
//  Toast.swift
//  ChitChat
//
//  Created by Andres Cordón on 3/7/24.
//

import Foundation
import SwiftUI

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
}

enum ToastStyle {
    case error
    case success
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .success: return Color.green
        }
    }
    
    var iconFileName: String {
       switch self {
       case .success: return "checkmark.circle.fill"
       case .error: return "xmark.circle.fill"
       }
     }
}
