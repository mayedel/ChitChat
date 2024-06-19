//
//  Prueba.swift
//  ChitChat
//
//  Created by María Espejo on 18/6/24.
//

import SwiftUI

struct Prueba: View {
    @State private var token = ""
    @State private var resultMessage = ""
    
    let apiManager = APIManager()
    var usersAPIService: UsersAPIServiceProtocol {
        UsersAPIService(apiManager: apiManager)
    }
    
    var body: some View {
        VStack {
            TextField("Token", text: $token)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: getUserProfile) {
                Text("Get User Profile")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Text(resultMessage)
                .padding()
                .foregroundColor(.red)
        }
        .padding()
    }
    
    func getUserProfile() {
        UsersAPIService(apiManager: apiManager).getUserProfile(token: token, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if let name = user.login {
                        resultMessage = "User profile: \(name)"
                    } else {
                        resultMessage = "Error: User not found"
                    }
                case .failure(let error):
                    resultMessage = "Error: \(error.localizedDescription)"
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Prueba()
    }
}

//func getUserProfileWithURLSession(token: String, completion: @escaping (Result<User, Error>) -> Void) {
//    guard let url = URL(string: "https://mock-movilidad.vass.es/chatvass/api/users/profile") else {
//        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//        return
//    }
//    
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    request.setValue("\(token)", forHTTPHeaderField: "Authorization")
//    request.setValue("*/*", forHTTPHeaderField: "Accept")
//    request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
//    request.setValue(UUID().uuidString, forHTTPHeaderField: "Postman-Token")
//    request.setValue("mock-movilidad.vass.es", forHTTPHeaderField: "Host")
//    request.setValue("PostmanRuntime/7.39.0", forHTTPHeaderField: "User-Agent")
//    request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
//    request.setValue("keep-alive", forHTTPHeaderField: "Connection")
//    
//    print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
//    
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            completion(.failure(error))
//            return
//        }
//        
//        guard let data = data else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
//            return
//        }
//        if let responseString = String(data: data, encoding: .utf8) {
//            print("Response Data: \(responseString)")
//        }
//        
//        do {
//            let decodedResponse = try JSONDecoder().decode(User.self, from: data)
//            completion(.success(decodedResponse))
//        } catch {
//            do {
//                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
//                print("Error Response: \(errorResponse.message)")
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorResponse.message])))
//            } catch {
//                print("Decoding Error: \(error)")
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    task.resume()
//}

struct ErrorResponse: Codable {
    let message: String
}
