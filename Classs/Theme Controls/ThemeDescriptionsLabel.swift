//
//  ThemeDescriptionsLabel.swift
//  Flicha User
//
//  Created by Mehul Panchal on 10/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class ThemeDescriptionsLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTheme()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupTheme()
    }
    
    func setupTheme()
    {
        self.font = UIFont.semiBold(ofSize: 13.0)
        self.text = ""
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.textColor = themeGrayTextColor
    }

}
