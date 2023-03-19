//
//  UICollectionView+Additions.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

import UIKit

extension UICollectionView {
    func registerNib(with identifier: String) {
        self.register(UINib(nibName: identifier, bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeCell<T>(cellClass : T.Type, indexPath: IndexPath) -> T where T: UICollectionViewCell {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
