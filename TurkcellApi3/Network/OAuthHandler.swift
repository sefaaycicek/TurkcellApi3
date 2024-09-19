//
//  OAuthHandler.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 19.09.2024.
//

import Foundation
import RxAlamofire
import Alamofire

class OAuthHandler : RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var mutableRequest = urlRequest
        mutableRequest.setValue(Constants.token, forHTTPHeaderField: "authorization")
        completion(.success(mutableRequest))
    }
    
    let retryLimit = 2
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        
        if statusCode == 401 {
            Constants.token = "apikey 5IlsFwtkraxsj2NtgYY4sS:7CfJyGGSTlxLJWAEXmIbfz"
            completion(.retry)
        } else {
            completion(.doNotRetry)
        }
    }
    
    func method() throws {
        throw NSError(domain: "", code: 100)
    }
}
