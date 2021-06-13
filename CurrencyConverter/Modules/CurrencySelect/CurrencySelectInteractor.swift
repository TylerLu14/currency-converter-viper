//
//  CurrencySelectInteractor.swift
//  CurrencyCurrencySelect
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import ObjectMapper
import PromiseKit

final class CurrencySelectInteractor: CurrencySelectInteractorProtocol {
    var presenter: CurrencySelectInteractorOutputProtocol?
    var currencyModels: [CurrencyModel]
    
    var stylePersistent = Persistent<CollectionViewStyle>(key: "CurrencyListStyle", defaultValue: .list)
    
    init(currencyModels: [CurrencyModel]) {
        self.currencyModels = currencyModels
    }
    
    func loadCurrencies() {
        presenter?.onCurrenciesUpdated(currencyModels: currencyModels)
    }
    
    func loadViewStyle() {
        presenter?.onStyleRestore(style: stylePersistent.value)
    }
    
    func saveViewStyle(style: CollectionViewStyle) {
        stylePersistent.value = style
    }
}
