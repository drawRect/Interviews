//
//  CurrencyLoader.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 08/03/23.
//

import Foundation

struct CurrencyLoader {
    typealias fetchRatesResponse = (Result<CurrencyInfo, NetworkError>) -> Void
    typealias getCurrencyListResponse = (Result<[Currency], NetworkError>) -> Void
    
    static func fetchRates(
        base: String,
        manager: NetworkManager = NetworkManager(),
        completion: @escaping fetchRatesResponse
    ) {
        let route =  OpenExchangeRateConstants.fetchRateRoute + "&base=" + base
        guard let url = URL(string: route) else { return }
        manager.makeRequest(
            with: url,
            decode: CurrencyInfo.self,
            completionHandler: { response in
                switch response {
                case let .success(result):
                    completion(.success(result))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    static func getCurrencyList(
        manager: NetworkManager = NetworkManager(),
        completion: @escaping getCurrencyListResponse
    ) {
        guard let url = URL(string: OpenExchangeRateConstants.getCurrencyListRoute) else { return }
        manager.makeRequest(
            with: url,
            decode: [String:String].self,
            completionHandler: { response in
                switch response {
                case let .success(result):
                    let currencies = result.map { (key, value) in
                        Currency(code: key, country: value)
                    }
                    completion(.success(currencies))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
}
