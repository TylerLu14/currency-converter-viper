//
//  ConverterContract.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

typealias ConverterPresenterDependencies = (
    interactor: ConverterInteractorProtocol,
    router: ConverterRouterProtocol
)

protocol ConverterViewProtocol: ViewProtocol {
    var presenter: ConverterPresenterProtocol? { get }
}

protocol ConverterPresenterInputs {
    var inputAmountChanged: PublishRelay<String?> { get }
    var convertButtonTrigger: PublishRelay<String> { get }
}

protocol ConverterPresenterOutputs {
    var result: Observable<String> { get }
}

protocol ConverterPresenterInterface {
    var inputs: ConverterPresenterInputs { get }
    var outputs: ConverterPresenterOutputs { get }
}

protocol ConverterPresenterProtocol: PresenterProtocol, ConverterPresenterInterface {
    var dependencies: ConverterPresenterDependencies { get }
}

protocol ConverterInteractorProtocol: InteractorProtocol {
    var convertTrigger: PublishSubject<ConvertModel> { get }
    var convertResult: Observable<String> { get }
}

protocol ConverterRouterProtocol: RouterProtocol {
    
}
