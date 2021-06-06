//
//  CurrencyLayerService.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import RxSwift
import ObjectMapper
import Alamofire

enum CurrencyLayerRouter: URLRequestConvertible {
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
    var url: URL {
        CurrencyLayerRouter.baseURL
    }

    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try URLEncoding.queryString.encode(request, with: parameters)
    }
}

struct LiveQuotesResponse: Mappable {
    var terms: URL
    var privacy: URL
    var timestamp: Date
    var source: String
    var quotes: [String:Decimal]
    
    init?(map: Map) {
        return nil
    }
    
    mutating func mapping(map: Map) {
        terms <- map["terms"]
        privacy <- map["privacy"]
        timestamp <- map["timestamp"]
        source <- map["source"]
        quotes <- map["quotes"]
    }
}

protocol CurrencyLayerServiceProtocol {
    func fetchLiveQuotes(source: String) -> Single<LiveQuotesResponse>
}

extension CurrencyLayerServiceProtocol {
    func fetchLiveQuotes() -> Single<LiveQuotesResponse> {
        return fetchLiveQuotes(source: "USD")
    }
}

class CurrencyLayerService: Service, CurrencyLayerServiceProtocol {
    static let shared = CurrencyLayerService()
    
    func fetchLiveQuotes(source: String) -> Single<LiveQuotesResponse> {
        request(urlRequest: CurrencyLayerRouter.getLiveQuotesTLE(source: source))
    }
}
