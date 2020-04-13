//
//  ThemeFormTextField.swift
//  Flicha User
//
//  Created by Mehul Panchal on 12/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit
import FormTextField

class ThemeFormTextField: FormTextField {

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
        self.font = UIFont.regular(ofSize: 13.0)
        self.text = ""
        self.textColor = UIColor.black
        self.borderStyle = .none
        self.backgroundColor = UIColor.white
        self.contentMode = .scaleAspectFit
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
        self.rightView = paddingView
        self.rightViewMode = UITextFieldViewMode.always
        
        //To apply corner radius
        self.layer.cornerRadius = self.frame.size.height / 2
        
        //To apply border
        self.layer.borderWidth = 0.25
        self.layer.borderColor = themeBlueLightColor.cgColor
    }
    
}
