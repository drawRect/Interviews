//
//  CurrencyInfoReaderTests.swift
//  CurrencyConverterTests
//
//  Created by BKS-GGS on 09/03/23.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyInfoReaderTests: XCTestCase {
    
    var reader: CurrencyInfoReader!
    var infoModel: CurrencyInfo!
    
    override func setUpWithError() throws {
        reader = CurrencyInfoReader()
        infoModel = CurrencyInfo(disclaimer: "", license: "", timestamp: 1678384606, base: "USD", rates: ["INR": 81.1])
    }

    override func tearDownWithError() throws {
        reader = nil
        infoModel = nil
    }
    
    func testWriteWithBase() {
        reader.clearAll()
        reader.write(base: infoModel)
        
        var infoBlob = reader.readInfoFromDisk()
        XCTAssertTrue(infoBlob.count > 0)
        XCTAssertNotNil(infoBlob["currency.info"])
        
        infoBlob = reader.readInfoFromDisk()
        XCTAssertNotNil(infoBlob)
        XCTAssertNotNil(infoBlob["currency.info"])
        XCTAssertNil(infoBlob[infoModel.base])
    }
    
    func testOverwriteInfo() {
        reader.write(base: infoModel)
        let newInfo = CurrencyInfo(disclaimer: "", license: "", timestamp: 1678384900, base: "USD", rates: ["INR": 81.3])
        reader.write(base: newInfo)
        
        let persisted = reader.read(base: newInfo.base)!
        XCTAssert(persisted.base == newInfo.base)
        XCTAssert(persisted.rates["INR"] == newInfo.rates["INR"])
    }
    
    func testWriteExpires() {
        reader.clearAll()
        let newInfo = CurrencyInfo(disclaimer: "", license: "", timestamp: 1678384900, base: "USD", rates: ["INR": 81.3])
        reader.writeExpires(of: newInfo)
        
        XCTAssertNotNil(reader.readExpires(of: newInfo.base))

        let updatedInfo = CurrencyInfo(disclaimer: "", license: "", timestamp: 1978384900, base: "USD", rates: ["INR": 81.3])
        reader.writeExpires(of: updatedInfo)

        XCTAssertNotNil(reader.readExpires(of: updatedInfo.base))
    }
    
    func testInfoWriteIntoDisk() {
        reader.clearAll()
        let newInfo = CurrencyInfo(disclaimer: "", license: "", timestamp: 1678384900, base: "USD", rates: ["INR": 81.3])
        reader.writeIntoDisk(info: ["currency.info":[newInfo.base: newInfo]])

        XCTAssert(reader.read(base: newInfo.base)!.base == newInfo.base)
    }
    
    func testReadWithBase() {
        reader.clearAll()
        reader.write(base: infoModel)
        
        let persisted = reader.read(base: infoModel.base)!
        XCTAssert(persisted.base == infoModel.base)
    }
    
    func testRead() {
        reader.write(base: infoModel)
        let read = reader.read(base: infoModel.base)!
        XCTAssert(read.disclaimer == infoModel.disclaimer)
        XCTAssert(read.license == infoModel.license)
        XCTAssert(read.timestamp == infoModel.timestamp)
        XCTAssert(read.base == infoModel.base)
        XCTAssert(read.rates == infoModel.rates)
    }
    
    func testClearAll() {
        reader.write(base: infoModel!)
        reader.clearAll()
        XCTAssertNil(UserDefaults.standard.object(forKey: "currency.info"))
        XCTAssertNil(UserDefaults.standard.object(forKey: "currency.expiration.date"))
    }
    
}
