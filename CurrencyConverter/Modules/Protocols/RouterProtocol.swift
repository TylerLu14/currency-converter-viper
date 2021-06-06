//
//  RouterProtocol.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//


import Foundation
import UIKit

protocol RouterProtocol {
    var view: ViewProtocol! { get }

    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion: @escaping (() -> Void))
    func pop(animated: Bool)
}

extension RouterProtocol {
    func dismiss(animated: Bool) {
        view.dismiss(animated: animated)
    }
    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        view.dismiss(animated: animated, _completion: completion)
    }

    func pop(animated: Bool) {
        view.pop(animated: animated)
    }
}
