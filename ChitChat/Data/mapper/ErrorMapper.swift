//
//  ErrorMapper.swift
//  ChitChat
//
//  Created by Andres Cordón on 2/7/24.
//

import Foundation
import Alamofire

struct ErrorMapper {
    func mapErrorResponse(error: AFError) -> ErrorModel {
        return ErrorModel(code: error.responseCode, message: error.errorDescription)
    }
}
