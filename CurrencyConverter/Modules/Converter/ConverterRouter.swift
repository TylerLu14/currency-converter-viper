//
//  ConverterRouter.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

struct ConverterRouterInput {
    func view() -> ConverterViewController {
        let view = ConverterViewController()
        let interactor = ConverterInteractor()
        let dependencies = ConverterPresenterDependencies(interactor: interactor, router: ConverterRouter(view))
        let presenter = ConverterPresenter(dependencies: dependencies)
        view.presenter = presenter
        return view
    }

    func push(from: ViewProtocol) {
        from.push(view(), animated: true)
    }

    func present(from: ViewProtocol) {
        let nav = UINavigationController(rootViewController: view())
        from.present(nav, animated: true)
    }
}


final class ConverterRouter: ConverterRouterProtocol {
    private(set) weak var view: ViewProtocol!
    
    init(_ view: ConverterViewProtocol) {
        self.view = view
    }
}
