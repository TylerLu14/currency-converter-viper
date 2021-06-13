## Summary

Interviewee: Hoang Lu

Email: tyler.lu1401@gmail.com

## Prerequisites
* XCode 12.5.
* Cocoapods 1.10.1. Run `sudo gem install cocoapods`.
* iOS Deployment target: 11.0

## Usage
1. Clone the project
2. Open Terminal, navigate to project foler, run command `pod install`
3. Open project in XCode. Make sure you open file CurrencyConverter.xcworkspace, not karros-video.xcodeproj
4. Run the project on simulator

## Dependencies
* All dependencies are installed via cocoapods for easy update
  * 'ObjectMapper'
  * 'Alamofire'
  * 'PromiseKit'
  * 'SnapKit'
  * 'R.swift'
  * 'PanModal'
  * 'Reusable'

Features
=======

## Design Pattern
 ### VIPER
 * Why VIPER?
  * As a requirement of the assignment, we need to write unit tests for the project. VIPER is now the most testable patterns out there.
  * VIPER is clean and clear. It's easy to read and to scale.
  

 ### How VIPER
 * Every module will have a contract to describe the functions of each component -> Easy to control, can be injected to write unit tests. The concrete classes just implement accordingly
 ```swift
// Contract.swift
// Presenter -> View
protocol CurrencySelectViewProtocol: AnyObject {
    func reloadData()
    func setInitialStyle(style: CollectionViewStyle)
    func reloadStyle(style: CollectionViewStyle)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func updateStyleButton(style: CollectionViewStyle)
}

//View -> Presenter
protocol CurrencySelectPresenterProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    var interactor: CurrencySelectInteractorProtocol? { get set }
    var view: CurrencySelectViewProtocol? { get set }
    var router: CurrencySelectRouterProtocol? { get set }
    
    func viewDidLoad()
    func onStyleButtonTapped()
}

//Presenter -> Interactor
protocol CurrencySelectInteractorProtocol: AnyObject {
    var presenter: CurrencySelectInteractorOutputProtocol? { get set }
    
    func loadCurrencies()
    func loadViewStyle()
    func saveViewStyle(style: CollectionViewStyle)
}

//Interactor -> Presenter
protocol CurrencySelectInteractorOutputProtocol: AnyObject {
    func onCurrenciesUpdated(currencyModels: [CurrencyModel])
    func onStyleRestore(style: CollectionViewStyle)
}

//Presenter -> Wireframe
protocol CurrencySelectRouterProtocol: AnyObject {
    
}
 ```

### Features:
* Currency Converter:
<img width="396" alt="Screen Shot 2021-06-13 at 5 59 16 PM" src="https://user-images.githubusercontent.com/20063699/121804557-20e23b00-cc71-11eb-8e18-f24c63de4808.png">

* Dark/Light Mode:
* Select source and destination currencies from a PanModal
* Swap the current selected currencies
* Remember selected currencies:
* Show the past fetched exchange rate (up to 10 entries)
* Offline Mode:
