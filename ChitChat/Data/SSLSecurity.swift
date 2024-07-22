//
//  SSLSecurity.swift
//  ChitChat
//
//  Created by María Espejo on 22/7/24.
//
//import Foundation
//import Alamofire
//
//class SSLSecurity {
//    static let shared = SSLSecurity()
//
//    class WildcardServerTrustPolicyManager: ServerTrustManager {
//        override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
//            if let policy = evaluators[host] {
//                return policy
//            }
//            var domainComponents = host.split(separator: ".")
//            if domainComponents.count > 2 {
//                domainComponents[0] = "*"
//                let wildcardHost = domainComponents.joined(separator: ".")
//                return evaluators[wildcardHost]
//            }
//            return nil
//        }
//    }
//
//    func session() -> Session? {
//        guard let certificate = SSLSecurity.certificate() else {
//            print("Certificate not found")
//            return nil
//        }
//        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
//            "*.vass.es": PinnedCertificatesTrustEvaluator(certificates: [certificate])
//        ]
//        let wildcard = WildcardServerTrustPolicyManager(evaluators: serverTrustPolicies)
//        return Session(configuration: URLSessionConfiguration.default, serverTrustManager: wildcard)
//    }
//
//    private static func certificate() -> SecCertificate? {
//        guard let localCertPath = Bundle.main.path(forResource: "_.vass.es", ofType: "pem"),
//              let localCertData = try? Data(contentsOf: URL(fileURLWithPath: localCertPath)),
//              let localCert = SecCertificateCreateWithData(nil, localCertData as CFData) else {
//            print("Error loading certificate")
//            return nil
//        }
//        return localCert
//    }
//}
//
