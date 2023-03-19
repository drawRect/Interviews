//
//  CurrencyListViewModel.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 07/03/23.
//

import Foundation

class CurrencyListViewModel {
    private var dataSource: [Currency] = []
    var completion: (() -> Void)?
    
    func loadCurrenyList() {
        CurrencyLoader.getCurrencyList(
            manager: NetworkManager(),
            completion: {[weak self] response in
                switch response {
                case let .success(result):
                    self?.dataSource = result
                    self?.completion?()
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        )
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        dataSource.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> Currency {
        dataSource[indexPath.row]
    }
    
}
