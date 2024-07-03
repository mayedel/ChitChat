//
//  Extensions.swift
//  ChitChat
//
//  Created by Andres Cordón on 3/7/24.
//

import Foundation
import SwiftUI

extension View {
    func toastView(toastView: ToastView, show: Binding<Bool>) -> some View {
        self.modifier(ToastModifier.init(show: show, toastView: toastView))
    }
}
