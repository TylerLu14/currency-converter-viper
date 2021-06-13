//
//  ConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

public class ConverterPresenter: ConverterPresenterProtocol {
    public var view: ConverterViewProtocol?
    public var interactor: ConverterInteractorProtocol?
    public var router: ConverterRouterProtocol?
    
    var state: AsyncState = .ready {
        didSet {
            refresh(state: state)
        }
    }
    
    var fromText: String? {
        didSet {
            switch state {
            case .success:
                view?.updateConvertButton(text: "Convert", isEnabled: isButtonEnabled)
            default:
                break
            }
        }
    }
    var toText: String?
    
    var selectedSourceCurrency: CurrencyData? = nil
    var selectedDestinationCurrency: CurrencyData? = nil
    
    var isButtonEnabled: Bool {
        return !fromText.isNilOrEmpty && fromText.isDecimal && selectedDestinationCurrency != nil && selectedDestinationCurrency != nil
    }
    
    public func viewDidLoad() {
        refresh(state: state)
        interactor?.preloadData()
    }
    
    public init() {
        
    }
    
    private func refresh(state: AsyncState) {
        switch state {
        case .ready, .loading:
            view?.updateConvertButton(text: "Loading...", isEnabled: false)
            view?.updateErrorLabel(text: nil)
        case .success(let converterState), .offline(let converterState):
            self.selectedSourceCurrency = converterState.sourceCurrency
            self.selectedDestinationCurrency = converterState.destinationCurrency
            view?.updateExchangeRates(with: converterState.exchangeEntries.map{ $0.entryDisplay })
            view?.updateSourceCurrency(with: converterState.sourceCurrency)
            view?.updateDestinationCurrency(with: converterState.destinationCurrency)
            view?.updateTimeStampLabel(text: converterState.timestampDisplay)
            view?.updateConvertButton(text: "Convert", isEnabled: isButtonEnabled)
            view?.updateErrorLabel(text: nil)
        case .failure(let error):
            view?.updateConvertButton(text: "Refresh", isEnabled: true)
            view?.updateErrorLabel(text: "Failed to load exchange data.\nReason: \(error.localizedDescription)")
            
            let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            view?.present(alert, animated: true, completion: nil)
        }
        
        view?.updateOfflineLabel(isOffline: state.isOffline)
    }
    
    public func sourceTextChanged(text: String?) {
        self.fromText = text
    }
    
    public func toTextChanged(text: String?) {
        self.toText = text
    }
    
    public func convertButtonTapped() {
        switch state {
        case .success:
            guard let inputText = fromText,
                let fromCurrency = selectedSourceCurrency?.code,
                let toCurrency = selectedDestinationCurrency?.code else {
                return
            }
            interactor?.convert(inputText: inputText, fromCurrency: fromCurrency, toCurrency: toCurrency)
        case .failure:
            interactor?.preloadData()
        default:
            break
        }
    }
    
    public func showSourceSelectCurrency(viewController: UIViewController, completion: ((CurrencyModel) -> Void)?) {
        switch state {
        case .success(let converterState):
            let currencyModels = converterState.currencies.map{ code, data in
                CurrencyModel(
                    currencyData: data,
                    sourceCode: nil,
                    exchangeRate: nil
                )
            }
            router?.presentCurrencySelect(from: viewController, currencyModels: currencyModels, completion: completion)
        default:
            break
        }
    }
    
    public func showDestinationSelectCurrency(viewController: UIViewController, completion: ((CurrencyModel) -> Void)?) {
        switch state {
        case .success(let converterState):
            let currencyModels = converterState.currencies.map{ code, data in
                CurrencyModel(
                    currencyData: data,
                    sourceCode: selectedSourceCurrency?.code,
                    exchangeRate: converterState.exchangeRate(from: selectedSourceCurrency?.code, to: code)
                )
            }
            router?.presentCurrencySelect(from: viewController, currencyModels: currencyModels, completion: completion)
        default:
            break
        }
    }
    
    public func swapSelectedCurrency() {
        swap(&selectedSourceCurrency, &selectedDestinationCurrency)
        swap(&fromText, &toText)
        
        guard let source = self.selectedSourceCurrency, let destination = self.selectedDestinationCurrency else {
            return
        }
        interactor?.onSelectedCurrencyChanged(source: source, destination: destination)
        
        view?.updateSourceCurrency(with: source)
        view?.updateDestinationCurrency(with: destination)
        
        view?.updateResult(fromText: fromText, toText: toText)
    }
    
    public func selectCurrency(source: CurrencyData) {
        selectedSourceCurrency = source
        interactor?.onSelectedCurrencyChanged(
            source: source,
            destination: self.selectedDestinationCurrency
        )
        view?.updateSourceCurrency(with: source)
    }
    
    public func selectCurrency(destination: CurrencyData) {
        selectedDestinationCurrency = destination
        interactor?.onSelectedCurrencyChanged(
            source: self.selectedSourceCurrency,
            destination: destination
        )
        view?.updateDestinationCurrency(with: destination)
    }
}

extension ConverterPresenter: ConverterInteractorOutputProtocol {
    public func onHistoryListUpdated(exchangeRateHistoryEntries: [ExchangeRateHistoryEntry]) {
        view?.updateExchangeRates(with: exchangeRateHistoryEntries.map{ $0.entryDisplay })
    }
    
    public func onLiveQuotesFetched(state: AsyncState) {
        self.state = state
    }
    
    public func onConvertSuccess(fromResult: String, toResult: String) {
        fromText = fromResult
        toText = toResult
        view?.updateResult(fromText: fromResult, toText: toResult)
    }
    
    public func onConvertError(error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        view?.present(alert, animated: true, completion: nil)
    }
}


