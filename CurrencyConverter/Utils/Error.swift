//
//  Error.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/12/21.
//

import Foundation


public enum ServiceError: Error {
    case cannotParseData
    case currencyNotFound
}

public enum FileError: Error {
    case fileNotFound
    case cannotReadJsonFile
    case cannotParseJson
}
