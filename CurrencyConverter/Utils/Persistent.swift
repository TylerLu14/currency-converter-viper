//
//  Persistent.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation

enum PersistentError: Error {
    case castFailed
    case decodeFailed(reason: String)
}

protocol Persistable {
    associatedtype PersistentValue
    static func decode(_ value: PersistentValue) throws -> Self
    func encode() throws -> PersistentValue
}

extension Persistable where Self: RawRepresentable {
    static func decode(_ value: RawValue) throws -> Self {
        guard let result = Self(rawValue: value) else {
            throw PersistentError.decodeFailed(reason: "Decode RawRepresentable value of type \(self) failed, invalid raw value: \(value)")
        }

        return result
    }

    func encode() throws -> RawValue {
        rawValue
    }
}

struct Persistent<T:Persistable> {
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
        try? UserDefaults.standard.store(value: value, forKey: key)
    }
}
