//
//  CurrencyData.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/12/21.
//

import Foundation
import ObjectMapper

public struct CurrencyData: Mappable, Persistable {
    public var symbol: String
    public var name: String
    public var symbolNative: String
    public var decimalDigits: Int
    public var rounding: String
    public var code: String
    public var namePlural: String
    
    static let usd = CurrencyData(JSON: [
        "symbol": "$",
        "name": "US Dollar",
        "symbol_native": "$",
        "decimal_digits": 2,
        "rounding": 0,
        "code": "USD",
        "name_plural": "US dollars"
    ])!
    
    static let vnd = CurrencyData(JSON: [
        "symbol": "₫",
        "name": "Vietnamese Dong",
        "symbol_native": "₫",
        "decimal_digits": 0,
        "rounding": 0,
        "code": "VND",
        "name_plural": "Vietnamese dong"
    ])!
    
    public init?(map: Map) {
        symbol = ""
        name = ""
        symbolNative = ""
        decimalDigits = 0
        rounding = ""
        code = ""
        namePlural = ""
    }
    
    public mutating func mapping(map: Map) {
        symbol <- map["symbol"]
        name <- map["name"]
        symbolNative <- map["symbol_native"]
        decimalDigits <- map["decimal_digits"]
        rounding <- map["rounding"]
        code <- map["code"]          
        namePlural <- map["name_plural"]
    }
}
