//
//  Service.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Alamofire
import RxSwift
import RxCocoa
import Foundation
import ObjectMapper

public enum ServiceError: Error {
    case cannotParseData
    case currencyNotFound
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotParseData: return "Cannot parse data"
        case .currencyNotFound: return "The convert currency cannot be found"
        }
    }
}

class NetworkManager {
    static let sharedManager = NetworkManager()
    let alamofireSession: Session

    init() {
        let alamofireConfig = URLSessionConfiguration.default
        alamofireConfig.httpShouldSetCookies = true
        alamofireConfig.httpCookieAcceptPolicy = .always
        alamofireConfig.requestCachePolicy = .useProtocolCachePolicy
        alamofireConfig.timeoutIntervalForRequest = 10
        alamofireConfig.urlCache = URLCache()
        alamofireSession = Session(configuration: alamofireConfig)
    }
}

protocol ServiceProtocol {
    func request(urlRequest: URLRequestConvertible) -> Single<[String: Any]>
}

class Service {
    let networkManager = NetworkManager.sharedManager
    
    func request(urlRequest: URLRequestConvertible) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { single in
            let request = self.networkManager.alamofireSession.request(urlRequest)
            request.responseJSON { response in
                if let error = response.error {
                    single(.failure(error))
                    return
                }

                switch response.result {
                case .failure(let error):
                    single(.failure(error))
                case .success(let json):
                    guard let json = json as? [String: Any] else {
                        single(.failure(ServiceError.cannotParseData))
                        break
                    }
                    single(.success(json))
                }
            }
            return Disposables.create { request.cancel() }
        }
        .subscribe(on: scheduler.concurrentUser)
        .do(onError: { error in
            print(error)
        })
    }
    
    func request<T:Mappable>(urlRequest: URLRequestConvertible) -> Single<T> {
        request(urlRequest: urlRequest)
            .flatMap{ json in
                guard let response = Mapper<T>().map(JSON: json) else {
                    return .error(ServiceError.cannotParseData)
                }
                return .just(response)
            }
    }
}
