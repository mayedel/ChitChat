//
//  ApiManager.swift
//  ChitChat
//
//  Created by María Espejo on 13/6/24.
//

import Foundation
import Alamofire

protocol APIManagerProtocol {
    func request<T: Decodable>(endpoint: String, method: String, headers: [String: String]?, body: Data?, completion: @escaping (Result<T, Error>) -> Void)
}

class APIManager: APIManagerProtocol {
    // private let baseUrl = "https://mock-movilidad.vass.es/chatvass"
    
    private let baseURL: URL
    private let session: URLSession
    
    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: String, method: String, headers: [String: String]?, body: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}


