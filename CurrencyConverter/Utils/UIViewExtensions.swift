//
//  UIViewExtensions.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/12/21.
//

import UIKit

extension UIWindow {
    func findViewElement<T>(ofType type: T.Type) -> [T] {
        guard let rootViewController = self.rootViewController else {
            return []
        }
        
        return rootViewController.findElement(ofType: type) + rootViewController.view.findElement(ofType: type)
    }
}

extension UIView {
    func findElement<T>(ofType type: T.Type) -> [T] {
        var result: [T] = []
        if let self = self as? T {
            result.append(self)
        }
        self.subviews.forEach{ subView in
            result.append(contentsOf: subView.findElement(ofType: T.self))
        }
        
        return result
    }
}

extension UIViewController {
    
    func findElement<T>(ofType type: T.Type) -> [T] {
        var result: [T] = []
        if let self = self as? T {
            result.append(self)
        }
        
        self.children.forEach{ child in
            result.append(contentsOf: child.findElement(ofType: T.self))
        }
        
        if let presentedViewController = presentedViewController {
            presentedViewController.children.forEach{ child in
                result.append(contentsOf: child.findElement(ofType: T.self))
            }
        }
        
        return result
    }
}
