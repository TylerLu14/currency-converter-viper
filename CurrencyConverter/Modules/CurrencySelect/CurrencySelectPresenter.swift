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
    var dataSource: [[CurrencyModel]] = []
    
    var selectCurrencyCompletion: ((CurrencyModel) -> Void)? = nil
    
    init(completion: ((CurrencyModel) -> Void)?) {
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
    func onCurrenciesUpdated(currencyModels: [CurrencyModel]) {
        dataSource = [currencyModels.sorted(by: { $0.data.code < $1.data.code })]
        view?.reloadData()
    }
    
    func onStyleRestore(style: CollectionViewStyle) {
        self.viewStyle = style
        view?.updateStyleButton(style: style)
        view?.setInitialStyle(style: style)
    }
}

extension CurrencySelectPresenter: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return collectionViewLayout.collectionViewContentSize
        }
        
        guard case .list = self.viewStyle else {
            return layout.itemSize
        }
        
        let currencyModel = dataSource[indexPath.section][indexPath.row]
        if currencyModel.exchangeRateText != nil {
            return CGSize(width: layout.itemSize.width, height: layout.itemSize.height + 16)
        } else {
            return layout.itemSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CurrencyCell.self)
        let currencyModel = dataSource[indexPath.section][indexPath.row]
        cell.updateCell(currencyModel: currencyModel, style: viewStyle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currency = dataSource[indexPath.section][indexPath.row]
        view?.dismiss(animated: true) { [weak self] in
            self?.selectCurrencyCompletion?(currency)
        }
    }
}
