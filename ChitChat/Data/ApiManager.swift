//
//  ApiManager.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation
import Alamofire

protocol APIManagerProtocol {
    func request<T: Decodable>(endpoint: String, method: HTTPMethod, headers: HTTPHeaders?, body: Data?, completion: @escaping (Result<T, AFError>) -> Void)
    func upload<T: Decodable>(endpoint: String, headers: HTTPHeaders?, parameters: [String: String]?, file: Data?, completion: @escaping (Result<T, AFError>) -> Void)
}

class APIManager: APIManagerProtocol {
    private let baseURL = "https://mock-movilidad.vass.es/chatvass/"
    private var session: Alamofire.Session
        
        class WildcardServerTrustPolicyManager: ServerTrustManager {
            override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
                if let policy = evaluators[host] {
                    return policy
                }
                var domainComponents = host.split(separator: ".")
                if domainComponents.count > 2 {
                    domainComponents[0] = "*"
                    let wildcardHost = domainComponents.joined(separator: ".")
                    return evaluators[wildcardHost]
                }
                return nil
            }
        }
    init() {
        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
            "*_.vass.es": PinnedCertificatesTrustEvaluator()
        ]
        let wildcard = WildcardServerTrustPolicyManager(evaluators: serverTrustPolicies)
        self.session = Session(configuration: URLSessionConfiguration.default, serverTrustManager: wildcard)
    }
    
    func request<T: Decodable>(endpoint: String, method: HTTPMethod, headers: HTTPHeaders?, body: Data?, completion: @escaping (Result<T, AFError>) -> Void) {
        guard let url = URL(string: endpoint, relativeTo: URL(string: baseURL)) else {
            completion(.failure(AFError.createURLRequestFailed(error: NSLocale(localeIdentifier: "InvalidUrlError") as! Error)))
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
    
    func upload<T: Decodable>(endpoint: String, headers: HTTPHeaders?, parameters: [String: String]?, file: Data?, completion: @escaping (Result<T, AFError>) -> Void) {
        guard let url = URL(string: endpoint, relativeTo: URL(string: baseURL)) else {
            completion(.failure(AFError.createURLRequestFailed(error: NSLocale(localeIdentifier: "InvalidUrlError") as! Error)))
            return
        }
        
        session.upload(multipartFormData: { multipartFormData in
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.append(Data(value.utf8), withName: key)
                }
            }
            if let file = file {
                multipartFormData.append(file, withName: "file", fileName: "file.txt", mimeType: "text/plain")
            }
        }, to: url, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
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
    
}
