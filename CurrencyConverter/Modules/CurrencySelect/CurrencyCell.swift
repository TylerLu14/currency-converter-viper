//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/13/21.
//

import UIKit
import Reusable

extension CollectionViewStyle {
    var icon: UIImage? {
        switch self {
        case .grid: return R.image.listIcon()
        case .list: return R.image.gridIcon()
        }
    }
}

class CurrencyCell: UICollectionViewCell, Themeable, Reusable {
    var style: CollectionViewStyle? {
        didSet {
            guard style != oldValue, let style = style else {
                return
            }
            updateLayout(for: style, animated: oldValue != nil)
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    
    lazy var currencyCodeLabel: UILabel = {
        let temp = UILabel()
        temp.font = R.font.montserratMedium(size: 16)
        return temp
    }()
    
    lazy var currencyNameLabel: UILabel = {
        let temp = UILabel()
        temp.font = R.font.montserratRegular(size: 16)
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        refreshTheme(theme: ThemeManager.shared.currentTheme)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        refreshTheme(theme: ThemeManager.shared.currentTheme)
    }
    
    func setup() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(currencyCodeLabel)
        contentView.addSubview(currencyNameLabel)
    }
    
    func updateLayout(for style: CollectionViewStyle, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.layout(for: style)
                self.layoutIfNeeded()
            }
        } else {
            layout(for: style)
        }
    }
    
    private func layout(for style: CollectionViewStyle) {
        switch style {
        case .list:
            iconImageView.snp.remakeConstraints{ make in
                make.leading.equalToSuperview().inset(24)
                make.top.equalToSuperview().inset(8)
                make.width.equalTo(32)
            }
            
            currencyCodeLabel.snp.remakeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(24)
                make.trailing.equalToSuperview().inset(24)
                make.top.equalToSuperview().inset(8)
            }
            
            currencyNameLabel.snp.remakeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(24)
                make.trailing.equalToSuperview().inset(24)
                make.top.equalTo(currencyCodeLabel.snp.bottom).offset(4)
                make.bottom.equalToSuperview().inset(8)
            }
            
        case .grid:
            iconImageView.snp.remakeConstraints{ make in
                make.top.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
                make.height.equalTo(24)
            }
            
            currencyCodeLabel.snp.remakeConstraints { make in
                make.top.equalTo(iconImageView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(8)
            }
            currencyNameLabel.snp.removeConstraints()
            
        }
    }
    
    func refreshTheme(theme: Theme) {
        backgroundColor = theme.backgroundColor
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = theme.selectedBackgroundColor

        currencyCodeLabel.textColor = theme.primaryTextColor
        currencyNameLabel.textColor = theme.secondaryTextColor
    }
    
    func updateCell(currencyData: CurrencyData, style: CollectionViewStyle) {
        iconImageView.image = UIImage(named: currencyData.code.lowercased())
        currencyNameLabel.text = currencyData.name
        
        switch style {
        case .list:
            currencyCodeLabel.textAlignment = .left
            currencyNameLabel.isHidden = false
            currencyCodeLabel.text = "\(currencyData.symbol) - \(currencyData.code)"
        case .grid:
            currencyCodeLabel.text = currencyData.code
            currencyCodeLabel.textAlignment = .center
            currencyNameLabel.isHidden = true
        }
        self.style = style
    }
}
