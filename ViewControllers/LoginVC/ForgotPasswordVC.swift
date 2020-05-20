//
//  ForgotViewController.swift
//  Flicha User
//
//  Created by EWW071 on 20/05/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ForgotPasswordVC: BaseViewController {

    @IBOutlet weak var lblTitle: ThemeTitleLabel!
    @IBOutlet weak var lblSubTitle: ThemeDescriptionsLabel!
    @IBOutlet weak var txtEmail: ThemeTextField!
    @IBOutlet weak var btnSend: ThemeButton!
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
        txtEmail.placeholder = "Email Address".localized
        btnSend.setTitle("Send".localized, for: .normal)
    }
    
    @IBAction func btnSaveClick(_ sender: ThemeButton) {
        
        guard let userEmail = txtEmail.text, userEmail.count > 0 else {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter your registered email address".localized) { (index, title) in
            }
            return
        }
        
        webserviceCallForForgotPassword(strEmail: userEmail)

    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Webservice Methods

extension ForgotPasswordVC
{
    
    func webserviceCallForForgotPassword(strEmail : String)
    {
        let dictparam = NSMutableDictionary()
        dictparam.setObject(strEmail, forKey: "MobileNo" as NSCopying)
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        webserviceForForgotPassword(dictparam) { (result, status) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                UtilityClass.setCustomAlert(title: "Success", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
            else
            {
                
                UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
        }
    }
    
}

