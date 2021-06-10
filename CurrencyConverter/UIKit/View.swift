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
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup() {
        refreshTheme(theme: ThemeManager.shared.currentTheme)
    }
    
    func refreshTheme(theme: Theme) { }
}
