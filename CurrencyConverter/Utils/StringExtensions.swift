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
    
    var isDecimal: Bool {
        return self?.isDecimal ?? true
    }
}

extension String {
    var isDecimal: Bool {
        guard !self.isEmpty else {
            return true
        }

        guard matches(regex: "^([0-9]*)(\\\(Locale.current.decimalSeparator ?? ".")[0-9]{0,\(20)})?$") else {
            return false
        }

        guard Decimal(string: self, locale: .current) != nil else {
            return false
        }

        return true
    }
    
    public func matches(regex: String) -> Bool {
        range(of: regex, options: .regularExpression) != nil
    }
}
