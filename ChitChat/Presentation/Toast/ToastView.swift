//
//  ToastView.swift
//  ChitChat
//
//  Created by Andres Cordón on 3/7/24.
//

import SwiftUI

struct ToastView: View {
    
    let toast: Toast
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: toast.style.iconFileName)
                Text(toast.message)
            }.font(.headline)
                .foregroundColor(.primary)
                .padding([.top,.bottom],20)
                .padding([.leading,.trailing],40)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
        }
        .frame(width: UIScreen.main.bounds.width / 1.25)
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                self.show = false
            }
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.show = false
                }
            }
        })
    }
}
