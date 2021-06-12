//
//  ConverterInteractor.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import ObjectMapper
import PromiseKit

struct Currency {
    let source: String
    let image: UIImage?
    let name: String
}

extension NumberFormatter {
    func string(from decimal: Decimal) -> String? {
        string(from: decimal as NSDecimalNumber)
    }
    
    static func formatter(forCurrency currency: String) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currency
        numberFormatter.currencySymbol = ""
        return numberFormatter
    }
}

final class ConverterInteractor: ConverterInteractorProtocol {
    var presenter: ConverterInteractorOutputProtocol?
    let service: CurrencyLayerServiceProtocol
    
    var liveQuotes: LiveQuotesResponse?
    var currencies: [String:CurrencyData] = [:]
    
    var liveQuoteTimestampPersistent = Persistent<Double>(key: "LiveQuoteTimestamp", defaultValue: 0)
    var liveQuotePersistent = Persistent<LiveQuotesResponse?>(key: "LiveQuote", defaultValue: nil)
    
    init(service: CurrencyLayerServiceProtocol) {
        self.service = service
    }
    
    private func readCurrencyFile() -> Promise<[String:CurrencyData]> {
        Promise { resolver in
            do {
                guard let url = R.file.currenciesJson() else {
                    resolver.reject(FileError.fileNotFound)
                    return
                }
                guard let jsonData = try String(contentsOf: url).data(using: .utf8) else {
                    resolver.reject(FileError.cannotReadJsonFile)
                    return
                }
                
                let jsonRaw = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                
                guard let json = jsonRaw as? [String:[String:Any]] else {
                    resolver.reject(FileError.cannotParseJson)
                    return
                }
                var currencyDataDict: [String:CurrencyData] = [:]
                json.forEach{ code, currencyJson in
                    currencyDataDict[code] = CurrencyData(JSON: currencyJson)
                }
                resolver.fulfill(currencyDataDict)
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    private func fetchQuotesData() -> Promise<LiveQuotesResponse> {
        guard let liveQuotes = liveQuotePersistent.value, liveQuoteTimestampPersistent.value > Date().timeIntervalSince1970 - 3600 else {
            return service.fetchLiveQuotes()
                .get{ liveQuotes in
                    self.liveQuotePersistent.value = liveQuotes
                    self.liveQuoteTimestampPersistent.value = Date().timeIntervalSince1970
                }
        }
        
        return .value(liveQuotes)
    }
    
    func preloadData() {
        firstly { () -> Promise<(LiveQuotesResponse, [String:CurrencyData])> in
            presenter?.onLiveQuotesFetched(state: .loading)
            return when(fulfilled: fetchQuotesData(), readCurrencyFile())
        }
        .done { liveQuotes, currencies in
            let availableRates = liveQuotes.rates
            var availableCurrencies: [String:CurrencyData] = [:]
            currencies.forEach{ code, currencyData in
                guard availableRates[code] != nil else {
                    return
                }
                availableCurrencies[code] = currencyData
            }
            
            self.currencies = availableCurrencies
            self.liveQuotes = liveQuotes
            self.presenter?.onLiveQuotesFetched(state: .success(availableCurrencies))
        }
        .catch { error in
            self.presenter?.onLiveQuotesFetched(state: .failure(error))
        }
    }
    
    func getRate(with liveQuotes: LiveQuotesResponse, fromCurrency: String, toCurrency: String) -> Decimal? {
        if let rate = liveQuotes.quotes["\(fromCurrency)\(toCurrency)"] {
            return NSNumber(value: rate).decimalValue
        }
        
        if let rate = liveQuotes.quotes["\(toCurrency)\(fromCurrency)"], rate > 0 {
            return 1 / NSNumber(value: rate).decimalValue
        }
        
        let source = liveQuotes.source
        if let sourceToFromRate = liveQuotes.quotes["\(source)\(fromCurrency)"],
           let sourceToToRate = liveQuotes.quotes["\(source)\(toCurrency)"],
           sourceToFromRate > 0 {
            return NSNumber(value: sourceToToRate).decimalValue / NSNumber(value: sourceToFromRate).decimalValue
        }
        
        return nil
    }
    
    func convert(inputText: String?, fromCurrency: String?, toCurrency: String?) {
        guard let fromCurrency = fromCurrency, let toCurrency = toCurrency else {
            return
        }
        
        let fromNumberFormatter = NumberFormatter.formatter(forCurrency: fromCurrency)
        let toNumberFormatter = NumberFormatter.formatter(forCurrency: toCurrency)
        
        guard let inputText = inputText?.replacingOccurrences(of: Locale.current.groupingSeparator ?? "", with: ""),
              let value = fromNumberFormatter.number(from: inputText)?.decimalValue,
              let liveQuotes = liveQuotes,
              let rate = getRate(with: liveQuotes, fromCurrency: fromCurrency, toCurrency: toCurrency) else {
            return
        }
        
        guard let toResult = toNumberFormatter.string(from: value * rate),
              let fromResult = fromNumberFormatter.string(from: value) else {
            return
        }
        
        presenter?.onConvertSuccess(fromResult: fromResult, toResult: toResult)
    }
}
