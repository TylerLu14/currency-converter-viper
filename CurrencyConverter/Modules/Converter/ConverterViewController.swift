//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//


import UIKit
import SnapKit

extension ThemeType {
    var icon: UIImage? {
        switch self {
        case .light: return R.image.themeChangeIconLight()
        case .dark: return R.image.themeChangeIconDark()
        }
    }
}

final class ConverterViewController: BaseViewController {

    var presenter: ConverterPresenterProtocol?
    
    lazy var titleLabel: UILabel = {
        let temp = UILabel()
        temp.numberOfLines = 0
        temp.font = R.font.montserratBold(size: 26)
        temp.text = "Currency Converter"
        return temp
    }()
    
    lazy var offlineLabel: UILabel = {
        let temp = UILabel()
        temp.numberOfLines = 0
        temp.font = R.font.montserratMedium(size: 14)
        temp.text = "  --Offline Mode--  "
        return temp
    }()
    
    lazy var fetchTimestampLabel: UILabel = {
        let temp = UILabel()
        temp.numberOfLines = 0
        temp.font = R.font.montserratRegular(size: 14)
        return temp
    }()
    
    lazy var fromTextField: CurrencyTextField = {
        let temp = CurrencyTextField()
        return temp
    }()
    
    lazy var toTextField: CurrencyTextField = {
        let temp = CurrencyTextField()
        temp.isValueEnabled = false
        return temp
    }()
    
    lazy var errorLabel: UILabel = {
        let temp = UILabel()
        temp.numberOfLines = 0
        temp.font = R.font.montserratRegular(size: 14)
        temp.text = ""
        return temp
    }()
    
    lazy var switchButton: UIButton = {
        let temp = UIButton()
        temp.setImage(R.image.switchIcon()?.rotate(radians: .pi/2), for: .normal)
        temp.imageView?.contentMode = .scaleAspectFit
        temp.contentVerticalAlignment = .fill
        temp.contentHorizontalAlignment = .fill
        return temp
    }()
    
    private lazy var convertButton: UIButton = {
        let temp = UIButton()
        temp.layer.cornerRadius = 8
        temp.clipsToBounds = true
        temp.setTitle("Convert", for: .normal)
        temp.titleLabel?.font = R.font.montserratBold(size: 26)
        return temp
    }()
    
    private lazy var exchangeRatesStack: UIStackView = {
        let temp = UIStackView()
        temp.axis = .vertical
        temp.spacing = 8
        temp.alignment = .fill
        temp.distribution = .fill
        return temp
    }()
    
    var entryLabels: [UILabel] = []
    
