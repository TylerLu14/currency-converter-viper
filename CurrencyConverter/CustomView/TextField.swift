//
//  TextField.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/11/21.
//

import UIKit

class TextField: UITextField, Themeable {
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    private var leftViewInset: CGFloat {
        leftView?.frame.width ?? 0
    }
    
    private var rightViewInset: CGFloat {
        rightView?.frame.width ?? 0
    }
    
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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
            .inset(by: UIEdgeInsets(top: 0, left: leftViewInset, bottom: 0, right: rightViewInset))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
            .inset(by: UIEdgeInsets(top: 0, left: leftViewInset, bottom: 0, right: rightViewInset))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
            .inset(by: UIEdgeInsets(top: 0, left: leftViewInset, bottom: 0, right: rightViewInset))
    }
}
