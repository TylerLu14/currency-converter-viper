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
    var presenter: ConverterPresenterProtocol?
    
    lazy var fromTextField: UITextField = {
        let temp = UITextField()
        temp.placeholder = "Enter The Amount"
        return temp
    }()
    
    lazy var toTextField: UITextField = {
        let temp = UITextField()
        temp.placeholder = "The Converted Amount"
        temp.isEnabled = false
        return temp
    }()
    
    lazy var convertButton: UIButton = {
        let temp = UIButton()
        temp.setTitle("Convert", for: .normal)
        return temp
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        view.addSubview(fromTextField)
        view.addSubview(toTextField)
        view.addSubview(convertButton)
        
        fromTextField.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        toTextField.snp.makeConstraints{ make in
            make.top.equalTo(fromTextField.snp.bottom).inset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        convertButton.snp.makeConstraints{ make in
            make.top.equalTo(toTextField.snp.bottom).inset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presenter = presenter {
            bindInput(input: presenter.inputs)
            bindOutput(outpput: presenter.outputs)
        }
    }
    
    func bindInput(input: ConverterPresenterInputs) {
        
    }
    
    func bindOutput(outpput: ConverterPresenterOutputs) {
        
    }

}

extension ConverterViewController: ViewProtocol { }
