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

final class ConverterInteractor: ConverterInteractorProtocol {
    private let disposeBag = DisposeBag()
    private let service: CurrencyLayerServiceProtocol
    
    var liveQuoteResponse = PublishRelay<LiveQuotesResponse>()
    
    //Input
    let convertTrigger = PublishSubject<ConvertModel>()
    
    //Output
    let result: Observable<String>

    init(service: CurrencyLayerServiceProtocol, source: String) {
        self.service = service
        
        self.result = convertTrigger.withLatestFrom(liveQuoteResponse, resultSelector: { ($0, $1) })
            .flatMap{ convertModel, response -> Observable<Double> in
                if let quote = response.quotes["\(convertModel.fromCurrency)\(convertModel.toCurrency)"] {
                    return .just(convertModel.value * quote)
                }
                
                if let quote = response.quotes["\(convertModel.toCurrency)\(convertModel.fromCurrency)"], quote > 0 {
                    return .just(convertModel.value / quote)
                }
                
                if let sourceFromQuote = response.quotes["\(source)\(convertModel.fromCurrency)"],
                   let sourceToQuote = response.quotes["\(source)\(convertModel.toCurrency)"],
                   sourceFromQuote > 0 {
                    return .just(convertModel.value / sourceFromQuote * sourceToQuote)
                }
                
                return .error(ServiceError.currencyNotFound)
            }
            .map{ result in
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                return numberFormatter.string(from: NSNumber(value: result)) ?? ""
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
