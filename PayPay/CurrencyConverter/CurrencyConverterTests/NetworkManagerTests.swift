//
//  NetworkManagerTests.swift
//  CurrencyConverterTests
//
//  Created by BKS-GGS on 08/03/23.
//

import XCTest
@testable import CurrencyConverter

class NetworkSessionMock: NetworkSession {
    private(set) var requestUrl: URL?
    
    var data: Data?
    var error: Error?
    
    func loadData(with urlRequest: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        requestUrl = urlRequest.url
        completionHandler(data, error)
    }
}

final class NetworkManagerTests: XCTestCase {

    func testSuccessfullLoadCurrencyRates() {
        let mockData = MockJsonLoader.usdRatesData

        let networkSession = NetworkSessionMock()
        networkSession.data = mockData
        networkSession.error = nil

        let networkManager = NetworkManager(session: networkSession)

        var expectedResults: CurrencyInfo?
        var expectedError: Error?

        CurrencyLoader.fetchRates(
            base: "USD",
            manager: networkManager,
            completion: { response in
                switch response {
                case let .success(result):
                    expectedResults = result
                case let .failure(error):
                    expectedError = error
                }
            }
        )

        let expectedRequestUrl = URL(string: "https://openexchangerates.org/api/latest.json?app_id=d2386b56d495492a95241c953f7c4d40&base=USD")

        XCTAssert(networkSession.requestUrl == expectedRequestUrl)
        XCTAssertNotNil(expectedResults)
        XCTAssertNil(expectedError)
    }
    
    func testFailLoadCurrencyRates() {
        let networkSession = NetworkSessionMock()
        networkSession.data = nil
        networkSession.error = NSError(domain: "", code: 403)

        let networkManager = NetworkManager(session: networkSession)

        var expectedResults: CurrencyInfo?
        var expectedError: Error?

        CurrencyLoader.fetchRates(
            base: "USD",
            manager: networkManager,
            completion: { response in
                switch response {
                case let .success(result):
                    expectedResults = result
                case let .failure(error):
                    expectedError = error
                }
            }
        )
        let invalidSymbol = "U"
        let expectedRequestUrl = URL(string: "https://openexchangerates.org/api/latest.json?app_id=d2386b56d495492a95241c953f7c4d40&\(invalidSymbol)")

        XCTAssertNotEqual(networkSession.requestUrl, expectedRequestUrl)
        XCTAssertNil(expectedResults)
        XCTAssertNotNil(expectedError)
    }
    
    
    func testSuccessfullCurrencyList() {
        guard let mockData = MockJsonLoader.currencyListData else {
            fatalError()
        }

        let networkSession = NetworkSessionMock()
        networkSession.data = mockData
        networkSession.error = nil

        let networkManager = NetworkManager(session: networkSession)

        var expectedResults: [Currency]?
        var expectedError: Error?

        CurrencyLoader.getCurrencyList(
            manager: networkManager,
            completion: { response in
                switch response {
                case let .success(result):
                    expectedResults = result
                case let .failure(error):
                    expectedError = error
                }
            }
        )

        let expectedRequestUrl = URL(string: "https://openexchangerates.org/api/currencies.json")

        XCTAssert(networkSession.requestUrl == expectedRequestUrl)
        XCTAssertNotNil(expectedResults)
        XCTAssertNil(expectedError)
    }
    
    func testFailCurrencyList() {
      
        let networkSession = NetworkSessionMock()
        networkSession.data = nil
        networkSession.error = nil

        let networkManager = NetworkManager(session: networkSession)

        var expectedResults: [Currency]?
        var expectedError: Error?

        CurrencyLoader.getCurrencyList(
            manager: networkManager,
            completion: { response in
                switch response {
                case let .success(result):
                    expectedResults = result
                case let .failure(error):
                    expectedError = error
                }
            }
        )

        let expectedRequestUrl = URL(string: "https://openexchangerates.org/api/currencies.json")

        XCTAssert(networkSession.requestUrl == expectedRequestUrl)
        XCTAssertNil(expectedResults)
        XCTAssertNotNil(expectedError)
    }

}
