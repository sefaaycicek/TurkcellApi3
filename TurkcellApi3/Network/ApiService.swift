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
    func searchMovies() -> RxSwift.Single<MovieEntityResponse?>
}

class ApiService : ApiServiceProtocol {
    private let manager = HTTPManager.shared
    private var headers : [String : String] = ["Content-Type" : "application/json",
                                              "authorization" : "apikey 5IlsFwtkraxsj2NtgYY4sS:7CfJyGGSTlxLJWAEXmIbfz"]
    private let encoding = JSONEncoding.default
    
    func searchMovies() -> RxSwift.Single<MovieEntityResponse?> {
        return request(methodType: .post, url: URL.init(string: "https://api.collectapi.com/imdb/imdbSearchByName?query=yerli")!)
    }
    
    private func request<T : Codable>(methodType : HTTPMethod, url : URL, parameters : [String : AnyObject]? = nil) -> Single<T?> {
        let validateRange = Array(200..<400) + Array(402..<501)
        
        var httpHeader = HTTPHeaders()
        headers.forEach { (key, value) in
            httpHeader.add(name: key, value: value)
        }
        
        return manager.rx.request(methodType, url, parameters: parameters, encoding: encoding, headers: httpHeader)
            .validate(statusCode: validateRange)
            .responseString()
            .asSingle()
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
            
            let manager = HTTPManager(configuration: configuration)
            return manager
        }()
    }
}