    lazy var keyboardFollower = KeyboardFollower()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(offlineLabel)
        view.addSubview(fetchTimestampLabel)
        view.addSubview(fromTextField)
        view.addSubview(switchButton)
        view.addSubview(toTextField)
        view.addSubview(convertButton)
        view.addSubview(errorLabel)
        view.addSubview(exchangeRatesStack)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        offlineLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(16)
        }
        
        fetchTimestampLabel.snp.makeConstraints { make in
            make.top.equalTo(offlineLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        fromTextField.snp.makeConstraints{ make in
            make.top.equalTo(fetchTimestampLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        switchButton.snp.makeConstraints { make in
            make.top.equalTo(fromTextField.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(32)
            make.width.height.equalTo(64)
        }
        
        toTextField.snp.makeConstraints{ make in
            make.top.equalTo(switchButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        errorLabel.snp.makeConstraints{ make in
            make.top.equalTo(toTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        convertButton.snp.makeConstraints{ make in
            make.top.equalTo(errorLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        exchangeRatesStack.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: ThemeManager.shared.selectedThemeType.icon,
            style: .plain,
            target: self, action: #selector(onTapped(themeButton:))
        )
        
        presenter?.viewDidLoad()
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped(backgroundGesture:))))
        fromTextField.textField.addTarget(self, action: #selector(onTextChanged(fromTextField:)), for: .editingChanged)
        
        fromTextField.addCurrencyGesture(UITapGestureRecognizer(target: self, action: #selector(onTapped(fromCurrencyGesture:))))
        toTextField.addCurrencyGesture(UITapGestureRecognizer(target: self, action: #selector(onTapped(toCurrencyGesture:))))
        
        convertButton.addTarget(self, action: #selector(onTapped(convertButton:)), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(onTapped(switchButton:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        keyboardFollower.follow { [unowned self] keyboardFrame, _, type in
            switch type {
            case .show:
                let lowestView = self.convertButton
                let offset =  min(keyboardFrame.minY - lowestView.frame.maxY - 16, 0)
                self.view.transform = CGAffineTransform(translationX: 0, y: offset)
            case .hide:
                self.view.transform = .identity
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardFollower.unfollow()
    }
    
    override func refreshTheme(theme: Theme) {
        super.refreshTheme(theme: theme)
        
        titleLabel.textColor = theme.primaryTextColor
        offlineLabel.textColor = theme.textOnYellowColor
        offlineLabel.backgroundColor = theme.buttonBackgroundColor
        fetchTimestampLabel.textColor = theme.secondaryTextColor
        
        convertButton.setBackgroundImage(theme.buttonBackgroundColor.toImage(), for: .normal)
        convertButton.setBackgroundImage(theme.highlightedNuttonBackgroundColor.toImage(), for: .highlighted)
        convertButton.setBackgroundImage(theme.disabledbuttonBackgroundColor.toImage(), for: .disabled)
        
        convertButton.setTitleColor(theme.textOnYellowColor, for: .normal)
        convertButton.setTitleColor(theme.disabledTextColor, for: .disabled)
        
        errorLabel.textColor = theme.errorTextColor
    }
    
    @objc func onTapped(backgroundGesture: UITapGestureRecognizer) {
        fromTextField.textField.resignFirstResponder()
    }
    
    @objc func onTextChanged(fromTextField: UITextField) {
        presenter?.sourceTextChanged(text: fromTextField.text)
    }
    
    @objc func onTapped(convertButton: UIButton) {
        presenter?.convertButtonTapped()
    }
    
    @objc func onTapped(fromCurrencyGesture: UIGestureRecognizer) {
        presenter?.showSourceSelectCurrency(viewController: self) { [weak self] currencyModel in
            self?.presenter?.selectCurrency(source: currencyModel.data)
        }
    }
    
    @objc func onTapped(toCurrencyGesture: UIGestureRecognizer) {
        presenter?.showDestinationSelectCurrency(viewController: self) { [weak self] currencyModel in
            self?.presenter?.selectCurrency(destination: currencyModel.data)
        }
    }
    
    @objc func onTapped(themeButton: UIButton) {
        let currentTheme = ThemeManager.shared.selectedThemeType
        ThemeManager.shared.selectedThemeType = ThemeType.allCases[(currentTheme.rawValue + 1) % ThemeType.allCases.count]
        navigationItem.rightBarButtonItem?.image = ThemeManager.shared.selectedThemeType.icon
    }
    
    @objc func onTapped(switchButton: UIButton) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            let offset = self.toTextField.frame.minY - self.fromTextField.frame.minY
            self.fromTextField.transform = CGAffineTransform(translationX: 0, y: offset)
            self.toTextField.transform = CGAffineTransform(translationX: 0, y: -offset)
        } completion: { _ in
            self.presenter?.swapSelectedCurrency()
            self.fromTextField.transform = .identity
            self.toTextField.transform = .identity
        }
    }
}

extension ConverterViewController: ConverterViewProtocol {
    func updateOfflineLabel(isOffline: Bool) {
        offlineLabel.isHidden = !isOffline
        offlineLabel.snp.updateConstraints{ make in
            make.height.equalTo(isOffline ? 24 : 0)
        }
    }
    
    func updateTimeStampLabel(text: String?) {
        fetchTimestampLabel.text = text
    }
    
    func updateErrorLabel(text: String?) {
        errorLabel.text = text
    }
    
    func updateConvertButton(text: String?, isEnabled: Bool) {
        convertButton.isEnabled = isEnabled
        convertButton.setTitle(text, for: .normal)
    }
    
    func updateSourceCurrency(with currency: CurrencyData?) {
        fromTextField.currency = currency?.code
        fromTextField.currencyImage = UIImage(named: currency?.code.lowercased() ?? "flag")
    }
    
    func updateDestinationCurrency(with currency: CurrencyData?) {
        toTextField.currency = currency?.code
        toTextField.currencyImage = UIImage(named: currency?.code.lowercased() ?? "flag")
    }
    
    func updateResult(fromText: String?, toText: String?) {
        fromTextField.text = fromText
        toTextField.text = toText
    }
    
    func updateExchangeRates(with entries: [String]) {
        
        exchangeRatesStack.arrangedSubviews.forEach{ subview in
            exchangeRatesStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        entryLabels = entries.map{ generateEntryLabel(text: $0) }
        entryLabels.forEach{ exchangeRatesStack.addArrangedSubview($0) }
        exchangeRatesStack.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    func generateEntryLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = R.font.montserratRegular(size: 14)
        label.text = text
        label.textColor = ThemeManager.shared.currentTheme.secondaryTextColor
        return label
    }
}
