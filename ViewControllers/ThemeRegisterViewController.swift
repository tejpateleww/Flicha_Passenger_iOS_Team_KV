//
//  ThemeRegisterViewController.swift
//  Flicha User
//
//  Created by EWW082 on 02/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class ThemeRegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //self.setTopImage()
        // Do any additional setup after loading the view.
    }
        
    func setTopImage()
    {
//        let TopView = UIView()
//        TopView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200.0)
        
        let TopImgView = UIImageView()
        TopImgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width + 40, height: 250)
        TopImgView.image = #imageLiteral(resourceName: "loginBg")
        
//        TopView.addSubview(TopImgView)
        self.view.addSubview(TopImgView)
        self.view.sendSubview(toBack: TopImgView)
        
        let AppIcon = UIImageView(frame: CGRect(x: 30, y: 55, width: 100, height: 100))
        AppIcon.image = #imageLiteral(resourceName: "loginLogo")
        
        self.view.addSubview(AppIcon)
    }
    
    func setTitle(Title:String, Description:String) {
        
        let labelWidth =  UIScreen.main.bounds.size.width * 0.75
        let lblTopTitle = UILabel(frame: CGRect(x: 30, y: 160, width: labelWidth - 30,height: 25))
        lblTopTitle.font = UIFont.bold(ofSize: 25.0)
        lblTopTitle.text = Title
        lblTopTitle.textColor = UIColor.white
        
        let lblDescription = UILabel(frame: CGRect(x: 30, y: 185, width: labelWidth - 30,height: 40))
        lblDescription.font = UIFont.bold(ofSize: 17.0)
        lblDescription.text = Description
        lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.numberOfLines = 2
        lblDescription.textColor = UIColor.white
        
        self.view.addSubview(lblTopTitle)
        self.view.addSubview(lblDescription)
//        let lblTopDesc = UILabel(frame: CGRect(x: 30, y: 175, width: CGFloat( UIScreen.main.bounds.size.width * 0.75), height: 50)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
