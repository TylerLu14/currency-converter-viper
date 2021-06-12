//
//  StringExtensions.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/12/21.
//

import Foundation

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
