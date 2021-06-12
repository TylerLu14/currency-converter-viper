//
//  ConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

enum AsyncState {
    case ready
    case loading
    case success([String:CurrencyData])
    case failure(Error)
}

class ConverterPresenter: ConverterPresenterProtocol {
    var view: ConverterViewProtocol?
    var interactor: ConverterInteractorProtocol?
    var router: ConverterRouterProtocol?
    
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
    
    var selectedFromCurrency: CurrencyData? = nil
    var selectedToCurrency: CurrencyData? = nil
    
    var isButtonEnabled: Bool {
        return !fromText.isNilOrEmpty && selectedToCurrency != nil && selectedToCurrency != nil
    }
    
    func viewDidLoad() {
        refresh(state: state)
        interactor?.preloadData()
    }
    
    private func refresh(state: AsyncState) {
        switch state {
        case .ready, .loading:
            view?.updateConvertButton(text: "Loading...", isEnabled: false)
            view?.updateErrorLabel(text: nil)
        case .success(let currencies):
            if let fromCurrency = currencies["USD"] {
                self.selectedFromCurrency = fromCurrency
                view?.updateFromCurrency(with: fromCurrency)
            }
            
            if let toCurrency = currencies["VND"] {
                self.selectedToCurrency = toCurrency
                view?.updateToCurrency(with: toCurrency)
            }
            
            view?.updateConvertButton(text: "Convert", isEnabled: isButtonEnabled)
            view?.updateErrorLabel(text: nil)
        case .failure(let error):
            view?.updateConvertButton(text: "Refresh", isEnabled: true)
            view?.updateErrorLabel(text: "Failed to load exchange data.\nReason: \(error.localizedDescription)")
            
            let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            view?.present(alert, animated: true, completion: nil)
        }
    }
    
    func fromTextChanged(text: String?) {
        self.fromText = text
    }
    
    func toTextChanged(text: String?) {
        self.toText = text
    }
    
    func convertButtonTapped() {
        switch state {
        case .success:
            guard let inputText = fromText,
                let fromCurrency = selectedFromCurrency?.code,
                let toCurrency = selectedToCurrency?.code else {
                return
            }
            interactor?.convert(inputText: inputText, fromCurrency: fromCurrency, toCurrency: toCurrency)
        case .failure:
            interactor?.preloadData()
        default:
            break
        }
    }
    
    func showFromSelectCurrency(viewController: UIViewController) {
        router?.presentCurrencySelect(from: viewController, currencies: interactor?.currencies ?? [:]) { [weak self] currency in
            self?.selectedFromCurrency = currency
            self?.view?.updateFromCurrency(with: currency)
        }
    }
    
    func showToSelectCurrency(viewController: UIViewController) {
        router?.presentCurrencySelect(from: viewController, currencies: interactor?.currencies ?? [:]) { [weak self]  currency in
            self?.selectedToCurrency = currency
            self?.view?.updateToCurrency(with: currency)
        }
    }
    
    func swapSelectedCurrency() {
        swap(&selectedFromCurrency, &selectedToCurrency)
        swap(&fromText, &toText)
        
        guard let fromCurrency = self.selectedFromCurrency, let toCurrency = self.selectedToCurrency else {
            return
        }
        view?.updateFromCurrency(with: fromCurrency)
        view?.updateToCurrency(with: toCurrency)
        
        view?.updateResult(fromText: fromText, toText: toText)
    }
}

extension ConverterPresenter: ConverterInteractorOutputProtocol {
    func onLiveQuotesFetched(state: AsyncState) {
        self.state = state
    }
    
    func onConvertSuccess(fromResult: String, toResult: String) {
        fromText = fromResult
        toText = toResult
        view?.updateResult(fromText: fromResult, toText: toResult)
    }
    
    func onConvertError(error: Error) {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        view?.present(alert, animated: true, completion: nil)
    }
}


