//
//  ConverterContract.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

typealias ConverterPresenterDependencies = (
    interactor: ConverterInteractorProtocol,
    router: ConverterRouterProtocol
)

protocol ConverterViewProtocol: ViewProtocol {
    var presenter: ConverterPresenterProtocol? { get }
}

protocol ConverterPresenterInputs {
}

protocol ConverterPresenterOutputs {
}

protocol ConverterPresenterInterface {
    var inputs: ConverterPresenterInputs { get }
    var outputs: ConverterPresenterOutputs { get }
}

protocol ConverterPresenterProtocol: PresenterProtocol, ConverterPresenterInterface {
    var dependencies: ConverterPresenterDependencies { get }
}

protocol ConverterInteractorProtocol: InteractorProtocol {
    
}

protocol ConverterRouterProtocol: RouterProtocol {
    
}
