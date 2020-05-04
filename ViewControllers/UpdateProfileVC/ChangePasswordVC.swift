//
//  ChangePasswordVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 11/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var lblTitle: ThemeTitleLabel!
    @IBOutlet weak var lblSubTitle: ThemeDescriptionsLabel!
    @IBOutlet weak var txtOldPassword: ThemeTextField!
    @IBOutlet weak var txtNewPassword: ThemeTextField!
    @IBOutlet weak var btnSave: ThemeButton!
    @IBOutlet weak var btnBackArrow: UIButton!

    // MARK: - Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateStatusBarBackgroundColor()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setLocalization()
    }
    
    func setLocalization()
    {
        lblTitle.text = "Change Password".localized
        lblSubTitle.text = "Enter you new password".localized
        txtNewPassword.placeholder = "Old password".localized
        txtOldPassword.placeholder = "New password".localized
        btnSave.setTitle("Save".localized, for: .normal)
    }
    
    @IBAction func btnSaveClick(_ sender: ThemeButton) {
        
        guard let oldPassword = txtOldPassword.text, oldPassword.count > 0 else {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter your current password".localized) { (index, title) in
            }
            return
        }
        
        guard let newPassword = txtNewPassword.text, newPassword.count > 0 else {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter your new password".localized) { (index, title) in
            }
            return
        }
        
        if newPassword.count >= 8
        {
            changePasswordService(newPassword: newPassword)

        }else
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "New password must contain at least 8 characters".localized) { (index, title) in
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Webservice Methods

extension ChangePasswordVC
{
    func changePasswordService(newPassword : String)
    {
        self.txtNewPassword.text = ""
        self.txtOldPassword.text = ""
       
        var dictData = [String:AnyObject]()
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["Password"] = newPassword as AnyObject
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        webserviceForChangePassword(dictData as AnyObject) { (result, status) in
            
            if (status)
            {
                print(result)
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                UtilityClass.setCustomAlert(title: appName, message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else
            {
                print(result)
            }
        }
        
    }
    
}
