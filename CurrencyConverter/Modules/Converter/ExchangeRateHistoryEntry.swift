//
//  ExchangeRateHistoryEntry.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/13/21.
//

import Foundation

public struct ExchangeRateHistoryEntry {
    var date: Date
    var source: CurrencyData
    var destination: CurrencyData
    var rate: Decimal
    
    var entryDisplay: String {
        let dateFormatter = DateFormatter.short
        let numberFormatter = NumberFormatter.formatter(forCurrency: destination.code)
        if rate < 0.01 {
            numberFormatter.maximumFractionDigits = 6
        }
        return "\(dateFormatter.string(from: date)): 1 \(source.code) ≈ \(numberFormatter.string(from: rate) ?? "0.00") \(destination.code)"
    }
}
