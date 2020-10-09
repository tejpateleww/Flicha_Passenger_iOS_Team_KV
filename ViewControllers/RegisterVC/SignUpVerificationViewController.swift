//
//  SignUpVerificationViewController.swift
//  Flicha User
//
//  Created by EWW074 on 13/06/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

protocol SignupRemotely : class {
    func signInAfterOTP(_ data: NSMutableDictionary, img : UIImage)
}

class SignUpVerificationViewController: UIViewController {
    
    
    //MARK:- Outlets:
    
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet weak var lbl_HeaderOne: ThemeTitleLabel!
    @IBOutlet weak var lbl_HeaderTwo: ThemeDescriptionsLabel!
    
    @IBOutlet weak var txtField_OTP: ThemeTextField!
    @IBOutlet weak var btn_VerifyOTP: ThemeButton!
    
    @IBOutlet weak var btn_ResendOTP: UIButton!
    
    //MARK:- Properties:
    
    var email : String = ""
    var mobile : String = ""
    var validOTP_FromWebService = 0
    var delegate : SignupRemotely?
    var dict = NSMutableDictionary()
    var userImg = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = SignUpViewController()
        
        setupView()
        WebserviceOtpForRegister(msg: false)

        // Do any additional setup after loading the view.
    }
    

    //MARK:- Event:
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction_ResendOTP(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet() {
            WebserviceOtpForRegister(msg: true)
        } else {
            UtilityClass.setCustomAlert(title: appName, message: "No Internet connection".localized) { (index, title) in
                //
            }
        }
        
    }
    
    
    @IBAction func btnAction_VerifyOTP(_ sender: Any) {
        
        guard let enteredOTP = txtField_OTP.text, enteredOTP.count > 0 else {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "OTP can not be blank".localized) { (index, title) in
            }
            return
        }
        
        if Connectivity.isConnectedToInternet() {
            
            let valid_otp : String = "\(validOTP_FromWebService)"
            if enteredOTP == valid_otp {
                // Delegate method to notify signup vc to call webservice for signup
                
                delegate?.signInAfterOTP(dict, img: userImg)
                
                self.navigationController?.popToRootViewController(animated: true)
                
            } else {
                UtilityClass.setCustomAlert(title: "Invalid OTP!!".localized, message: "Please enter a valid OTP".localized) { (index, title) in
                }
            }
            
        } else {
            
            UtilityClass.setCustomAlert(title: appName, message: "No internet connection".localized) { (index, title) in
                //
            }
            
        }
         
        
       
        
    }
    
    //MARK:- Function:
    
    func setupView() {
        
        // set lbl header one and two msgs:
        
        lbl_HeaderOne.text = "Verify Phone".localized
        lbl_HeaderTwo.text = "Please enter OTP".localized
        
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = themeBlueColor
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = themeBlueColor
        }
    
    }
    
    func WebserviceOtpForRegister(msg: Bool) {
        
        //Validations :
        
        var dictParam = [String:AnyObject]()
        dictParam["Email"] = email as AnyObject
        dictParam["MobileNo"] = mobile as AnyObject
        
        
        webserviceForOTPRegister(dictParam as AnyObject) { (result, status) in
            
            if status {
                
                let dictResult = result as! [String: AnyObject]
                let otp = dictResult["otp"] as? Int
                
                print(otp)
                
                self.validOTP_FromWebService = otp ?? 0
                
                if msg {
                    // Make a Toast or Display an alert..
//                    UtilityClass.setCustomAlert(title: "Success", message: "OTP has been sent successfully", completionHandler:
                        
                    UtilityClass.setCustomAlert(title: "Success", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                        //
                    }
                }
                
            } else {
//                print((result as! [String:AnyObject])["message"] as? String)
                //may be an alert saying something went wrong please check back later.
                
                UtilityClass.setCustomAlert(title: "Invalid!", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    //
                }
                
            }
            
        }
    }
    
    
}
