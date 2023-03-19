//
//  Currency.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

import Foundation

class Currency {
    
    let code: String
    let rate: Double
    var country: String?
    
    private(set) var isSelected = false
    
    init(code: String, rate: Double) {
        self.code = code
        self.rate = rate
    }
    
    convenience init(code: String, country: String) {
        self.init(code: code, rate: 0.0)
        self.country = country
    }
    
    func toggle() {
        isSelected = !isSelected
    }
}

extension Currency: Equatable {
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        lhs.code == rhs.code
    }
}
