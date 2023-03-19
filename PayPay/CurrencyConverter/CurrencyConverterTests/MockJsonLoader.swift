//
//  MockJsonLoader.swift
//  CurrencyConverterTests
//
//  Created by BKS-GGS on 08/03/23.
//

import XCTest

class MockJsonLoader {
    static var usdRatesData: Data? { return jsonData("USDRates") }
    static var currencyListData: Data? { return jsonData("Currencies")}
    
    private static func jsonData(_ filename: String) -> Data? {
        do {
            guard let path = Bundle(for: self).path(forResource: filename, ofType: "json") else {
                return nil
            }
            let jsonString = try String(contentsOfFile: path, encoding: .utf8)
            return jsonString.data(using: .utf8)!
        }
        catch {
            print(error)
            return nil
        }
    }
}
