//
//  GoCommon.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import Foundation
import UIKit

/******** UITableViewCell<Extension> *******************************/
protocol CellConfigurer:class {
    static var nib: UINib {get}
    static var reuseIdentifier: String {get}
}

extension CellConfigurer {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    static var reuseIdentifier: String{
        return String(describing: self)
    }
}

extension UITableViewCell: CellConfigurer {}


protocol ViewConfigurer:class {
    static var identifier: String {get}
}

extension ViewConfigurer {
    static var identifier: String{
        return String(describing: self)
    }
}

extension UIViewController: ViewConfigurer {}
