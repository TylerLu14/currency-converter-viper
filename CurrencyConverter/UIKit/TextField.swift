//
//  TextField.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/10/21.
//

import UIKit

class TextField: UITextField, Themeable {
    override var placeholder: String? {
        didSet {
            setPlaceHolderTextColor(placeHodlerTextColor)
        }
    }
    
    var placeHodlerTextColor: UIColor = .black {
        didSet {
            setPlaceHolderTextColor(placeHodlerTextColor)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup() {
        refreshTheme(theme: ThemeManager.shared.currentTheme)
    }
    
    private func setPlaceHolderTextColor(_ color: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor : color]
        )
    }
    
    func refreshTheme(theme: Theme) {
        backgroundColor = theme.textFieldBackgroundColor
        textColor = theme.textFieldTextColor
        placeHodlerTextColor = theme.textFieldPlaceholderTextColor
    }
}

