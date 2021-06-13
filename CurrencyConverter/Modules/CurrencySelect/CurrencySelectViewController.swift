//
//  CurrencySelectViewController.swift
//  CurrencyCurrencySelect
//
//  Created by Lữ on 6/6/21.
//


import UIKit
import SnapKit
import Reusable
import PanModal

final class CurrencySelectViewController: BaseViewController {

    var presenter: CurrencySelectPresenterProtocol?
    
    private lazy var listLayout: UICollectionViewFlowLayout = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 64)
        collectionFlowLayout.minimumInteritemSpacing = 0
        collectionFlowLayout.minimumLineSpacing = 0
        return collectionFlowLayout
    }()

    private lazy var gridLayout: UICollectionViewFlowLayout = {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 16, height: 64)
        collectionFlowLayout.minimumInteritemSpacing = 8
        collectionFlowLayout.minimumLineSpacing = 16
        return collectionFlowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let temp = UICollectionView(frame: .zero, collectionViewLayout: listLayout )
        return temp
    }()
    
    private lazy var styleButton: UIBarButtonItem = {
        return UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(onTapped(styleButton:)))
    }()
    
    
    override func loadView() {
        super.loadView()
        
        title = "Select Currency"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = styleButton
        
        collectionView.register(cellType: CurrencyCell.self)
        collectionView.delegate = presenter
        collectionView.dataSource = presenter
        
        presenter?.viewDidLoad()
    }
    
    override func refreshTheme(theme: Theme) {
        super.refreshTheme(theme: theme)
        
        collectionView.backgroundColor = theme.backgroundColor
    }
    
    @objc func onTapped(styleButton: UIBarButtonItem) {
        presenter?.onStyleButtonTapped()
    }
}

extension CurrencySelectViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        collectionView
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(300)
    }
    
    var longFormHeight: PanModalHeight {
        .maxHeightWithTopInset(100)
    }
}

extension CurrencySelectViewController: CurrencySelectViewProtocol {
    func reloadData() {
        collectionView.reloadData()
    }
    
    func reloadStyle(style: CollectionViewStyle) {
        let layout: UICollectionViewFlowLayout = {
            switch style {
            case .list: return self.listLayout
            case .grid: return self.gridLayout
            }
        }()
        collectionView.reloadData()
        collectionView.startInteractiveTransition(to: layout)
        collectionView.finishInteractiveTransition()
    }
    
    func setInitialStyle(style: CollectionViewStyle) {
        let layout: UICollectionViewFlowLayout = {
            switch style {
            case .list: return self.listLayout
            case .grid: return self.gridLayout
            }
        }()
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func updateStyleButton(style: CollectionViewStyle) {
        styleButton.image = style.icon?.withRenderingMode(.alwaysOriginal)
    }
}
