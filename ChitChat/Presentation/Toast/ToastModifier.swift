//
//  ToastModifier.swift
//  ChitChat
//
//  Created by Andres Cordón on 3/7/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
  
    @Binding var show: Bool
        
    let toastView: ToastView
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                toastView
            }
        }
    }
}
