//
//  Service.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Alamofire
import PromiseKit
import Foundation
import ObjectMapper

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotParseData: return "Cannot parse data"
        case .currencyNotFound: return "The convert currency cannot be found"
        }
    }
}

public struct PMKAlamofireDataResponse {
    public init<T,E>(_ rawrsp: Alamofire.DataResponse<T,E>) {
        request = rawrsp.request
        response = rawrsp.response
        data = rawrsp.data
    }

    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?
}

extension Alamofire.DataRequest {
    typealias ResponseType = (value: Any, response: PMKAlamofireDataResponse)
    func responseJSONAny(queue: DispatchQueue = .global(), options: JSONSerialization.ReadingOptions = .allowFragments) -> Promise<ResponseType> {
        return Promise<ResponseType> { resolver in
            responseJSON(queue: queue, options: options) { response in
                print("Request:", String(describing: response.debugDescription))
                print("Response:", String(describing: response.debugDescription))
                
                switch response.result {
                case .success(let value):
                    resolver.fulfill((value, PMKAlamofireDataResponse(response)))
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func responseJSON(queue: DispatchQueue = .global(), options: JSONSerialization.ReadingOptions = .allowFragments) -> Promise<(json: [String:Any], response: PMKAlamofireDataResponse)> {
        responseJSONAny(queue: queue, options: options)
            .then { json, rawResponse -> Promise<(json: [String:Any], response: PMKAlamofireDataResponse)> in
                guard let json = json as? [String:Any] else {
                    return Promise(error: ServiceError.cannotParseData)
                }
                return Promise.value((json, rawResponse))
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


class Service {
    let networkManager = NetworkManager.sharedManager
    
    func request(urlRequest: Alamofire.URLRequestConvertible) -> Promise<[String: Any]> {
        self.networkManager.alamofireSession.request(urlRequest)
            .responseJSON(queue: .global(qos: .background))
            .map { json, _ in json }
    }
    
    func request<T:Mappable>(urlRequest: Alamofire.URLRequestConvertible) -> Promise<T> {
        request(urlRequest: urlRequest)
            .then { json -> Promise<T> in
                guard let response = Mapper<T>().map(JSON: json) else {
                    return Promise(error: ServiceError.cannotParseData)
                }
                return .value(response)
            }
    }
}
