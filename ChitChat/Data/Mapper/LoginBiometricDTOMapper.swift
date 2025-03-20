//
//  LoginBiometricDTOMapper.swift
//  ChitChat
//
//  Created by Andres Cordón on 24/7/24.
//

import Foundation

protocol LoginBiometricDTOMapper {
    func map(_ response: LoginBiometricResponse) -> LoginBiometricModel
}

struct LoginBiometricDTOMapperImpl: LoginBiometricDTOMapper {
    func map(_ response: LoginBiometricResponse) -> LoginBiometricModel {
        .init(token: response.token)
    }
}
