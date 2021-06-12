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

struct LiveQuotesResponse: Mappable, Persistable {
    var terms: URL?
    var privacy: URL?
    var timestamp: Int64
    var source: String
    var quotes: [String:Double]
    
    //currency rate comparing to source
    var rates: [String:Double] {
        var rates: [String:Double] = [:]
        quotes.forEach{ pair, rate in
            let code = String(pair.dropFirst(source.count))
            rates[code] = rate
        }
        return rates
    }
    
    init() {
        terms = nil
        privacy = nil
        timestamp = 0
        source = ""
        quotes = [:]
    }
    
    init?(map: Map) {
        terms = nil
        privacy = nil
        timestamp = 0
        source = ""
        quotes = [:]
    }
    
    mutating func mapping(map: Map) {
        terms <- (map["terms"], URLTransform())
        privacy <- (map["privacy"], URLTransform())
        timestamp <- map["timestamp"]
        source <- map["source"]
        quotes <- map["quotes"]
    }
}

protocol CurrencyLayerServiceProtocol {
    func fetchLiveQuotes(source: String) -> Promise<LiveQuotesResponse>
}

extension CurrencyLayerServiceProtocol {
    func fetchLiveQuotes() -> Promise<LiveQuotesResponse> {
        return fetchLiveQuotes(source: "USD")
    }
}

class CurrencyLayerService: Service, CurrencyLayerServiceProtocol {
    static let shared = CurrencyLayerService()
    
    func fetchLiveQuotes(source: String) -> Promise<LiveQuotesResponse> {
        request(urlRequest: CurrencyLayerRouter.getLiveQuotesTLE(source: source))
    }
}
