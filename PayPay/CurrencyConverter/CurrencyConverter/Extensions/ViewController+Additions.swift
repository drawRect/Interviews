//
//  ViewController+Additions.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

import UIKit

extension UIViewController {
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        instantiateFromStoryboardHelper(name)
    }

    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
        return controller
    }
}
