//
//  ThemeButton.swift
//  TanTaxi User
//
//  Created by EWW-iMac Old on 03/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {

    @IBInspectable public var isSubmitButton: Bool = false
    @IBInspectable public var NoNeedBackground: Bool = false
    
    override func awakeFromNib()
    {
        self.titleLabel?.font = UIFont.semiBold(ofSize: 12.0)
//        self.backgroundColor = themeYellowColor
        self.setBackgroundImage(UIImage(named: "yellowButton"), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.setTitleColor(UIColor.black, for: .normal)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true
    }
}


