//
//  BiometricAuthentication.swift
//  ChitChat
//
//  Created by Andres Cordón on 24/7/24.
//

import Foundation
import LocalAuthentication

struct BiometricAuthentication {
    
    let localAuthenticationContext: LAContext
    
    init(context: LAContext = LAContext()) {
        self.localAuthenticationContext = context
        self.localAuthenticationContext.localizedFallbackTitle = "Por favor, utiliza tu código de desbloqueo"
    }
    
    public func authenticationWithBiometric(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics, reason: String = "Autenticación requerida para continuar", onSuccess: @escaping () -> Void, onFailure: @escaping (LAError) -> Void) {
        
        localAuthenticationContext.evaluatePolicy(policy, localizedReason: reason) { success, error in
            if success {
                onSuccess()
            } else {
                if let error = error as? LAError {
                    onFailure(error)
                }
            }
        }
    }
}
