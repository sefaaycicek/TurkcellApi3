//
//  ApiService.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 19.09.2024.
//

import UIKit
import RxAlamofire
import RxSwift
import Alamofire

protocol ApiServiceProtocol {
    func searchMovies(searchText : String) -> RxSwift.Single<MovieEntityResponse?>
}

class ApiService : ApiServiceProtocol {
    private let manager = HTTPManager.shared
    private var headers : [String : String] = ["Content-Type" : "application/json",
                                               "authorization" : Constants.token]
    private let encoding = JSONEncoding.default
    
    func searchMovies(searchText : String) -> RxSwift.Single<MovieEntityResponse?> {
        return request(methodType: .post, url: URL.init(string: "https://api.collectapi.com/imdb/imdbSearchByName?query=\(searchText)")!)
    }
    
    private func request<T : Codable>(methodType : HTTPMethod, url : URL, parameters : [String : AnyObject]? = nil) -> Single<T?> {
        let validateRange = Array(200..<400) + Array(402..<501) // 401 range dışında, token refreshleyebilmek için
        
        var httpHeader = HTTPHeaders()
        headers.forEach { (key, value) in
            httpHeader.add(name: key, value: value)
        }
        
        headers["authorization"] = Constants.token
        
        return manager.rx.request(methodType, url, parameters: parameters, encoding: encoding, headers: httpHeader)
            .validate(statusCode: validateRange)
            .responseString()
            .asSingle()
            .catch { error -> Single<(HTTPURLResponse, String)> in
                var responseCode = 0
                if let authorizationError = error as? AFError {
                    responseCode = authorizationError.responseCode ?? 0
                    if authorizationError.responseCode == 401 {
                        return Single.error(NSError(domain: "Lütfen yeniden giriş yapınız.", code: 401))
                    }
                }
                return Single.error(NSError(domain: "Genel bir hata oluştu", code: responseCode))
            }
            .flatMap { json -> Single<T?> in
                let jsonString = json.1
                let statusCode = json.0.statusCode
                
                guard let data = jsonString.data(using: .utf8) else { return Single.just(nil) }
                
                if statusCode == 200 {
                    let response = try? JSONDecoder().decode(T.self, from: data)
                    return Single.just(response)
                }
                
                return Single.just(nil)
            }
        
    }
    
    final class HTTPManager : Alamofire.Session {
        static let shared : HTTPManager = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            
            let interceptor = OAuthHandler()
            
            let manager = HTTPManager(configuration: configuration, interceptor: interceptor)
            return manager
        }()
    }
}
