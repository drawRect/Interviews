//
//  GoContactDetailsHeaderView.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import UIKit

protocol HeaderViewBtnActions:class {
    func didTapAction()
    func didTapFavAction()
}

class GoContactDetailsHeaderView: UIView {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    public weak var delegate:HeaderViewBtnActions?
    @IBOutlet weak var profilePicImageView: UIImageView!
    var contact:GoContact!

    class func instanceFromNib() -> GoContactDetailsHeaderView {
        let view = UINib(nibName: "GoContactDetailsHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GoContactDetailsHeaderView
        view.applyGradient()
        return view
    }
    
    func populate(contact:GoContact) {
        self.contact = contact
        nameLbl.text = contact.name
        profilePicImageView.setImage(url: GoNetworkHelper.baseURL+contact.profilePic, style: .rounded, completion: nil)

        if self.contact.favorite {
            self.favBtn.setImage(UIImage(named: "home_favourite"), for: .normal)
        }else {
            self.favBtn.setImage(UIImage(named: "favourite_button"), for: .normal)
        }
    }

    @IBAction func didTapMessage(_ sender: Any) {
        self.delegate?.didTapAction()
    }

    @IBAction func didTapCall(_ sender: Any) {
        self.delegate?.didTapAction()
    }

    @IBAction func didTapEmail(_ sender: Any) {
        self.delegate?.didTapAction()
    }


    @IBAction func didTapFav(_ sender: Any) {
        self.contact.favorite = !self.contact.favorite
        if self.contact.favorite {
            self.favBtn.setImage(UIImage(named: "home_favourite"), for: .normal)
        }else {
            self.favBtn.setImage(UIImage(named: "favourite_button"), for: .normal)
        }
        self.delegate?.didTapFavAction()
    }

}



