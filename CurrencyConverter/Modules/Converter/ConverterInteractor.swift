//
//  ConverterInteractor.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import ObjectMapper
import PromiseKit

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

public struct ConverterState {
    public var timestamp: TimeInterval
    public var timestampDate: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    public var timestampDisplay: String {
        "Last fetched exchange rate data:\n\(DateFormatter.standard.string(from: timestampDate))"
    }
    
    public var exchangeData: ExchangeData
    public var currencies: [String:CurrencyData]
    
    public var sourceCurrency: CurrencyData?
    public var destinationCurrency: CurrencyData?
    public var exchangeEntries: [ExchangeRateHistoryEntry]
    
    public init(timestamp: TimeInterval,
                exchangeData: ExchangeData,
                currencies: [String:CurrencyData],
                sourceCurrency: CurrencyData?,
                destinationCurrency: CurrencyData?,
                exchangeEntries: [ExchangeRateHistoryEntry]) {
        self.timestamp = timestamp
        self.exchangeData = exchangeData
        self.currencies = currencies
        self.sourceCurrency = sourceCurrency
        self.destinationCurrency = destinationCurrency
        self.exchangeEntries = exchangeEntries
    }
    
    public func exchangeRate(from source: String?, to destination: String?) -> Decimal? {
        guard let source = source, let destination = destination else {
            return nil
        }
        return exchangeData.getRate(from: source, to: destination)
    }
}

public enum AsyncState {
    case ready
    case loading
    case success(ConverterState)
    case offline(ConverterState)
    case failure(Error)
    
    var isOffline: Bool {
        switch self {
        case .offline:
            return true
        default:
            return false
        }
    }
}

public class ConverterInteractor {
    typealias ExchangeDataResponse = (record: ExchangeDataRecord, isOffline: Bool)
    
    var timer: Timer?
    
    public var presenter: ConverterInteractorOutputProtocol?
    
    let exchangeService: CurrencyLayerServiceProtocol
    let fileService: FileServiceProtocol
    
    var exchangeData: ExchangeData?
    var currencies: [String:CurrencyData] = [:]
    
    var exchangeDataHistory = Persistent<ExchangeDataHistory>(key: "ExchangeDataHistory", defaultValue: .init(records: []))
    var latestExchangeRecordPersistent = Persistent<ExchangeDataRecord?>(key: "LatestExchangeRecord", defaultValue: nil)
    
    var sourcePersistent = Persistent<CurrencyData>(key: "SourceCurrency", defaultValue: .usd)
    var destinationPersistent = Persistent<CurrencyData>(key: "DestinationCurrency", defaultValue: .vnd)
    
    public init(exchangeService: CurrencyLayerServiceProtocol, fileService: FileServiceProtocol) {
        self.exchangeService = exchangeService
        self.fileService = fileService
    }
    
    private func fetchExchangeData() -> Promise<ExchangeDataResponse> {
        guard let latestRecord = self.latestExchangeRecordPersistent.value,
              latestRecord.timestamp > Date().timeIntervalSince1970 - 3600 else {
            
            return exchangeService.fetchExchangeData()
                .map{ exchangeData in
                    let newRecord = ExchangeDataRecord(
                        exchangeData: exchangeData,
                        timestamp: Date().timeIntervalSince1970
                    )
                    return ExchangeDataResponse(record: newRecord, isOffline: false)
                }
                .get{ exchangeDataResponse in
                    self.latestExchangeRecordPersistent.value = exchangeDataResponse.record
                }
                .recover{ error -> Promise<ExchangeDataResponse> in
                    guard let latestRecord = self.latestExchangeRecordPersistent.value else { return
                        Promise(error: error)
                    }
                    return .value(ExchangeDataResponse(record: latestRecord, isOffline: true))
                }
        }
        
        return .value(ExchangeDataResponse(record: latestRecord, isOffline: false))
    }
    
