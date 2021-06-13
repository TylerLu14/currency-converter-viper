//
//  ConverterContract.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

// Presenter -> View
public protocol ConverterViewProtocol: AnyObject {
    var presenter: ConverterPresenterProtocol? { get set }
    
    func updateOfflineLabel(isOffline: Bool)
    func updateTimeStampLabel(text: String?)
    func updateErrorLabel(text: String?)
    func updateConvertButton(text: String?, isEnabled: Bool)
    func updateResult(fromText: String?, toText: String?)
    func updateSourceCurrency(with currency: CurrencyData?)
    func updateDestinationCurrency(with currency: CurrencyData?)
    func updateExchangeRates(with entries: [String])
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

//View -> Presenter
public protocol ConverterPresenterProtocol: AnyObject {
    var interactor: ConverterInteractorProtocol? { get set }
    var view: ConverterViewProtocol? { get set }
    var router: ConverterRouterProtocol? { get set }

    func viewDidLoad()
    func sourceTextChanged(text: String?)
    func convertButtonTapped()
    
    func showSourceSelectCurrency(viewController: UIViewController, completion: ((CurrencyModel)->Void)?)
    func showDestinationSelectCurrency(viewController: UIViewController, completion: ((CurrencyModel)->Void)?)
    
    func selectCurrency(source: CurrencyData)
    func selectCurrency(destination: CurrencyData)
    
    func swapSelectedCurrency()
}

//Presenter -> Interactor
public protocol ConverterInteractorProtocol: AnyObject {
    var presenter: ConverterInteractorOutputProtocol? { get set }
    
    func preloadData()
    func convert(inputText: String?, fromCurrency: String?, toCurrency: String?)
    func onSelectedCurrencyChanged(source: CurrencyData?, destination: CurrencyData?)
}

//Interactor -> Presenter
public protocol ConverterInteractorOutputProtocol: AnyObject {
    func onLiveQuotesFetched(state: AsyncState)
    
    func onConvertSuccess(fromResult: String, toResult: String)
    func onConvertError(error: Error)
    func onHistoryListUpdated(exchangeRateHistoryEntries: [ExchangeRateHistoryEntry])
}

//Presenter -> Wireframe
public protocol ConverterRouterProtocol: AnyObject {
    func presentCurrencySelect(from: UIViewController, currencyModels: [CurrencyModel], completion: ((CurrencyModel) -> Void)?)
}
