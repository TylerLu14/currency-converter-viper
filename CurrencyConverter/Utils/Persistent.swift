//
//  Persistent.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation

protocol Persistable {
    
}

struct Persistent<T>: Persistable {
    var key: String
    var value: T {
        didSet {
            syncValue()
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        
        if let currentValue: T = UserDefaults.standard.get(forKey: key) {
            self.value = currentValue
        } else {
            self.value = defaultValue
            syncValue()
        }
    }
    
    private func syncValue() {
        UserDefaults.standard.store(value: value, forKey: key)
    }
}
