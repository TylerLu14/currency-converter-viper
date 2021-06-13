//
//  DateExtensions.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/13/21.
//

import Foundation

extension DateFormatter {
    static var standard: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
    
    static var short: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }
}

extension Date {
    init(milliseconds: Int64) {
        let seconds = TimeInterval(milliseconds) / 1000
        self.init(timeIntervalSince1970: seconds)
    }
}
