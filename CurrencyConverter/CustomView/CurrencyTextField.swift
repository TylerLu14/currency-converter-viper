//
//  CurrencyView.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/10/21.
//

import UIKit

class CurrencyView: View {
    private lazy var currencyImageView: UIImageView = {
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    
    private lazy var currencyLabel: UILabel = {
        let temp = UILabel()
        temp.font = R.font.montserratMedium(size: 16)
        return temp
    }()
    
    private lazy var indicatorImageView: UIImageView = {
        let temp = UIImageView()
        temp.image = R.image.currencyArrowDown()
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    
    var currency: String? {
        get { currencyLabel.text }
        set { currencyLabel.text = newValue }
    }
    
    var currencyImage: UIImage? {
        get { currencyImageView.image }
        set { currencyImageView.image = newValue }
    }
    
    override func setup() {
        super.setup()
        
        addSubview(currencyImageView)
        addSubview(currencyLabel)
        addSubview(indicatorImageView)
        
        currencyImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        currencyLabel.snp.makeConstraints { make in
            make.leading.equalTo(currencyImageView.snp.trailing).offset(8)
            make.top.bottom.equalToSuperview()
        }
        currencyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        indicatorImageView.snp.makeConstraints { make in
            make.leading.equalTo(currencyLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.width.height.equalTo(16)
            make.trailing.equalToSuperview()
        }
    }
    
    override func refreshTheme(theme: Theme) {
        super.refreshTheme(theme: theme)
        
        currencyLabel.textColor = theme.primaryTextColor
        
    }
}

class CurrencyTextField: View {
    private lazy var currencyView: CurrencyView = {
        let temp = CurrencyView()
        return temp
    }()
    
    private lazy var line: View = {
        let temp = View()
        return temp
    }()
    
    lazy var textField: TextField = {
        let temp = TextField()
        temp.font = R.font.montserratMedium(size: 18)
        temp.keyboardType = .decimalPad
        return temp
    }()
    
    var currency: String? {
        get { currencyView.currency }
        set { currencyView.currency = newValue }
    }
    
    var currencyImage: UIImage? {
        get { currencyView.currencyImage }
        set { currencyView.currencyImage = newValue }
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var placeholder: String? {
        get { textField.placeholder }
        set {
            textField.placeholder = newValue
            refreshTheme(theme: ThemeManager.shared.currentTheme)
        }
    }
    
    var isValueEnabled: Bool {
        get { textField.isEnabled }
        set { textField.isEnabled = newValue }
    }
    
    override func setup() {
        super.setup()
        
        isUserInteractionEnabled = true
        layer.cornerRadius = 8
        
        addSubview(currencyView)
        addSubview(textField)
        addSubview(line)
        
        currencyView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
        }
        currencyView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        line.snp.makeConstraints { make in
            make.leading.equalTo(currencyView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(1)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(line.snp.trailing).offset(8	)
            make.top.bottom.trailing.equalToSuperview()
        }
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    override func refreshTheme(theme: Theme) {
        super.refreshTheme(theme: theme)
        
        backgroundColor = theme.textFieldBackgroundColor
        line.backgroundColor = theme.lineColor
        textField.textColor = theme.textFieldTextColor
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [.foregroundColor: theme.textFieldPlaceholderTextColor]
        )
    }
    
    func addCurrencyGesture(_ gesture: UIGestureRecognizer) {
        currencyView.addGestureRecognizer(gesture)
    }
}

