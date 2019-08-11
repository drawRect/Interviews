//
//  VariantCell.swift
//  SwiggyAssignment
//
//  Created by Ranjith Kumar on 3/16/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import UIKit

class VariantCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var isVegLbl: UILabel!
    @IBOutlet weak var inStockLbl: UILabel!

    var variantion: Variation! {
        didSet {
            self.nameLbl.text = variantion.name
            self.priceLbl.text = "Rs."+variantion.price.description
            self.isVegLbl.textColor = variantion.isVeg == 1 ? .green : .red
            self.inStockLbl.textColor = variantion.inStock == 1 ? .green : .red
            if variantion.inStock == 0 {
                self.contentView.isUserInteractionEnabled = false
                self.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            }else {
                self.contentView.isUserInteractionEnabled = true
                self.contentView.backgroundColor = UIColor.white
            }
        }
    }

    static var identifier: String {
        return "VariantCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isVegLbl.text = "isVeg"
        inStockLbl.text = "inStock"
    }

}
