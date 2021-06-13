//
//  CurrencyLayerService.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import ObjectMapper
import Alamofire
import PromiseKit

enum CurrencyLayerRouter: Alamofire.URLRequestConvertible {
    static let baseURL = URL(string: "http://api.currencylayer.com/")!
    static let apiKey = "15ec637620b129d17a5334393daa4dbe"

    case getLiveQuotesTLE(source: String)

    var parameters: Parameters {
        var parameters: Parameters = [
            "access_key": CurrencyLayerRouter.apiKey,
        ]
        
        switch self {
        case .getLiveQuotesTLE(let source):
            parameters["source"] = source
        }
        
        return parameters
    }
    
    var path: String {
        switch self {
        case .getLiveQuotesTLE: return "live"
        }
    }
    
    var url: URL {
        CurrencyLayerRouter.baseURL.appendingPathComponent(path)
    }

    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try URLEncoding.queryString.encode(request, with: parameters)
    }
}

public protocol CurrencyLayerServiceProtocol {
    func fetchExchangeData(source: String) -> Promise<ExchangeData>
}

extension CurrencyLayerServiceProtocol {
    func fetchExchangeData() -> Promise<ExchangeData> {
        return fetchExchangeData(source: "USD")
    }
}

class CurrencyLayerService: Service, CurrencyLayerServiceProtocol {
    static let shared = CurrencyLayerService()
    
    func fetchExchangeData(source: String) -> Promise<ExchangeData> {
        request(urlRequest: CurrencyLayerRouter.getLiveQuotesTLE(source: source))
    }
}
