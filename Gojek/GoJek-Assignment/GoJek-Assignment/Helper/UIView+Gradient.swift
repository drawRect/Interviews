//
//  UIView+Gradient.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 12/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyGradient() {
        let gradientView = UIView(frame: CGRect(x: 0, y: 60, width: self.frame.size.width, height: self.frame.size.height-60))
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = gradientView.frame.size
        gradientLayer.colors =
            [UIColor.white.cgColor,GoConstants.themeColor.withAlphaComponent(0.65).cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        self.addSubview(gradientView)
        self.sendSubviewToBack(gradientView)
    }
}
