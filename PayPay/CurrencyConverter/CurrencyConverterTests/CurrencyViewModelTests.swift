//
//  CurrencyViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by BKS-GGS on 08/03/23.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyViewModelTests: XCTestCase {
    
    var viewModel: CurrencyViewModel!
    let currencyRates = [Currency(code: "INR", rate: 81.1),
                         Currency(code: "JPY", rate: 137.7608),
                         Currency(code: "KES", rate: 128.6)]

    override func setUpWithError() throws {
        viewModel = CurrencyViewModel(currencies: currencyRates)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testLoadDefaultCurrencyRates() {
        viewModel.clearUserDefaults()
        let currentTime = Int(Date().timeIntervalSince1970)
        let currentPlus30Min = currentTime+1800
        let currencyInfo = CurrencyInfo(disclaimer: "", license: "", timestamp: currentPlus30Min, base: "USD", rates: ["INR": 81.1, "JPY": 137.7608, "KES":128.6])
        XCTAssert(viewModel.numberOfCurrencies() == currencyRates.count)
        viewModel.write(currencyInfo)
        XCTAssertFalse(viewModel.isRefreshNeeded())
    }
    
    func testLoadCurrencyRatesIfValid() {
        viewModel.clearUserDefaults()
        XCTAssertTrue(viewModel.isRefreshNeeded())
        
        let expectation = XCTestExpectation(description: #function)
        viewModel.fetchRates { currencies in
            XCTAssertNotNil(currencies)
            XCTAssertTrue(currencies.count > 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testFetchRates() {
        let expectation = XCTestExpectation(description: #function)
        viewModel.setSupported(code: "INR")
        viewModel.fetchRates { currencies in
            XCTAssertNotNil(currencies)
            XCTAssertTrue(currencies.count == 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testIsRefreshNeeded() {
        viewModel = CurrencyViewModel()
        viewModel.clearUserDefaults()
        let currentTime = Int(Date().timeIntervalSince1970)
        let currentMinus30Min = currentTime-1800
        XCTAssertTrue(currentTime >= currentMinus30Min)

        let currencyInfo = CurrencyInfo(disclaimer: "", license: "", timestamp: currentMinus30Min, base: "USD", rates: ["INR": 81.1, "JPY": 137.7608, "KES":128.6])
        
        let expiredDate = Date().addingTimeInterval(-2800)
        let expired = ["currency.expiration.date":[currencyInfo.base: expiredDate]]
        let encoder = JSONEncoder()
        let data = try! encoder.encode(expired)
        UserDefaults.standard.set(data, forKey: "currency.expiration.date")

        XCTAssertTrue(viewModel.isRefreshNeeded())
        XCTAssert(viewModel.numberOfCurrencies() == 0)
    }
    
    func testSetSymbol() {
        //success case
        let japan = currencyRates[1]
        viewModel.set(symbol: japan.code)
        let index = viewModel.getIndex(of: japan)
        XCTAssert(1 == index)
        XCTAssert(viewModel.outputString == "0.0 JPY")

        //failure case
        let indianSymbol = "INR"
        viewModel.set(symbol: indianSymbol)
        XCTAssertFalse(viewModel!.outputString != "0.0 INR")
    }

    func testSetCurrency() {
        let currency = currencyRates.randomElement()!
        viewModel.set(currency: currency)
        XCTAssertTrue(currency.isSelected)
        XCTAssert(currency == viewModel.getCurrent())
    }
    
    func testGetCurrencyIndex() {
        let currency = currencyRates[2]
        let index = viewModel.getIndex(of: currency)
        XCTAssert(2 == index)
    }
    
    func testGetCurrent() {
        let currency = currencyRates.randomElement()!
        viewModel.set(currency: currency)
        XCTAssertEqual(currency, viewModel!.getCurrent())
    }
    
    func testGetIndex() {
        let currency = viewModel.get(index: 2)
        XCTAssert(currency == currencyRates[2])
    }
    
    func testConvert() {
        let random = currencyRates.randomElement()!
        viewModel.set(currency: random)
        let input: Double = 102
        viewModel.convert(input)
        let randomOutput = (random.rate * input).convertInToTwoDecimalPoints()
        XCTAssert(viewModel.outputString == String(randomOutput) + " " + random.code)
    }
    
    //KES -> INR
    func testChooseNewCurrency() {
        let kes = currencyRates[2]
        viewModel.set(currency: kes)

        let inr = currencyRates[0]
        viewModel.chooseNewCurrency(at: 0)

        XCTAssertFalse(kes.isSelected)
        XCTAssertTrue(inr.isSelected)
        
        let oldIndex = viewModel.getIndex(of: kes)
        let newIndex = viewModel.getIndex(of: inr)
        
        XCTAssert([oldIndex, newIndex] == [2,0])
    }
    
    func testTwoDecimalPoints() {
        let value: Double = 143.35363.convertInToTwoDecimalPoints()
        XCTAssertEqual(value, 143.35)
    }
    
}
