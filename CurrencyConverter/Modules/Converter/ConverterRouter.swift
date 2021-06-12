//
//  ConverterRouter.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit
import PanModal

class ConverterRouter {
    static func createModule(service: CurrencyLayerServiceProtocol) -> ConverterViewController {
        
        let view = ConverterViewController()
        
        let presenter: ConverterPresenterProtocol & ConverterInteractorOutputProtocol = ConverterPresenter()
        let interactor: ConverterInteractorProtocol = ConverterInteractor(service: service)
        let router: ConverterRouterProtocol = ConverterRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
}


extension ConverterRouter: ConverterRouterProtocol {
    func presentCurrencySelect(from: UIViewController, currencies: [String:CurrencyData], completion: ((CurrencyData) -> Void)?) {
        let viewController = CurrencySelectRouter.createModule(currencies: currencies, completion: completion)
        let navigationController = NavigationController(rootViewController: viewController)
        from.presentPanModal(navigationController)
    }
}
