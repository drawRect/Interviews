//
//  CurrencyInfoReader.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 08/03/23.
//

import Foundation

struct CurrencyInfoReader {
    private let infoKey = "currency.info"
    private let expirationDateKey = "currency.expiration.date"
    private let expiresIn30Min = 30*60 //30min
    
    typealias infoBlob = [String: [String: CurrencyInfo]]
    typealias expiresBlob = [String: [String: Date]]
    
    ///one single write base currency info
    ///and its individual expire as well.
    func write(base currencyInfo: CurrencyInfo) {
        writeBase(of: currencyInfo)
        writeExpires(of: currencyInfo)
    }
    
    ///write currency info data
    func writeBase(of currencyInfo: CurrencyInfo) {
        let written = readInfoFromDisk()
        var toWrite: infoBlob = infoBlob()
        if(written[infoKey] == nil && written[currencyInfo.base] == nil) {
            let infoDictionary = [currencyInfo.base: currencyInfo]
            toWrite = [infoKey: infoDictionary]
        } else {
            var persistedInfo = written[infoKey]!
            persistedInfo[currencyInfo.base] = currencyInfo
            toWrite = [infoKey: persistedInfo]
        }
        writeIntoDisk(info: toWrite)
    }
    
    func writeExpires(of currencyInfo: CurrencyInfo) {
        let writtenExpires = readAllExpires()
        var toWriteExpires = expiresBlob()
        if(writtenExpires[expirationDateKey] == nil && writtenExpires[currencyInfo.base] == nil) {
            let expireDictionary = [currencyInfo.base: getExpireDate()]
            toWriteExpires = [expirationDateKey: expireDictionary]
        } else {
            var persistedInfo = writtenExpires[expirationDateKey]!
            persistedInfo[currencyInfo.base] = getExpireDate()
            toWriteExpires = [expirationDateKey: persistedInfo]
        }
        writeIntoDisk(expires: toWriteExpires)
    }
    
    func getExpireDate() -> Date {
        Date().addingTimeInterval(TimeInterval(expiresIn30Min))
    }
    
    func writeIntoDisk(info: infoBlob) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(info)
            UserDefaults.standard.set(data, forKey: infoKey)
        } catch {
            print(error)
        }
    }
    
    func writeIntoDisk(expires: expiresBlob) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(expires)
            UserDefaults.standard.set(data, forKey: expirationDateKey)
        } catch {
            print(error)
        }
    }
    
    func readInfoFromDisk() -> infoBlob {
        guard let all = UserDefaults.standard.data(forKey: infoKey) else {
            return [:]
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(infoBlob.self, from: all)
        } catch {
            return [:]
        }
    }
    
    func read(base: String) -> CurrencyInfo? {
        guard let data = UserDefaults.standard.data(forKey: infoKey) else {
            return nil
        }
        
        if shouldRefreshCurrencyInfo(base: base) {
            clearAll()
            return nil
        } else {
            do {
                let decoder = JSONDecoder()
                let persisted = try decoder.decode(infoBlob.self, from: data)
                return persisted[infoKey]![base]
            } catch {
                print("Unable to Decode currency info (\(error))")
            }
        }
        return nil
    }
    
    func readAllExpires() -> [String: [String: Date]] {
        guard let data = UserDefaults.standard.data(forKey: expirationDateKey) else {
            return [:]
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(expiresBlob.self, from: data)
        } catch {
            print("Unable to Decode currency info (\(error))")
        }
        return [:]
    }
    
    func readExpires(of base: String) -> Date? {
        readAllExpires()[expirationDateKey]?[base] ?? nil
    }
    
    func clearAll() {
        [infoKey,expirationDateKey].forEach({
            UserDefaults.standard.removeObject(forKey: $0)
        })
    }
    
    func shouldRefreshCurrencyInfo(base: String) -> Bool {
        guard let expiresIn = readExpires(of: base) else {
            return false
        }
        return Date() >= expiresIn
    }
}
