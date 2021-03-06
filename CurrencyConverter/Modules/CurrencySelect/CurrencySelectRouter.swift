//
//  CurrencySelectRouter.swift
//  CurrencyCurrencySelect
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

class CurrencySelectRouter {
    static func createModule(currencies: [CurrencyModel], completion: ((CurrencyModel) -> Void)? = nil) -> CurrencySelectViewController {
        
        let view = CurrencySelectViewController()
        
        let presenter: CurrencySelectPresenterProtocol & CurrencySelectInteractorOutputProtocol = CurrencySelectPresenter(completion: completion)
        let interactor: CurrencySelectInteractorProtocol = CurrencySelectInteractor(currencyModels: currencies)
        let router: CurrencySelectRouterProtocol = CurrencySelectRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}


extension CurrencySelectRouter: CurrencySelectRouterProtocol {
    
}
