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
    
    lazy var fromTextField: UITextField = {
        let temp = UITextField()
        temp.font = R.font.montserratMedium(size: 20)
        temp.placeholder = "Enter The Amount"
        return temp
    }()
    
    lazy var toTextField: UITextField = {
        let temp = UITextField()
        temp.font = R.font.montserratMedium(size: 20)
        temp.placeholder = "The Converted Amount"
        temp.isEnabled = false
        return temp
    }()
    
    lazy var convertButton: UIButton = {
        let temp = UIButton()
        temp.backgroundColor = .yellow
        temp.setTitle("Convert", for: .normal)
        temp.titleLabel?.font = R.font.montserratBold(size: 28)
        temp.setTitleColor(.black, for: .normal)
        return temp
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        view.addSubview(fromTextField)
        view.addSubview(toTextField)
        view.addSubview(convertButton)
        
        fromTextField.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        toTextField.snp.makeConstraints{ make in
            make.top.equalTo(fromTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        convertButton.snp.makeConstraints{ make in
            make.top.equalTo(toTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presenter = presenter {
            bindInput(input: presenter.inputs)
            bindOutput(output: presenter.outputs)
        }
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
