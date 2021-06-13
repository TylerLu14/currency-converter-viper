//
//  UserDefaultsExtensions.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import ObjectMapper

extension UserDefaults {
    func store<T: Any>(value: T, forKey key: String) {
        self.set(value, forKey: key)
        self.synchronize()
    }

    func get<T: Any>(forKey key: String) -> T? {
        self.object(forKey: key) as? T
    }
}

extension UserDefaults {
    func store<T: Mappable>(object: T?, forKey key: String) {
        if let object = object {
            let json = Mapper<T>().toJSON(object)
            self.set(json, forKey: key)
            self.synchronize()
        }
    }

    func get<T: Mappable>(forKey key: String) -> T? {
        if let json = self.object(forKey: key) as? [String: AnyObject] {
            return Mapper<T>().map(JSON: json)
        }
        return nil
    }

    func storeArray<T: Mappable>(_ array: [T]?, forKey key: String) {
        if let array = array {
            let json = Mapper<T>().toJSONArray(array)
            self.set(json, forKey: key)
            self.synchronize()
        }
    }

    func loadArray<T: Mappable>(forKey key: String) -> [T]? {
        if let json = self.object(forKey: key) as? [[String: AnyObject]] {
            return Mapper<T>().mapArray(JSONArray: json)
        }

        return nil
    }
}
