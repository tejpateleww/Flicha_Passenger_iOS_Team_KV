//
//  BaseViewController.swift
//  TanTaxi User
//
//  Created by EWW-iMac Old on 05/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setNavBarWithMenu(Title:String, IsNeedRightButton:Bool)
    {
        //        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = Title.uppercased()
        self.navigationController?.navigationBar.barTintColor = themeYellowColor;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_menu"), style: .plain, target: self, action: #selector(self.OpenMenuAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        if IsNeedRightButton == true {
            //            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            //            self.navigationItem.rightBarButtonItem = nil
            //            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func setNavBarWithBack(Title:String, IsNeedRightButton:Bool)
    {
        //        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = Title.uppercased().localizedUppercase
        self.navigationController?.navigationBar.barTintColor = themeBlueColor;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "iconBack"), style: .plain, target: self, action: #selector(self.btnBackAction))
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        if IsNeedRightButton == true {
            //            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            //            self.navigationItem.rightBarButtonItem = nil
            //            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        if UserDefaults.standard.value(forKey: "i18n_language") != nil {
            if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if language == "sw" {
                    //                    btnLeft.semanticContentAttribute = .forceLeftToRight
                    
                    //                    image = UIImage.init(named: "icon_BackWhite")?.imageFlippedForRightToLeftLayoutDirection()
                }
            }
        }
        
    }
    
    var hasTopNotch: Bool {
     
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }else{
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
    
    func addCustomNavigationBar(title : String)
    {
        let containerView = UIView()
        containerView.backgroundColor = themeBlueColor
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.roundCorners(with: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 25)
        
        let leftView = UIView()
        //leftView.backgroundColor = .red
        leftView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerView = UIView()
        //centerView.backgroundColor = .green
        centerView.translatesAutoresizingMaskIntoConstraints = false
        
        let rightView = UIView()
        //rightView.backgroundColor = .yellow
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [leftView,centerView,rightView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.translatesAutoresizingMaskIntoConstraints = false
        leftBarButton.setImage(UIImage.init(named: "iconBack"), for: .normal)
        leftBarButton.contentMode = .scaleAspectFit
        leftBarButton.addTarget(self, action: #selector(self.btnBackAction), for: .touchUpInside)
        leftView.addSubview(leftBarButton)
        
        let lblTitle = UILabel()
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.numberOfLines = 0
        lblTitle.textAlignment = .center
        lblTitle.textColor = .white
        lblTitle.text = title
        lblTitle.font = UIFont.semiBold(ofSize: 14)
        centerView.addSubview(lblTitle)
        
        var heightConstant : NSLayoutConstraint!
        
        if self.hasTopNotch
        {
            heightConstant = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100+20)
        }else
        {
            heightConstant = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        }
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            heightConstant,
            
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 64),
            
            leftView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
            leftBarButton.centerXAnchor.constraintEqualToSystemSpacingAfter(leftView.centerXAnchor, multiplier: 0.1),
            leftBarButton.centerYAnchor.constraintEqualToSystemSpacingBelow(leftView.centerYAnchor, multiplier: 1),
            leftBarButton.heightAnchor.constraint(equalTo: leftView.heightAnchor, constant: 0),
            leftBarButton.heightAnchor.constraint(equalTo: leftView.widthAnchor, constant: 0),
            
            rightView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
            
            lblTitle.leftAnchor.constraint(equalTo: centerView.leftAnchor,constant: 2),
            lblTitle.rightAnchor.constraint(equalTo: centerView.rightAnchor, constant: -2),
            lblTitle.centerYAnchor.constraintEqualToSystemSpacingBelow(centerView.centerYAnchor, multiplier: 1)
        ])
        
        containerView.layoutIfNeeded()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addCustomNavigationBarWithRightButton(title : String, imageName : String, handler: (target: Any, action: Selector))
    {
        let containerView = UIView()
        containerView.backgroundColor = themeBlueColor
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.roundCorners(with: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 25)
        
        let leftView = UIView()
        //leftView.backgroundColor = .red
        leftView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.translatesAutoresizingMaskIntoConstraints = false
        leftBarButton.setImage(UIImage.init(named: "iconBack"), for: .normal)
        leftBarButton.contentMode = .scaleAspectFit
        leftBarButton.addTarget(self, action: #selector(self.btnBackAction), for: .touchUpInside)
        leftView.addSubview(leftBarButton)
        
        let centerView = UIView()
        //centerView.backgroundColor = .green
        centerView.translatesAutoresizingMaskIntoConstraints = false
       
        let lblTitle = UILabel()
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.numberOfLines = 0
        lblTitle.textAlignment = .center
        lblTitle.textColor = .white
        lblTitle.text = title
        lblTitle.font = UIFont.semiBold(ofSize: 14)
        centerView.addSubview(lblTitle)
        
        let rightView = UIView()
        //rightView.backgroundColor = .yellow
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        let rightBarButton = UIButton(type: .custom)
        rightBarButton.translatesAutoresizingMaskIntoConstraints = false
        rightBarButton.setImage(UIImage.init(named: imageName), for: .normal)
        rightBarButton.contentMode = .scaleAspectFit
        rightBarButton.addTarget(handler.target , action: handler.action, for: .touchUpInside)
        rightView.addSubview(rightBarButton)
        
        let stackView = UIStackView(arrangedSubviews: [leftView,centerView,rightView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
    
        
        var heightConstant : NSLayoutConstraint!
        
        if self.hasTopNotch
        {
            heightConstant = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100+20)
        }else
        {
            heightConstant = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        }
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            heightConstant,
            
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 64),
            
            leftView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
        leftBarButton.centerXAnchor.constraintEqualToSystemSpacingAfter(leftView.centerXAnchor, multiplier: 0.1),
        leftBarButton.centerYAnchor.constraintEqualToSystemSpacingBelow(leftView.centerYAnchor, multiplier: 1),
            leftBarButton.heightAnchor.constraint(equalTo: leftView.heightAnchor, constant: 0),
            leftBarButton.heightAnchor.constraint(equalTo: leftView.widthAnchor, constant: 0),
            
            rightView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.2),
        rightBarButton.centerXAnchor.constraintEqualToSystemSpacingAfter(rightView.centerXAnchor, multiplier: 0.1),
        rightBarButton.centerYAnchor.constraintEqualToSystemSpacingBelow(rightView.centerYAnchor, multiplier: 1),
            rightBarButton.heightAnchor.constraint(equalTo: rightView.heightAnchor, constant: 0),
            rightBarButton.heightAnchor.constraint(equalTo: rightView.widthAnchor, constant: 0),
            
            lblTitle.leftAnchor.constraint(equalTo: centerView.leftAnchor,constant: 2),
            lblTitle.rightAnchor.constraint(equalTo: centerView.rightAnchor, constant: -2),
         lblTitle.centerYAnchor.constraintEqualToSystemSpacingBelow(centerView.centerYAnchor, multiplier: 1)
        ])
        
        containerView.layoutIfNeeded()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:- Navigation Bar Button Action Methods
    
    @objc func OpenMenuAction()
    {
         sideMenuController?.toggle()
    }
    
    @objc func btnBackAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCallAction()
    {
        let contactNumber = helpLineNumber
        if contactNumber == ""
        {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    private func callNumber(phoneNumber:String)
    {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
}



