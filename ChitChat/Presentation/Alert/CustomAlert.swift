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
                    Image(alertType.icon).resizable().scaledToFit()
                        .frame(width: 20,height: 20)
                        .foregroundColor(.black)
                    
                    Text(alertType.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }.padding(.top, 16)
                .padding(.horizontal, 16)
                
                HStack {
                    Text(alertType.message)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(16)
                        .minimumScaleFactor(0.5)
                    .background(Color.white)
                }
                
                HStack(spacing: 5) {
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
                    .background(Color.gray.opacity(0.3))
                    .buttonBorderShape(.roundedRectangle).cornerRadius(10.0)
                    Spacer(minLength: 3)
                    Button {
                        rightButtonAction?()
                        presentAlert = false
                    } label: {
                        Text(alertType.rightActionText)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                    }
                    .background(Color.customBlue)
                    .buttonBorderShape(.roundedRectangle).cornerRadius(10.0)
                    
                }.padding(.horizontal, 15)
                .padding(.bottom, 15)
                
            }
            .frame(width: 270)
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
            alertType: .error(title: LocalizedStringKey("BiometricAccess").stringValue(), message: LocalizedStringKey("BiometricMessage").stringValue(), icon: "message"),
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
