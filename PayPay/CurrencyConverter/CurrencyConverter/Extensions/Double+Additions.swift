//
//  Double+Additions.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 07/03/23.
//

import Foundation

extension Double {
    func convertInToTwoDecimalPoints(_ digits: Int = 2) -> Double {
        let divisor = pow(10.0, Double(digits))
        return (self * divisor).rounded() / divisor
    }
}
