//
//  PrimaryButton.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/4/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit

class OnTheMapButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        tintColor = UIColor.primaryDark
    }
}

