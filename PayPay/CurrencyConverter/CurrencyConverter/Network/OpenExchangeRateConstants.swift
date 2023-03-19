//
//  OpenExchangeRateConstants.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 08/03/23.
//

import Foundation

struct OpenExchangeRateConstants {
    static let appId = "d2386b56d495492a95241c953f7c4d40"
    static let baseURL = "https://openexchangerates.org/api/"
    
    static var fetchRateRoute: String {
        Self.baseURL + "latest.json?" + "app_id=" + Self.appId
    }
    
    static var getCurrencyListRoute: String {
        Self.baseURL + "currencies.json"
    }
}
