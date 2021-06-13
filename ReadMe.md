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
* Fetch new exchange data at app launch and every hour after launch:
 <img width="285" alt="Screen Shot 2021-06-13 at 6 04 50 PM" src="https://user-images.githubusercontent.com/20063699/121804719-f5ac1b80-cc71-11eb-8e3c-a5ae33a6a7be.png">
 
* Currency Converter:
 * Can accept different number formats: `1000`, `100.00`, `1,000,000` or even `100,00,,,000.00`
 * Can accept different number formats: `1000`, `100.00`, `1,000,000` or even `100,00,,,000.00`
 * Will not output anything if user forces to enter letters or wrong number format, eg `100.00.00`
<img width="300" alt="Screen Shot 2021-06-13 at 5 59 16 PM" src="https://user-images.githubusercontent.com/20063699/121804557-20e23b00-cc71-11eb-8e18-f24c63de4808.png">

* Dark/Light Mode: Change to dark/light mode by pressing top-right corner button
<img width="300" alt="Screen Shot 2021-06-13 at 5 59 16 PM" src="https://user-images.githubusercontent.com/20063699/121804746-1b392500-cc72-11eb-9379-c682ea47a009.png">

* Select source and destination currencies: By pressing on the left of the input and output text fields
<img width="300" alt="Screen Shot 2021-06-13 at 5 59 16 PM" src="https://user-images.githubusercontent.com/20063699/121804821-71a66380-cc72-11eb-9f24-9135bab6d0be.png">

* Swap the current selected currencies
<img width="300" alt="Screen Shot 2021-06-13 at 6 08 15 PM" src="https://user-images.githubusercontent.com/20063699/121804812-63f0de00-cc72-11eb-8f91-8855d550c153.png">

* Remember selected currencies:
* Show the past fetched exchange rate between the selected currencies (up to 10 entries)
<img width="300" alt="Screen Shot 2021-06-13 at 6 08 15 PM" src="https://user-images.githubusercontent.com/20063699/121805072-b2eb4300-cc73-11eb-8cdd-29d4a9dc3c10.png">

* Offline Mode:
 * If for some reason, the user cannot fetch data for the first time opening the app, they will be able to re-fetch the data by pressing refresh 
<img width="300" alt="Screen Shot 2021-06-13 at 6 08 15 PM" src="https://user-images.githubusercontent.com/20063699/121804902-e2e61680-cc72-11eb-9693-e35367e3d6a9.png">
![simulator_screenshot_80DD226F-0A42-43FA-BADD-C2B246B0846D]()
 * If there is some offline data fetched, the user will enter offline mode
 <img width="300" alt="Screen Shot 2021-06-13 at 6 08 15 PM" src="https://user-images.githubusercontent.com/20063699/121805041-8df6d000-cc73-11eb-8190-f0bfb2fe2bfa.png">
