//
//  GoContactEditHeaderView.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import UIKit

protocol ProfilePicEditAction:class {
    func didTapAddProfilePic()
}

class GoContactEditHeaderView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    public weak var delegate: ProfilePicEditAction?

    class func instanceFromNib() -> GoContactEditHeaderView {
        let view = UINib(nibName: "GoContactEditHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GoContactEditHeaderView
        view.applyGradient()
        return view
    }

    func populate(contact: GoContact) {
        profileImageView.setImage(url: GoNetworkHelper.baseURL+contact.profilePic, style: .rounded, completion: nil)
    }

    @IBAction func didTapProfilePicBtn(_ sender: Any) {
        self.delegate?.didTapAddProfilePic()
    }

}
