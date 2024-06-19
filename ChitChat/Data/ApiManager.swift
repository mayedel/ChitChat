//
//  ApiManager.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation
import Alamofire

protocol APIManagerProtocol {
    func request<T: Decodable>(endpoint: String, method: HTTPMethod, headers: HTTPHeaders?, body: Data?, completion: @escaping (Result<T, Error>) -> Void)
    func testGetUserProfile(token: String, completion: @escaping (Result<User, Error>) -> Void)
}

class APIManager: APIManagerProtocol {
    private let baseURL: String
    private let session: Session
    
    init(baseURL: String = "https://mock-movilidad.vass.es/chatvass/", session: Session = APIManager.defaultSession()) {
        self.baseURL = baseURL
        self.session = session
    }
    
    //borrar luego probar jsonenconding
    static func defaultSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        return Session(configuration: configuration)
    }
    
    func request<T: Decodable>(endpoint: String, method: HTTPMethod, headers: HTTPHeaders?, body: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint, relativeTo: URL(string: baseURL)) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.method = method
        if let headers = headers {
            request.headers = headers
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        session.request(request).validate().responseDecodable(of: T.self) { response in
            if let statusCode = response.response?.statusCode {
                print("HTTP Status Code: \(statusCode)")
            }
            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let underlyingError = error.underlyingError {
                    print("Underlying Error: \(underlyingError.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    func testGetUserProfile(token: String, completion: @escaping (Result<User, Error>) -> Void) {
           let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            print("Authorization Header: \(headers)")
           request(endpoint: "api/users/profile", method: .get, headers: headers, body: nil, completion: completion)
       }
}
