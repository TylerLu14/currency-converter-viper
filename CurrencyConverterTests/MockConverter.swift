//
//  MockConverter.swift
//  CurrencyConverterTests
//
//  Created by Lữ on 6/13/21.
//

import Foundation
import CurrencyConverter
import PromiseKit

class MockView: ConverterViewProtocol {
    var presenter: ConverterPresenterProtocol? = nil
    var isOffline: Bool? = nil
    var timestampText: String? = nil
    var error: String? = nil
    
    var buttonText: String? = nil
    var buttonEnabled: Bool? = nil
    
    var sourceText: String? = nil
    var destinationText: String? = nil
    
    var sourceCurrency: CurrencyData?
    var destinationCurrency: CurrencyData?
    
    var exchangeRatesEntries: [String] = []
    
    var alertPresented: Bool = false
    
    func updateOfflineLabel(isOffline: Bool) {
        self.isOffline = isOffline
    }
    
    func updateTimeStampLabel(text: String?) {
        self.timestampText = text
    }
    
    func updateErrorLabel(text: String?) {
        self.error = text
    }
    
    func updateConvertButton(text: String?, isEnabled: Bool) {
        self.buttonText = text
        self.buttonEnabled = isEnabled
    }
    
    func updateResult(fromText: String?, toText: String?) {
        self.sourceText = fromText
        self.destinationText = toText
    }
    
    func updateSourceCurrency(with currency: CurrencyData?) {
        self.sourceCurrency = currency
    }
    
    func updateDestinationCurrency(with currency: CurrencyData?) {
        self.destinationCurrency = currency
    }
    
    func updateExchangeRates(with entries: [String]) {
        self.exchangeRatesEntries = entries
    }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.alertPresented = true
    }
}

class MockInteractor: ConverterInteractorProtocol {
    var inputText: String?
    var sourceCurrency: String?
    var destinationCurrency: String?
    
    var presenter: ConverterInteractorOutputProtocol? = nil
    
    var currencies: [String : CurrencyData] = [:]
    
    var exchangeService: CurrencyLayerServiceProtocol
    var fileService: FileServiceProtocol
    
    init(exchangeService: CurrencyLayerServiceProtocol, fileService: FileServiceProtocol) {
        self.exchangeService = exchangeService
        self.fileService = fileService
    }
    
    func preloadData() {
        when(fulfilled: exchangeService.fetchExchangeData(source: "USD"), fileService.readCurrencyFile())
            .done{ exchangeData, currencies in
                let state = ConverterState(
                    timestamp: 1623576396,
                    exchangeData: exchangeData,
                    currencies: currencies,
                    sourceCurrency: CurrencyData(JSON: ["code":"USD"]),
                    destinationCurrency: CurrencyData(JSON: ["code":"EUR"]),
                    exchangeEntries: [])
                
                self.presenter?.onLiveQuotesFetched(state: .success(state))
            }
            .catch{ error in
                self.presenter?.onLiveQuotesFetched(state: .failure(error))
            }
    }
    
    func convert(inputText: String?, fromCurrency: String?, toCurrency: String?) {
        self.inputText = inputText
        self.sourceCurrency = fromCurrency
        self.destinationCurrency = toCurrency
    }
    
    func onSelectedCurrencyChanged(source: CurrencyData?, destination: CurrencyData?) {
        
    }
}

class MockPresenter: ConverterPresenterProtocol {
    var sourceText: String?
    var destinationText: String?
    
    var sourceCurrency: CurrencyData?
    var destinationCurrency: CurrencyData?
    
    var interactor: ConverterInteractorProtocol?
    
    var view: ConverterViewProtocol?
    
    var router: ConverterRouterProtocol?
    
    func viewDidLoad() {
        interactor?.preloadData()
    }
    
    func sourceTextChanged(text: String?) {
        self.sourceText = text
    }
    
    func convertButtonTapped() {
        interactor?.convert(inputText: sourceText, fromCurrency: sourceCurrency?.code, toCurrency: destinationCurrency?.code)
    }
    
