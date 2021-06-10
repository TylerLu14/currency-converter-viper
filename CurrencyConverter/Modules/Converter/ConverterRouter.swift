//
//  ConverterRouter.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

struct ConverterRouterInput {
    func view(service: CurrencyLayerServiceProtocol, source: String) -> ConverterViewController {
        let view = ConverterViewController()
        let interactor = ConverterInteractor(service: service, source: source)
        let dependencies = ConverterPresenterDependencies(interactor: interactor, router: ConverterRouter(view))
        let presenter = ConverterPresenter(dependencies: dependencies)
        view.presenter = presenter
        return view
    }
}


final class ConverterRouter: ConverterRouterProtocol {
    private(set) weak var view: ViewProtocol!
    
    init(_ view: ConverterViewProtocol) {
        self.view = view
    }
}
