//
//  CurrencyData.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/12/21.
//

import Foundation
import ObjectMapper

struct CurrencyData: Mappable {
    var symbol: String
    var name: String
    var symbolNative: String
    var decimalDigits: Int
    var rounding: String
    var code: String
    var namePlural: String
    
    init?(map: Map) {
        symbol = ""
        name = ""
        symbolNative = ""
        decimalDigits = 0
        rounding = ""
        code = ""
        namePlural = ""
    }
    
    mutating func mapping(map: Map) {
        symbol <- map["symbol"]
        name <- map["name"]
        symbolNative <- map["symbol_native"]
        decimalDigits <- map["decimal_digits"]
        rounding <- map["rounding"]
        code <- map["code"]          
        namePlural <- map["name_plural"]
    }
}
