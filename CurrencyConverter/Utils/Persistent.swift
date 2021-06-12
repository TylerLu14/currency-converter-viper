//
//  Persistent.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import ObjectMapper

enum PersistentError: Error {
    case castFailed
    case decodeFailed(reason: String)
}

protocol Persistable {
    func store(key: String)
    static func get(key: String) -> Self?
}

extension Persistable {
    func store(key: String) {
        UserDefaults.standard.store(value: self, forKey: key)
    }
    
    static func get(key: String) -> Self? {
        UserDefaults.standard.get(forKey: key)
    }
}

extension Persistable where Self: RawRepresentable {
    func store(key: String) {
        UserDefaults.standard.store(value: self.rawValue, forKey: key)
    }
    
    static func get(key: String) -> Self? {
        guard let rawValue: RawValue = UserDefaults.standard.get(forKey: key) else {
            return nil
        }
        return Self(rawValue: rawValue)
    }
}

extension Persistable where Self: Mappable {
    func store(key: String) {
        UserDefaults.standard.store(object: self, forKey: key)
    }
    
    static func get(key: String) -> Self? {
        UserDefaults.standard.get(forKey: key)
    }
}

extension Optional: Persistable where Wrapped: Persistable {
    func store(key: String) {
        switch self {
        case .none:
            UserDefaults.standard.removeObject(forKey: key)
        case .some(let value):
            value.store(key: key)
        }
    }
    
    static func get(key: String) -> Optional<Wrapped>? {
        Wrapped.get(key: key)
    }
}

extension Double: Persistable { }
extension Int: Persistable { }
extension Bool: Persistable { }
extension Date: Persistable { }

struct Persistent<T: Persistable> {
    var key: String
    var value: T {
        didSet {
            syncValue()
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        
        if let currentValue = T.get(key: key) {
            self.value = currentValue
        } else {
            self.value = defaultValue
            self.value.store(key: key)
        }
    }
    
    private func syncValue() {
        value.store(key: key)
    }
}