    private func startFetchingTimer() {
        timer = Timer(timeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self, let latestRecord = self.latestExchangeRecordPersistent.value,
                  latestRecord.timestamp < Date().timeIntervalSince1970 - 3600 else {
                return
            }
            firstly { () -> Promise<ExchangeDataResponse> in
                self.presenter?.onLiveQuotesFetched(state: .loading)
                return self.fetchExchangeData()
            }
            .done { exchangeDataResponse in
                self.handleExchangeData(exchangeDataResponse: exchangeDataResponse, currencies: self.currencies)
            }
            .catch { error in
                self.presenter?.onLiveQuotesFetched(state: .failure(error))
            }
        }
        timer?.fire()
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func handleExchangeData(exchangeDataResponse: ExchangeDataResponse, currencies: [String:CurrencyData]) {
        let availableRates = exchangeDataResponse.record.exchangeData.rates
        var availableCurrencies: [String:CurrencyData] = [:]
        currencies.forEach{ code, currencyData in
            guard availableRates[code] != nil else {
                return
            }
            availableCurrencies[code] = currencyData
        }
        self.currencies = availableCurrencies
        self.exchangeData = exchangeDataResponse.record.exchangeData
        
        let currentRecords: [ExchangeDataRecord] = self.exchangeDataHistory.value.records.enumerated().compactMap{ index, record in
            guard index < 9 else { return nil }
            return record
        }
        self.exchangeDataHistory.value = ExchangeDataHistory(records: currentRecords + [exchangeDataResponse.record])
        self.latestExchangeRecordPersistent.value = exchangeDataResponse.record
        
        let entries = self.exchangeDataHistory.value.getExchangeHistoryEntries(
            source: self.sourcePersistent.value,
            destination: self.destinationPersistent.value
        )
        
        let state = ConverterState(
            timestamp: exchangeDataResponse.record.timestamp,
            exchangeData: exchangeDataResponse.record.exchangeData,
            currencies: availableCurrencies,
            sourceCurrency: self.sourcePersistent.value,
            destinationCurrency: self.destinationPersistent.value,
            exchangeEntries: entries
        )
        if exchangeDataResponse.isOffline {
            self.presenter?.onLiveQuotesFetched(state: .offline(state))
        } else {
            self.presenter?.onLiveQuotesFetched(state: .success(state))
        }
    }
}

extension ConverterInteractor: ConverterInteractorProtocol {
    public func preloadData() {
        firstly { () -> Promise<(ExchangeDataResponse, [String:CurrencyData])> in
            presenter?.onLiveQuotesFetched(state: .loading)
            return when(fulfilled: fetchExchangeData(), fileService.readCurrencyFile())
        }
        .done { exchangeDataResponse, currencies in
            self.handleExchangeData(exchangeDataResponse: exchangeDataResponse, currencies: currencies)
            self.startFetchingTimer()
        }
        .catch { error in
            self.presenter?.onLiveQuotesFetched(state: .failure(error))
            self.startFetchingTimer()
        }
    }
    
    public func convert(inputText: String?, fromCurrency: String?, toCurrency: String?) {
        guard let fromCurrency = fromCurrency, let toCurrency = toCurrency else {
            return
        }
        
        let fromNumberFormatter = NumberFormatter.formatter(forCurrency: fromCurrency)
        let toNumberFormatter = NumberFormatter.formatter(forCurrency: toCurrency)
        
        guard let inputText = inputText?.replacingOccurrences(of: Locale.current.groupingSeparator ?? "", with: ""),
              let value = fromNumberFormatter.number(from: inputText)?.decimalValue,
              let rate = exchangeData?.getRate(from: fromCurrency, to: toCurrency) else {
            return
        }
        
        guard let toResult = toNumberFormatter.string(from: value * rate),
              let fromResult = fromNumberFormatter.string(from: value) else {
            return
        }
        
        presenter?.onConvertSuccess(fromResult: fromResult, toResult: toResult)
    }
    
    public func onSelectedCurrencyChanged(source: CurrencyData?, destination: CurrencyData?) {
        if let source = source {
            sourcePersistent.value = source
        }
        if let destination = destination {
            destinationPersistent.value = destination
        }
        let entries = self.exchangeDataHistory.value.getExchangeHistoryEntries(source: source, destination: destination)
        presenter?.onHistoryListUpdated(exchangeRateHistoryEntries: entries)
    }
}
