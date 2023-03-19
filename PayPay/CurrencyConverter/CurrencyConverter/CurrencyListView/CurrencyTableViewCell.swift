//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 07/03/23.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(currency: Currency) {
        self.currencyLabel.text = currency.country ?? "Unknown"
        self.symbolLabel.text = currency.code
    }
    
}
