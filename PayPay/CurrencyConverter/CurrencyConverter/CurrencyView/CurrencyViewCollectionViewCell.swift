//
//  CurrencyViewCollectionViewCell.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

import UIKit

class CurrencyViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel! {
        didSet {
            rateLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(currency: Currency) {
        self.symbolLabel.text = currency.code
        self.rateLabel.text = "("+String(currency.rate)+")"
        
        if currency.isSelected {
            self.contentView.backgroundColor = .black
            self.symbolLabel.textColor = .white
            self.rateLabel.textColor = .white
        } else {
            self.contentView.backgroundColor = .white
            self.symbolLabel.textColor = .black
            self.rateLabel.textColor = .black
        }
        
        applyTheme()
    }
    
    private func applyTheme() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }

}
