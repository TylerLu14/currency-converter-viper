//
//  BaseViewController.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import UIKit

class BaseViewController: UIViewController, Themeable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ThemeManager.shared.currentTheme.statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshTheme(theme: ThemeManager.shared.currentTheme)
    }
    
    func refreshTheme(theme: Theme) {
        view.backgroundColor = theme.backgroundColor
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}
