//
//  ThemeTextField.swift
//  TanTaxi User
//
//  Created by EWW-iMac Old on 03/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class ThemeTextField: UITextField {

    @IBInspectable public var isLeftViewNeeded: Bool = false
    @IBInspectable public var isBorderNeeded: Bool = false
    @IBInspectable public var LeftImage: UIImage = UIImage()
    
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
        self.background = UIImage(named: "bgRoundCorner")
        self.contentMode = .scaleAspectFit
        
        //To apply padding
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
        self.rightView = paddingView
        self.rightViewMode = UITextFieldViewMode.always
        
//
//        //To apply corner radius
//        self.layer.cornerRadius = self.frame.size.height / 2
//
//        //To apply border
//        self.layer.borderWidth = 0.25
//        self.layer.borderColor = UIColor.white.cgColor
//
//        //To apply Shadow
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 3.0
//        self.layer.shadowOffset = CGSize.zero // Use any CGSize
//        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    
//    override func awakeFromNib() {
//        self.font = UIFont.regular(ofSize: 13.0)
//        self.textColor = UIColor.black
//        self.backgroundColor = UIColor.white
//        self.setValue(UIColor.black , forKeyPath: "placeholderLabel.textColor")
//
//        if isLeftViewNeeded == true {
//            self.SetLeftViewImage(Image: LeftImage)
//        }
//        else {
//            let LeftView = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: 40.0))
//            LeftView.backgroundColor = UIColor.clear
//            self.leftView = LeftView
//            self.leftViewMode = .always
//        }
//
//        if isBorderNeeded == true {
//            let border = CALayer()
//            let width = CGFloat(1.0)
//            border.borderColor = UIColor.lightGray.cgColor
//            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: UIScreen.main.bounds.width - 20.0 , height: self.frame.size.height)
//
//            border.borderWidth = width
//            self.layer.addSublayer(border)
//            self.layer.masksToBounds = true
//        }
//    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UITextField {
    
    func SetLeftViewImage(Image:UIImage) {
        let LeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
        LeftView.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(frame: CGRect(x: 5.0, y: 5.0, width: 30.0, height: 30.0));
        imageView.backgroundColor = UIColor.clear
        imageView.image = Image
        LeftView.addSubview(imageView)
        
        self.leftView = LeftView
        self.leftViewMode = .always
    }
}
