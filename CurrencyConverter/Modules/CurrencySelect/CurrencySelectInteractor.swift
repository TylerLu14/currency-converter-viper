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
    var currencies: [String:CurrencyData]
    
    var stylePersistent = Persistent<CollectionViewStyle>(key: "CurrencyListStyle", defaultValue: .list)
    
    init(currencies: [String:CurrencyData]) {
        self.currencies = currencies
    }
    
    func loadCurrencies() {
        presenter?.onCurrenciesUpdated(currencies: currencies)
    }
    
    func loadViewStyle() {
        presenter?.onStyleRestore(style: stylePersistent.value)
    }
    
    func saveViewStyle(style: CollectionViewStyle) {
        stylePersistent.value = style
    }
}
