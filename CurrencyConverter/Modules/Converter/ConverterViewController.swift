//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ConverterViewController: BaseViewController, ConverterViewProtocol {
    private let disposeBag = DisposeBag()
    var presenter: ConverterPresenterProtocol?
    
    lazy var titleLabel: UILabel = {
        let temp = UILabel()
        temp.font = R.font.montserratBold(size: 28)
        temp.text = "Currency Converter"
        return temp
    }()
    
    lazy var fromTextField: CurrencyTextField = {
        let temp = CurrencyTextField()
        temp.placeholder = "Enter the amount"
        temp.currency = "USD"
        return temp
    }()
    
    lazy var toTextField: CurrencyTextField = {
        let temp = CurrencyTextField()
        temp.isValueEnabled = false
        temp.placeholder = "Result displayed here"
        temp.currency = "VND"
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
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(fromTextField)
        view.addSubview(switchButton)
        view.addSubview(toTextField)
        view.addSubview(convertButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        fromTextField.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(48)
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
        
        convertButton.snp.makeConstraints{ make in
            make.top.equalTo(toTextField.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presenter = presenter {
            bindInput(input: presenter.inputs)
            bindOutput(output: presenter.outputs)
        }
    }
    
    override func refreshTheme(theme: Theme) {
        super.refreshTheme(theme: theme)
        
        titleLabel.textColor = theme.primaryTextColor
        
        convertButton.setBackgroundImage(theme.buttonBackgroundColor.toImage(), for: .normal)
        convertButton.setBackgroundImage(theme.highlightedNuttonBackgroundColor.toImage(), for: .highlighted)
        convertButton.setBackgroundImage(theme.disabledTextColor.toImage(), for: .disabled)
        
        convertButton.setTitleColor(theme.textOnYellowColor, for: .normal)
        convertButton.setTitleColor(theme.disabledTextColor, for: .disabled)
    }
    
    func bindInput(input: ConverterPresenterInputs) {
        fromTextField.rx.text
            .bind(to: input.inputAmountChanged)
            .disposed(by: disposeBag)
        
        convertButton.rx.tap.withLatestFrom(fromTextField.rx.text)
            .filterNil()
            .bind(to: input.convertButtonTrigger)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(output: ConverterPresenterOutputs) {
        output.result.subscribe(on: scheduler.main)
            .subscribe(onNext: { [unowned self] result in
                self.toTextField.text = result
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }

}

extension ConverterViewController: ViewProtocol { }
