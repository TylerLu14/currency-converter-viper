//
//  CurrencySelectPresenter.swift
//  CurrencyCurrencySelect
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import UIKit

enum CollectionViewStyle: String, Persistable {
    case list = "list"
    case grid = "grid"
}

class CurrencySelectPresenter: NSObject, CurrencySelectPresenterProtocol {
    var view: CurrencySelectViewProtocol?
    var interactor: CurrencySelectInteractorProtocol?
    var router: CurrencySelectRouterProtocol?
    
    var viewStyle: CollectionViewStyle = .list
    var dataSource: [[CurrencyData]] = []
    
    var selectCurrencyCompletion: ((CurrencyData) -> Void)? = nil
    
    init(completion: ((CurrencyData) -> Void)?) {
        self.selectCurrencyCompletion = completion
    }
    
    func viewDidLoad() {
        interactor?.loadViewStyle()
        interactor?.loadCurrencies()
    }
    
    func onStyleButtonTapped() {
        switch viewStyle {
        case .grid: viewStyle = .list
        case .list: viewStyle = .grid
        }
        interactor?.saveViewStyle(style: viewStyle)
        view?.updateStyleButton(style: viewStyle)
        view?.reloadStyle(style: viewStyle)
    }
}

extension CurrencySelectPresenter: CurrencySelectInteractorOutputProtocol {
    func onCurrenciesUpdated(currencies: [String:CurrencyData]) {
        let sortedCurrencies = currencies.map{ code, currencyData in currencyData }
            .sorted{ $0.code < $1.code }
        
        dataSource = [sortedCurrencies]
        view?.reloadData()
    }
    
    func onStyleRestore(style: CollectionViewStyle) {
        self.viewStyle = style
        view?.updateStyleButton(style: style)
        view?.setInitialStyle(style: style)
    }
}

extension CurrencySelectPresenter: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CurrencyCell.self)
        let currencyData = dataSource[indexPath.section][indexPath.row]
        cell.updateCell(currencyData: currencyData, style: viewStyle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currency = dataSource[indexPath.section][indexPath.row]
        view?.dismiss(animated: true) { [weak self] in
            self?.selectCurrencyCompletion?(currency)
        }
    }
}
