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
        
    }
    
    struct Outputs: ConverterPresenterOutputs {
        private let disposeBag = DisposeBag()
        
        init(inputs: ConverterPresenterInputs, interactor: ConverterInteractorProtocol) {
            
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


