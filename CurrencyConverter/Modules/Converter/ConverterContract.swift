//
//  ConverterContract.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

// Presenter -> View
protocol ConverterViewProtocol: AnyObject {
    func updateErrorLabel(text: String?)
    func updateConvertButton(text: String?, isEnabled: Bool)
    func updateResult(fromText: String?, toText: String?)
    func updateFromCurrency(with currency: CurrencyData)
    func updateToCurrency(with currency: CurrencyData)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

//View -> Presenter
protocol ConverterPresenterProtocol: AnyObject {
    var interactor: ConverterInteractorProtocol? { get set }
    var view: ConverterViewProtocol? { get set }
    var router: ConverterRouterProtocol? { get set }

    func viewDidLoad()
    func fromTextChanged(text: String?)
    func convertButtonTapped()
    func showFromSelectCurrency(viewController: UIViewController)
    func showToSelectCurrency(viewController: UIViewController)
    func swapSelectedCurrency()
}

//Presenter -> Interactor
protocol ConverterInteractorProtocol: AnyObject {
    var presenter: ConverterInteractorOutputProtocol? { get set }
    
    var currencies: [String:CurrencyData] { get }
    
    func preloadData()
    func convert(inputText: String?, fromCurrency: String?, toCurrency: String?)
}

//Interactor -> Presenter
protocol ConverterInteractorOutputProtocol: AnyObject {
    func onLiveQuotesFetched(state: AsyncState)
    
    func onConvertSuccess(fromResult: String, toResult: String)
    func onConvertError(error: Error)
}

//Presenter -> Wireframe
protocol ConverterRouterProtocol: AnyObject {
    func presentCurrencySelect(from: UIViewController, currencies: [String:CurrencyData], completion: ((CurrencyData) -> Void)?)
}
