//
//  UINavigationControllerExtensions.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/12/21.
//

import UIKit
import PanModal

class NavigationController: UINavigationController, Themeable {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    func refreshTheme(theme: Theme) {
        self.navigationBar.titleTextAttributes = [.foregroundColor: theme.primaryTextColor]
        self.navigationBar.tintColor = theme.primaryTextColor
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension UINavigationController: PanModalPresentable {
    
    public var panScrollable: UIScrollView? {
        return (self.topViewController as? PanModalPresentable)?.panScrollable
    }
    
    public var shortFormHeight: PanModalHeight {
        return (self.topViewController as? PanModalPresentable)?.shortFormHeight ?? .maxHeight
    }
    
    public var longFormHeight: PanModalHeight {
        return (self.topViewController as? PanModalPresentable)?.longFormHeight ?? .maxHeight
    }
}
