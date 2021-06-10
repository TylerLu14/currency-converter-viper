//
//  ConverterInteractor.swift
//  CurrencyConverter
//
//  Created by Lữ on 6/6/21.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

typealias ConvertModel = (value: Double, fromCurrency: String, toCurrency: String)

struct Currency {
    let source: String
    let image: UIImage?
    let name: String
}

final class ConverterInteractor: ConverterInteractorProtocol {
    private let disposeBag = DisposeBag()
    private let service: CurrencyLayerServiceProtocol
    
    let liveQuoteResponse = PublishRelay<LiveQuotesResponse>()
    
    let quotes: Observable<[String:Double]>
    
    //Input
    let convertTrigger = PublishSubject<ConvertModel>()
    
    //Output
    let convertResult: Observable<String>
    let allCurrencies: Observable<[Currency]>

    init(service: CurrencyLayerServiceProtocol, source: String) {
        self.service = service
        
        self.quotes = liveQuoteResponse.map{ response in
            let tuples = response.quotes.map{ pair, rate in
                (String(pair.dropFirst(response.source.count)), rate)
            }
            return Dictionary(tuples, uniquingKeysWith: { key, _ in key })
        }
        
        self.allCurrencies = liveQuoteResponse.map{ response in
            response.quotes.map{ pair, rate in
                Currency(
                    source: response.source,
                    image: nil,
                    name: String(pair.dropFirst(response.source.count))
                )
            }
        }
        
        self.convertResult = convertTrigger.withLatestFrom(liveQuoteResponse, resultSelector: { ($0, $1) })
            .flatMap{ convertModel, response -> Observable<String> in
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.currencyCode = convertModel.toCurrency
                numberFormatter.currencySymbol = ""
                
                
                if let quote = response.quotes["\(convertModel.fromCurrency)\(convertModel.toCurrency)"] {
                    let value = convertModel.value * quote
                    let result = numberFormatter.string(from: NSNumber(value: value)) ?? ""
                    return .just(result)
                }
                
                if let quote = response.quotes["\(convertModel.toCurrency)\(convertModel.fromCurrency)"], quote > 0 {
                    let value = convertModel.value / quote
                    let result = numberFormatter.string(from: NSNumber(value: value)) ?? ""
                    return .just(result)
                }
                
                if let sourceFromQuote = response.quotes["\(source)\(convertModel.fromCurrency)"],
                   let sourceToQuote = response.quotes["\(source)\(convertModel.toCurrency)"],
                   sourceFromQuote > 0 {
                    let value = convertModel.value / sourceFromQuote * sourceToQuote
                    let result = numberFormatter.string(from: NSNumber(value: value)) ?? ""
                    return .just(result)
                }
                
                return .error(ServiceError.currencyNotFound)
            }
        
        service.fetchLiveQuotes(source: source)
            .subscribe(onSuccess: { response in
                self.liveQuoteResponse.accept(response)
            }, onFailure: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
    }
}
