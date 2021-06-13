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
    static func createModule(exchangeService: CurrencyLayerServiceProtocol, fileService: FileServiceProtocol) -> ConverterViewController {
        
        let view = ConverterViewController()
        
        let presenter: ConverterPresenterProtocol & ConverterInteractorOutputProtocol = ConverterPresenter()
        let interactor: ConverterInteractorProtocol = ConverterInteractor(exchangeService: exchangeService, fileService: fileService)
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
    func presentCurrencySelect(from: UIViewController, currencyModels: [CurrencyModel], completion: ((CurrencyModel) -> Void)?) {
        let viewController = CurrencySelectRouter.createModule(currencies: currencyModels)
        let navigationController = NavigationController(rootViewController: viewController)
        from.presentPanModal(navigationController)
    }
}