    func showSourceSelectCurrency(viewController: UIViewController, completion: ((CurrencyModel) -> Void)?) {
        router?.presentCurrencySelect(from: viewController, currencyModels: [], completion: completion)
    }
    
    func showDestinationSelectCurrency(viewController: UIViewController, completion: ((CurrencyModel) -> Void)?) {
        router?.presentCurrencySelect(from: viewController, currencyModels: [], completion: completion)
    }
    
    func selectCurrency(source: CurrencyData) {
        self.sourceCurrency = source
    }
    
    func selectCurrency(destination: CurrencyData) {
        self.destinationCurrency = destination
    }
    
    func swapSelectedCurrency() {
        swap(&sourceText, &destinationText)
    }
    
    
}

extension MockPresenter: ConverterInteractorOutputProtocol {
    func onLiveQuotesFetched(state: AsyncState) {
        
    }
    
    func onConvertSuccess(fromResult: String, toResult: String) {
        self.sourceText = fromResult
        self.destinationText = toResult
        view?.updateResult(fromText: fromResult, toText: toResult)
    }
    
    func onConvertError(error: Error) {
        
    }
    
    func onHistoryListUpdated(exchangeRateHistoryEntries: [ExchangeRateHistoryEntry]) {
        
    }
    
    
}

class MockRouter: ConverterRouterProtocol {
    func presentCurrencySelect(from: UIViewController, currencyModels: [CurrencyModel], completion: ((CurrencyModel) -> Void)?) {
        
    }
}

struct MockExchangeService: CurrencyLayerServiceProtocol {
    struct Data {
        static var exchangeData: [String:Any] = [
            "success": true,
            "terms": "https://currencylayer.com/terms",
            "privacy": "https://currencylayer.com/privacy",
            "timestamp": 1623550443,
            "source": "USD",
            "quotes": [
                "USDVND": 23000.00,
                "USDAUD": 1.30,
                "USDCAD": 1.215415,
                "USDEUR": 0.825835,
                "USDGBP": 0.708843,
            ]
        ]
    }
    
    func fetchExchangeData(source: String) -> Promise<ExchangeData> {
        return .value(ExchangeData(JSON: Data.exchangeData)!)
    }
}

struct MockFileService: FileServiceProtocol {
    
    struct Data {
        static var currencies: [String:[String:Any]] = [
            "VND": [
                "symbol": "₫",
                "name": "Vietnamese Dong",
                "symbol_native": "₫",
                "decimal_digits": 0,
                "rounding": 0,
                "code": "VND",
                "name_plural": "Vietnamese dong"
            ],
            "AUD": [
                "symbol": "AU$",
                "name": "Australian Dollar",
                "symbol_native": "$",
                "decimal_digits": 2,
                "rounding": 0,
                "code": "AUD",
                "name_plural": "Australian dollars"
            ],
            "CAD": [
                "symbol": "CA$",
                "name": "Canadian Dollar",
                "symbol_native": "$",
                "decimal_digits": 2,
                "rounding": 0,
                "code": "CAD",
                "name_plural": "Canadian dollars"
            ],
            "GBP": [
                "symbol": "£",
                "name": "British Pound Sterling",
                "symbol_native": "£",
                "decimal_digits": 2,
                "rounding": 0,
                "code": "GBP",
                "name_plural": "British pounds sterling"
            ],
            "USD": [
                "symbol": "$",
                "name": "US Dollar",
                "symbol_native": "$",
                "decimal_digits": 2,
                "rounding": 0,
                "code": "USD",
                "name_plural": "US dollars"
            ]
        ]
    }
    
    func readCurrencyFile() -> Promise<[String : CurrencyData]> {
        var currencyDataDict: [String:CurrencyData] = [:]
        Data.currencies.forEach{ code, currencyJson in
            currencyDataDict[code] = CurrencyData(JSON: currencyJson)
        }
        return .value(currencyDataDict)
    }
}
