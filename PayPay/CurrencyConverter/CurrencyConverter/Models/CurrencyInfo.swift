//
//  CurrencyInfo.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

import Foundation

struct CurrencyInfo: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
    
    var currencies: [Currency] {
        rates.map { Currency(
            code: $0,
            rate: $1.convertInToTwoDecimalPoints()
        )}
    }
}
