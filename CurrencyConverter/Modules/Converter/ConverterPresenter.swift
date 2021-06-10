//
//  ConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ConverterPresenter: ConverterPresenterProtocol {
    struct Inputs: ConverterPresenterInputs {
        let inputAmountChanged = PublishRelay<String?>()
        let convertButtonTrigger = PublishRelay<String>()
    }
    
    struct Outputs: ConverterPresenterOutputs {
        private let disposeBag = DisposeBag()
        
        let result: Observable<String>
        
        init(inputs: ConverterPresenterInputs, interactor: ConverterInteractorProtocol) {
            
            inputs.convertButtonTrigger
                .map{ inputText in
                    ConvertModel(value: Double(inputText) ?? 0, fromCurrency: "AUD", toCurrency: "VND")
                }
                .bind(to: interactor.convertTrigger)
                .disposed(by: disposeBag)
            
            result = interactor.result
        }
    }
    
    let dependencies: ConverterPresenterDependencies
    
    var inputs: ConverterPresenterInputs
    var outputs: ConverterPresenterOutputs

    init(dependencies: ConverterPresenterDependencies) {
        self.dependencies = dependencies
        self.inputs = Inputs()
        self.outputs = Outputs(inputs: inputs, interactor: dependencies.interactor)
    }

}


