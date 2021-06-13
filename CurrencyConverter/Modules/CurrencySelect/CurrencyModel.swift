//
//  CurrencyModel.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/13/21.
//

import UIKit

public struct CurrencyModel {
    var data: CurrencyData
    var sourceCode: String?
    var image: UIImage?
    var exchangeRate: Decimal?
    var exchangeRateText: String? {
        guard let exchangeRate = exchangeRate, let sourceCode = sourceCode,
              let exchangeRateString = NumberFormatter.formatter(forCurrency: data.code).string(from: exchangeRate) else {
            return nil
        }
        
        return "1 \(sourceCode) ≈ \(exchangeRateString) \(data.code)"
    }
    
    init(currencyData: CurrencyData, sourceCode: String?, exchangeRate: Decimal?) {
        self.sourceCode = sourceCode
        self.data = currencyData
        self.image = UIImage(named: currencyData.code.lowercased())
        self.exchangeRate = exchangeRate
    }
}
