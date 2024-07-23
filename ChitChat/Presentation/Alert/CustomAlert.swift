//
//  CustomAlert.swift
//  ChitChat
//
//  Created by Andres Cordón on 3/7/24.
//

import SwiftUI

struct CustomAlert: View {
    
    @Binding var presentAlert: Bool
    
    @State var alertType: AlertType = .success
    
    var leftButtonAction: (() -> ())?
    var rightButtonAction: (() -> ())?
    
    var body: some View {
        
        ZStack {
            
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                    
                    Text(alertType.title())
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 16)
                        .padding(.trailing, 16)
                    
                    Spacer()
                }
                
                Text(alertType.message())
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .minimumScaleFactor(0.5)
                
                Divider()
                    .background(Color.gray)
                
                HStack(spacing: 0) {
                        Button {
                            leftButtonAction?()
                            presentAlert = false
                        } label: {
                            Text(alertType.leftActionText)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                        }
                        Divider()
                            .background(Color.gray)
                    
                    Button {
                        rightButtonAction?()
                        presentAlert = false
                    } label: {
                        Text(alertType.rightActionText)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.customBlue)
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                    }
                    
                }
                
            }
            .frame(width: 270, height: 220)
            .background(
                Color.white
            )
            .cornerRadius(10)
            .shadow(radius: 10)
        }
    }
}

struct CustomAlert_Previews: PreviewProvider {
    @State static var showAlert = true
    
    static var previews: some View {
        CustomAlert(
            presentAlert: $showAlert,
            alertType: .error(title: "¿Eliminar chat?", message: "Al no ser el creador de la conversación no puedes borrarla de la base de datos, ¿quieres eliminarla de tu lista de conversaciones?"),
            leftButtonAction: {
                showAlert = false
            },
            rightButtonAction: {
                showAlert = false
            }
        )
            .previewLayout(.sizeThatFits)
    }
}
