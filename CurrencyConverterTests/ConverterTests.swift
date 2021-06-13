//
//  ConverterPresenterTests.swift
//  ConverterTests
//
//  Created by Lữ on 6/13/21.
//

import XCTest
import PromiseKit
import CurrencyConverter

class ConverterPresenterTests: XCTestCase {
    var sut: ConverterPresenter!
    var mockView: MockView!
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!

    override func setUpWithError() throws {
        let view = MockView()
        
        let presenter = ConverterPresenter()
        let interactor = MockInteractor(exchangeService: MockExchangeService(), fileService: MockFileService())
        let router = MockRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        self.sut = presenter
        self.mockView = view
        self.mockInteractor = interactor
        self.mockRouter = router
        
        presenter.viewDidLoad()
        let exp = expectation(description: "Test after 5 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 0.5)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialValue() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        
        XCTAssertEqual(mockView.isOffline, false)
        XCTAssertEqual(
            mockView.timestampText,
            "Last fetched exchange rate data:\n\(formatter.string(from: Date(timeIntervalSince1970: 1623576396)))"
        )
        XCTAssertEqual(mockView.error, nil)
        XCTAssertEqual(mockView.buttonText, "Convert")
        XCTAssertEqual(mockView.buttonEnabled, false)
        XCTAssertEqual(mockView.sourceText, nil)
        XCTAssertEqual(mockView.destinationText, nil)
        XCTAssertEqual(mockView.sourceCurrency?.code, "USD")
        XCTAssertEqual(mockView.destinationCurrency?.code, "EUR")
        XCTAssertEqual(mockView.exchangeRatesEntries, [])
        XCTAssertEqual(mockView.alertPresented, false)
    }
    
    func testConvertButtonState() {
        sut.sourceTextChanged(text: nil)
        XCTAssertEqual(mockView.buttonEnabled, false)
        
        sut.sourceTextChanged(text: "123123")
        XCTAssertEqual(mockView.buttonEnabled, true)
        
        sut.sourceTextChanged(text: "Some random texts")
        XCTAssertEqual(mockView.buttonEnabled, false)
        
        mockInteractor.presenter?.onLiveQuotesFetched(state: .loading)
        XCTAssertEqual(mockView.buttonText, "Loading...")
        XCTAssertEqual(mockView.buttonEnabled, false)
        
        mockInteractor.presenter?.onLiveQuotesFetched(state: .failure(ServiceError.cannotParseData))
        XCTAssertEqual(mockView.buttonText, "Refresh")
        XCTAssertEqual(mockView.buttonEnabled, true)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


class ConverterInteractorTests: XCTestCase {
    var sut: MockPresenter!
    var mockView: MockView!
    var mockInteractor: ConverterInteractor!
    var mockRouter: MockRouter!

    override func setUpWithError() throws {
        let view = MockView()
        
        let presenter = MockPresenter()
        let interactor = ConverterInteractor(exchangeService: MockExchangeService(), fileService: MockFileService())
        let router = MockRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        self.sut = presenter
        self.mockView = view
        self.mockInteractor = interactor
        self.mockRouter = router
        
        presenter.viewDidLoad()
        let exp = expectation(description: "Test after 5 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 0.5)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testConvertValues() {
        sut.sourceTextChanged(text: nil)
        sut.selectCurrency(source: CurrencyData(JSON: ["code":"USD"])!)
        sut.selectCurrency(destination: CurrencyData(JSON: ["code":"VND"])!)
        sut.convertButtonTapped()
        XCTAssertEqual(mockView.destinationText, nil)
        
        sut.sourceTextChanged(text: "1")
        sut.selectCurrency(source: CurrencyData(JSON: ["code":"USD"])!)
        sut.selectCurrency(destination: CurrencyData(JSON: ["code":"VND"])!)
        sut.convertButtonTapped()
        XCTAssertEqual(mockView.destinationText, "23,000")
        
        sut.sourceTextChanged(text: "100")
        sut.selectCurrency(source: CurrencyData(JSON: ["code":"USD"])!)
        sut.selectCurrency(destination: CurrencyData(JSON: ["code":"VND"])!)
        sut.convertButtonTapped()
        XCTAssertEqual(mockView.destinationText, "2,300,000")
        
        sut.sourceTextChanged(text: "35")
        sut.selectCurrency(source: CurrencyData(JSON: ["code":"USD"])!)
        sut.selectCurrency(destination: CurrencyData(JSON: ["code":"AUD"])!)
        sut.convertButtonTapped()
        XCTAssertEqual(mockView.destinationText, "45.50")
        
        sut.sourceTextChanged(text: "0")
        sut.selectCurrency(source: CurrencyData(JSON: ["code":"USD"])!)
        sut.selectCurrency(destination: CurrencyData(JSON: ["code":"AUD"])!)
        sut.convertButtonTapped()
        XCTAssertEqual(mockView.destinationText, "0.00")
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
