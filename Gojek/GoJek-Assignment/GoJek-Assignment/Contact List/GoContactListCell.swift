//
//  GoContactListCell.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 11/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import UIKit

class GoContactListCell: UITableViewCell {
    
    @IBOutlet weak var profileImageVew: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
