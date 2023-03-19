//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

protocol CurrencyViewModifier: AnyObject {
    func currencyLoaded()
    func scrollCollectionViewAt(index: Int)
    func update(_ output: String)
    func reload(items: [Int])
    func showAlertOn(error: NetworkError)
}

final class CurrencyViewModel {
    
    private var currencies: [Currency]
    private var currentCurrency: Currency!
    weak var delegate: CurrencyViewModifier?
    private var output: Double = 0.0
    private let currencyReader: CurrencyInfoReader
    private var baseCurrency: CurrencyInfo!
    
    /// currently we are using free edition of ExchangeRatesApi
    /// for this it only supports for USD conversion.
    private var supportedCode = "USD"
    
    /// currently we are giving Japan as selected currency of phone.
    /// this might be changed in future, as per the phone currency we can enable it
    private var JPYCode = "JPY"
    
    init(currencies: [Currency] = []) {
        self.currencies = currencies
        self.currencyReader = CurrencyInfoReader()
    }
    
    func loadCurrencyRatesIfValid() {
        guard isRefreshNeeded() else {
            return
        }
        fetchRates {[weak self] currencies in
            self?.currencies = currencies
            self?.delegate?.currencyLoaded()
        }
    }
    
    func fetchRates(completion: (@escaping ([Currency]) -> Void)) {
        CurrencyLoader.fetchRates(
            base: supportedCode,
            manager: NetworkManager(),
            completion: {[weak self] response in
                switch response {
                case let .success(result):
                    self?.baseCurrency = result
                    completion(result.currencies)
                    self?.write(result)
                case let .failure(error):
                    print(error)
                    self?.delegate?.showAlertOn(error: error)
                    completion([])
                }
            }
        )
    }
    
    func isRefreshNeeded() -> Bool {
        if let currencyInfo = read() {
            self.currencies = currencyInfo.currencies
            self.delegate?.currencyLoaded()
            return false
        }
        return true
    }
    
    func numberOfCurrencies() -> Int {
        currencies.count
    }
    
    ///choosing a new currrency:
    ///first we have to deselect current one
    ///and enable new one
    ///and reload both cells
    func chooseNewCurrency(at index: Int) {
        //disable current currency
        currentCurrency.toggle()
        let oldIndex = getIndex(of: currentCurrency)!
        
        //select new Index
        let newCurrency = currencies[index]
        set(currency: newCurrency)
        
        self.delegate?.reload(items: [oldIndex, index])
    }
    
    func get(index: Int) -> Currency {
        currencies[index]
    }
    
    ///set the currency and make it selected
    func set(currency: Currency) {
        currency.toggle()
        currentCurrency = currency
        self.delegate?.update(outputString)
    }
    
    func getCurrent() -> Currency? {
        currentCurrency
    }
    
    ///setting the symbol(ie.JPY)
    ///and make it selected
    ///scroll newly selected item cell in the collectionview
    ///updating the output label string
    func set(symbol: String) {
        guard let currency = currencies.filter({$0.code == symbol}).first else {
            return
        }
        set(currency: currency)
        
        let index = getIndex(of: currency)!
        delegate?.scrollCollectionViewAt(index: index)
        
        delegate?.update(outputString)
    }
    
    var outputString: String {
        let value = output.convertInToTwoDecimalPoints()
        return String(value) + " " + currentCurrency.code
    }
    
    func getIndex(of: Currency) -> Int? {
        currencies.firstIndex(of: of)
    }
    
    func convert(_ input: Double) {
        output = input * currentCurrency.rate
        self.delegate?.update(outputString)
    }
    
    func setSupported(code: String) {
        supportedCode = code
    }
    
    var phoneCurrencyCode: String {
        JPYCode
    }
}

extension CurrencyViewModel {
    
    func write(_ currencyInfo: CurrencyInfo) {
        currencyReader.write(base: currencyInfo)
    }
    
    func read() -> CurrencyInfo? {
        guard let info = currencyReader.read(base: supportedCode) else {
            // It expired, go and fetch the currency rates
            return nil
        }
        // It still valid, so use persisted one
        return info
    }
    
    func clearUserDefaults() {
        currencyReader.clearAll()
    }
}
