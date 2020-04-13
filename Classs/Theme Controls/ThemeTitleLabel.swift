//
//  ThemeTitleLabel.swift
//  Flicha User
//
//  Created by Mehul Panchal on 10/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class ThemeTitleLabel: UILabel {

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
        self.font = UIFont.bold(ofSize: 25.0)
        self.text = ""
        self.numberOfLines = 0
        self.textColor = UIColor.white
    }
    
}
