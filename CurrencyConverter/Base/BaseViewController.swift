//
//  BaseViewController.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import UIKit

class BaseViewController: UIViewController, Themeable {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshTheme(theme: ThemeManager.shared.currentTheme)
    }
    
    func refreshTheme(theme: Theme) {
        view.backgroundColor = theme.backgroundColor
    }
}
