//
//  CurrencySelectContract.swift
//  CurrencyCurrencySelect
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

// Presenter -> View
protocol CurrencySelectViewProtocol: AnyObject {
    func reloadData()
    func setInitialStyle(style: CollectionViewStyle)
    func reloadStyle(style: CollectionViewStyle)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func updateStyleButton(style: CollectionViewStyle)
}

//View -> Presenter
protocol CurrencySelectPresenterProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    var interactor: CurrencySelectInteractorProtocol? { get set }
    var view: CurrencySelectViewProtocol? { get set }
    var router: CurrencySelectRouterProtocol? { get set }
    
    func viewDidLoad()
    func onStyleButtonTapped()
}

//Presenter -> Interactor
protocol CurrencySelectInteractorProtocol: AnyObject {
    var presenter: CurrencySelectInteractorOutputProtocol? { get set }
    
    func loadCurrencies()
    func loadViewStyle()
    func saveViewStyle(style: CollectionViewStyle)
}

//Interactor -> Presenter
protocol CurrencySelectInteractorOutputProtocol: AnyObject {
    func onCurrenciesUpdated(currencyModels: [CurrencyModel])
    func onStyleRestore(style: CollectionViewStyle)
}

//Presenter -> Wireframe
protocol CurrencySelectRouterProtocol: AnyObject {
    
}
