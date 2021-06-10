//
//  View.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/10/21.
//

import UIKit

class View: UIView, Themeable {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        refreshTheme(theme: ThemeManager.shared.currentTheme)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        refreshTheme(theme: ThemeManager.shared.currentTheme)
    }
    
    func setup() { }
    
    func refreshTheme(theme: Theme) { }
}
