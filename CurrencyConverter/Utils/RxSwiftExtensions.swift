//
//  RxSwiftExtensions.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

//import RxSwift
//
//public extension ObservableType where Element: OptionalType {
//    func filterNil() -> Observable<Element.Wrapped> {
//        return self.flatMap { element -> Observable<Element.Wrapped> in
//            guard let value = element.value else {
//                return Observable<Element.Wrapped>.empty()
//            }
//            return Observable<Element.Wrapped>.just(value)
//        }
//    }
//}
//
//public protocol OptionalType {
//    associatedtype Wrapped
//    var value: Wrapped? { get }
//}
//
//extension Optional: OptionalType {
//    /// Cast `Optional<Wrapped>` to `Wrapped?`
//    public var value: Wrapped? {
//        return self
//    }
//}
