//
//  FileService.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/13/21.
//

import Foundation
import PromiseKit

public protocol FileServiceProtocol {
    func readCurrencyFile() -> Promise<[String:CurrencyData]>
}

struct FileService: FileServiceProtocol {
    static let shared = FileService()
    
    public func readCurrencyFile() -> Promise<[String:CurrencyData]> {
        Promise { resolver in
            do {
                guard let url = R.file.currenciesJson() else {
                    resolver.reject(FileError.fileNotFound)
                    return
                }
                guard let jsonData = try String(contentsOf: url).data(using: .utf8) else {
                    resolver.reject(FileError.cannotReadJsonFile)
                    return
                }
                
                let jsonRaw = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                
                guard let json = jsonRaw as? [String:[String:Any]] else {
                    resolver.reject(FileError.cannotParseJson)
                    return
                }
                var currencyDataDict: [String:CurrencyData] = [:]
                json.forEach{ code, currencyJson in
                    currencyDataDict[code] = CurrencyData(JSON: currencyJson)
                }
                resolver.fulfill(currencyDataDict)
            } catch {
                resolver.reject(error)
            }
        }
    }
}
