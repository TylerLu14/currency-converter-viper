//
//  ExchangeData.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/13/21.
//

import ObjectMapper

public struct ExchangeData: Mappable, Persistable {
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
    
    public init() {
        terms = nil
        privacy = nil
        timestamp = 0
        source = ""
        quotes = [:]
    }
    
    public init?(map: Map) {
        terms = nil
        privacy = nil
        timestamp = 0
        source = ""
        quotes = [:]
    }
    
    public mutating func mapping(map: Map) {
        terms <- (map["terms"], URLTransform())
        privacy <- (map["privacy"], URLTransform())
        timestamp <- map["timestamp"]
        source <- map["source"]
        quotes <- map["quotes"]
    }
    
    func getRate(from source: String, to destination: String) -> Decimal? {
        if let rate = quotes["\(source)\(destination)"] {
            return NSNumber(value: rate).decimalValue
        }
        
        if let rate = quotes["\(destination)\(source)"], rate > 0 {
            return NSNumber(value: 1/rate).decimalValue
        }
        
        if let sourceToFromRate = rates[source],
           let sourceToToRate = rates[destination],
           sourceToFromRate > 0 {
            return NSNumber(value: sourceToToRate / sourceToFromRate).decimalValue
        }
        
        return nil
    }
    
    func getRate(from source: CurrencyData, to destination: CurrencyData) -> Decimal? {
        getRate(from: source.code, to: destination.code)
    }
}


struct ExchangeDataHistory: Mappable, Persistable {
    var records: [ExchangeDataRecord]
    
    init(records: [ExchangeDataRecord]) {
        self.records = records
    }
    
    init?(map: Map) {
        records = []
    }
    
    mutating func mapping(map: Map) {
        records <- map["records"]
    }
    
    func getExchangeHistoryEntries(source: CurrencyData?, destination: CurrencyData?) -> [ExchangeRateHistoryEntry] {
        guard let source = source, let destination = destination else {
            return []
        }
        
        return records.map { record in
            ExchangeRateHistoryEntry(
                date: record.timestampDate,
                source: source,
                destination: destination,
                rate: record.exchangeData.getRate(from: source, to: destination) ?? 0
            )
        }
    }
}

struct ExchangeDataRecord: Mappable, Persistable {
    var timestamp: TimeInterval
    var timestampDate: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    var exchangeData: ExchangeData
    
    init?(map: Map) {
        timestamp = 0
        exchangeData = ExchangeData()
    }
    
    init(exchangeData: ExchangeData, timestamp: TimeInterval) {
        self.exchangeData = exchangeData
        self.timestamp = timestamp
    }
    
    mutating func mapping(map: Map) {
        timestamp <- map["timestamp"]
        exchangeData <- map["exchangeData"]
    }
}

