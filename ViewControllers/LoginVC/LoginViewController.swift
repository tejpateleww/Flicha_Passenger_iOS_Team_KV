//
//  LoginViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 25/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton
import ACFloatingTextfield_Swift
import FBSDKLoginKit
import FacebookLogin
import GoogleSignIn
//import SideMenu
import NVActivityIndicatorView
import CoreLocation

import AuthenticationServices

class LoginViewController: ThemeRegisterViewController, CLLocationManagerDelegate, alertViewMethodsDelegates
{
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTitle: ThemeTitleLabel!
    @IBOutlet weak var lblSubTitle: ThemeDescriptionsLabel!
    @IBOutlet weak var txtPassword: ThemeTextField!
    @IBOutlet weak var txtMobile: ThemeTextField!
    @IBOutlet weak var btnLogin: ThemeButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var lblDontAc: UILabel!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    
    var manager = CLLocationManager()
    var strURLForSocialImage = String()
    var aryAllDrivers = NSArray()

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func loadView()
    {
        super.loadView()
      
        //self.setTitle(Title: "Welcome", Description: "Sign in to continue! Sign in to continue! Sign in to continue!")
        self.lblTitle.text = "Welcome"
        self.lblSubTitle.text = "Sign in to continue!"
        self.btnFB.imageView?.contentMode = .scaleAspectFit
        
        if Connectivity.isConnectedToInternet()
        {
            print("Yes! internet is available.")
            // do some tasks..
        }
        else
        {
            UtilityClass.setCustomAlert(title: "Connection Error".localized, message: "Internet connection not available".localized) { (index, title) in
            }
        }
        
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if (manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) || manager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
            {
                if manager.location != nil
                {
                    manager.startUpdatingLocation()
                    manager.desiredAccuracy = kCLLocationAccuracyBest
                    manager.activityType = .automotiveNavigation
                    manager.startMonitoringSignificantLocationChanges()
                    //                    manager.allowsBackgroundLocationUpdates = true
                    //                    manager.distanceFilter = //
                }
                
            }
        }
        
        manager.startUpdatingLocation()
        
//        if(SingletonClass.sharedInstance.isUserLoggedIN)
//        {
//            //                            self.webserviceForAllDrivers()
//            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
//        }
        
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewMain.isHidden = true
        
//        txtMobile.lineColor = UIColor.white
//        txtPassword.lineColor = UIColor.white
//        lblLaungageName.text = "fr"
        UserDefaults.standard.set("fr", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
        
//        if UIDevice.current.name == "Bhavesh iPhone" || UIDevice.current.name == "Excellent Web's iPhone 5s" || UIDevice.current.name == "Rahul's iPhone" {
//
//            txtMobile.text = "9904439228"
//            txtPassword.text = "12345678"
//        }
//        txtMobile.text = "1122334456"
//        txtPassword.text = "12345678"
        
//        lblLaungageName.layer.cornerRadius = 5
//        lblLaungageName.backgroundColor = themeYellowColor
//        lblLaungageName.layer.borderColor = UIColor.black.cgColor
//        lblLaungageName.layer.borderWidth = 0.5
        
          self.setupSOAppleSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.setLocalization()
    }
    
    override func viewDidLayoutSubviews() {
//         Singleton.sharedSingleton.setCornerRadius(view: loginProviderStackView, radius: btnFB.frame.height / 2)
        
//        loginProviderStackView.layer.cornerRadius = loginProviderStackView.frame.height / 2
        
    }
    
   func setLocalization()
   {
        txtMobile.placeholder = "Phone Number".localized
        txtPassword.placeholder = "Password".localized
        lblTitle.text = "Welcome".localized
    lblSubTitle.text = "Sign in to Continue!".localized
        lblDontAc.textColor = .black
    let signup = "SIGN UP".localized
    let or = "OR".localized
//    lblDontAc.attributedText =  "\(or) \n\n \("Don't have an account?".localized) \(signup)".underLineWordsIn(highlightedWords: signup, fontStyle: UIFont.semiBold(ofSize: 12), textColor: themeYellowColor)
    
    lblDontAc.attributedText =  "\("Don't have an account?".localized) \(signup)".underLineWordsIn(highlightedWords: signup, fontStyle: UIFont.semiBold(ofSize: 12), textColor: themeYellowColor)

    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.btnSignupClickAction(_:)))
        lblDontAc.isUserInteractionEnabled = true
        lblDontAc.addGestureRecognizer(tapGesture)
    
        //  lblOr.text = "OR".localized
        btnForgotPass.setTitle("Forgot Password?".localized, for: .normal)
        btnLogin.setTitle("Sign In".localized, for: .normal)
        //btnSignup.setTitle("Sign Up".localized, for: .normal)
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    //MARK: - Validation
    
    func checkValidation() -> Bool
    {
        
        if (txtMobile.text?.count == 0) && (txtPassword.text?.count == 0) {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please fill all the details".localized) { (index, title) in
            }
            
            // txtMobile.showErrorWithText(errorText: "Enter Email")
            return false
        } else if (txtMobile.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter email or phone number".localized) { (index, title) in
            }
            
            // txtMobile.showErrorWithText(errorText: "Enter Email")
            return false
        }
        else if (txtPassword.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter password".localized) { (index, title) in
            }
            
            return false
        }
        return true
    }

    @IBAction func btnFBClicked(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        //        if self.btnFB.isSelected
        //        {
        //            self.btnGoogle.isSelected = false
        //        }
        let login = LoginManager()
        
        login.loginBehavior = LoginBehavior.browser
        UIApplication.shared.statusBarStyle = .default
        login.logOut()
        login.logIn(permissions: ["public_profile","email"], from: self) { (result, error) in
            
            if error != nil
            {
                UIApplication.shared.statusBarStyle = .lightContent
            }
            else if (result?.isCancelled)!
            {
                UIApplication.shared.statusBarStyle = .lightContent
            }
            else
            {
                if (result?.grantedPermissions.contains("email"))!
                {
                    UIApplication.shared.statusBarStyle = .lightContent
                    self.getFBUserData()
                }
                else
                {
                    print("you don't have permission")
                }
            }
        }
    }
    
    //function is fetching the user data
    func getFBUserData()
    {
        //        Utilities.showActivityIndicator()
        
        var parameters = [String: Any]()
        parameters["fields"] = "first_name, last_name, picture, email,id"
        
        GraphRequest.init(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error == nil
            {
                let dictData = result as! [String : AnyObject]
                let strFirstName = String(describing: dictData["first_name"]!)
                let strLastName = String(describing: dictData["last_name"]!)
                let strEmail = String(describing: dictData["email"]!)
                let strUserId = String(describing: dictData["id"]!)
                
                //                //NSString *strPicurl = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                let imgUrl = ((dictData["picture"] as! [String:AnyObject])["data"]  as! [String:AnyObject])["url"] as? String
                
                //                var imgUrl = "http://graph.facebook.com/\(strUserId)/picture?type=large"
                
                
                
                //                let pictureDict = self.report["picture"]!["data"] as AnyObject
                //                let imgUrl = pictureDict["url"] as AnyObject
                
                var image = UIImage()
                let url = URL(string: imgUrl as! String)
                
                self.strURLForSocialImage = imgUrl!
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    image = UIImage(data: imageData)!
                }else {
                    image = UIImage(named: "iconUser")!
                }
                
                var strFullName = ""
                
                
                if !UtilityClass.isEmpty(str: strFirstName)
                {
                    strFullName = strFullName + ("\(strFirstName)")
                }
                if !UtilityClass.isEmpty(str: strLastName) {
                    strFullName = strFullName + (" \(strLastName)")
                }
                
                var dictUserData = [String: AnyObject]()
                
                //                dictUserData["name"] = strFullName as AnyObject
                //                dictUserData["email"] = strEmail as AnyObject
                //                //                dictUserData["email"] = "" as AnyObject
                //                dictUserData["social_id"] = strUserId as AnyObject
                //                dictUserData["image"] = strPicurl as AnyObject
                //                dictUserData["type"] = "facebook" as AnyObject
                //                dictUserData["device_token"] = "1234567" as AnyObject
                
                dictUserData["Firstname"] = strFirstName as AnyObject
                dictUserData["Lastname"] = strLastName as AnyObject
                dictUserData["Email"] = strEmail as AnyObject
                dictUserData["MobileNo"] = "" as AnyObject
                dictUserData["Lat"] = "\(SingletonClass.sharedInstance.latitude)" as AnyObject
                dictUserData["Lng"] = "\(SingletonClass.sharedInstance.longitude)" as AnyObject
                dictUserData["SocialId"] = strUserId as AnyObject
                dictUserData["SocialType"] = "Facebook" as AnyObject
                dictUserData["Token"] = SingletonClass.sharedInstance.deviceToken as AnyObject
                dictUserData["DeviceType"] = "1" as AnyObject
                
                //
                //            SocialId , SocialType(Facebook OR Google) , DeviceType (1 OR 2) , Token , Firstname, Lastname ,  Email (optional), MobileNo , Lat , Lng , Image(optional)
                //            GVUserDefaults.standard().userData =  NSMutableDictionary(dictionary: dictUserData)
                self.SocialLogin(dictUserData as AnyObject, ImgPic: image)
                SingletonClass.sharedInstance.isFromSocilaLogin = true
            }
        }
    }
        
    @IBAction func btnGoogleClicked(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        //        if self.btnGoogle.isSelected
        //        {
        //            self.btnFB.isSelected = false
        //        }
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func btnLogin(_ sender: Any) {
        if (checkValidation()) {
            self.webserviceCallForLogin()
        }
    }
    
    @objc func btnSignupClickAction(_ recognizer: UITapGestureRecognizer)
    {
        guard let text = self.lblDontAc.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: "SIGN UP".localized),
            recognizer.didTapAttributedTextInLabel(label: self.lblDontAc, inRange: NSRange(range, in: text))
        {
            print("Sign up click")
            let registerVC = LoginAndRegisterStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        
        let forgotPasswordVC = LoginAndRegisterStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
         self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    func setLayoutForswahilLanguage()
    {
        UserDefaults.standard.set("fr", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
        //            setLayoutForSwahilLanguage()
    }
    func setLayoutForenglishLanguage()
    {
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
        //        setLayoutForSwahilLanguage()
        //        setLayoutForEnglishLanguage()
    }
    @IBAction func btnLaungageClicked(_ sender: Any)
    {
        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String
        {
            if SelectedLanguage == "en"
            {
                setLayoutForswahilLanguage()
                //lblLaungageName.text = "EN"
                
            } else if SelectedLanguage == "fr"
            {
                setLayoutForenglishLanguage()
                //lblLaungageName.text = "fr"
            }
            
            self.navigationController?.loadViewIfNeeded()
            self.setLocalization()
        }
        
        //        if strSelectedLaungage == KEnglish
        //        {
        //            strSelectedLaungage = KSwiley
        //
        //            if UserDefaults.standard.value(forKey: "i18n_language") != nil {
        //                if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        //                        if language == "en"
        //                        {
        //                            setLayoutForswahilLanguage()
        //
        //                            print("Swahil")
        //                    }
        //                }
        //            }
        //        }
        //        else
        //        {
        //            strSelectedLaungage = KEnglish
        //            if UserDefaults.standard.value(forKey: "i18n_language") != nil {
        //                if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
        //                    if language == "fr" {
        ////                        setLayoutForEnglishLanguage()
        //                        setLayoutForenglishLanguage()
        //                        print("English")
        //                    }
        //                }
        //            }
        //        }
        //
        //        lblLaungageName.text = strSelectedLaungage
    }
    
    //-------------------------------------------------------------
    // MARK: - Location Methods
    //-------------------------------------------------------------
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
//        print("Location: \(location)")
        
//        let location: CLLocation = locations.last!
        
        let state = UIApplication.shared.applicationState
        if state == .background {
            print("The location we are getting in background mode is \(location)")
        }
//        defaultLocation = location
                
        SingletonClass.sharedInstance.latitude = location.coordinate.latitude
        SingletonClass.sharedInstance.longitude = location.coordinate.longitude
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
           
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func didOKButtonPressed()
    {
        
    }
    
    func didCancelButtonPressed()
    {
        
    }
    
    func setCustomAlert(title: String, message: String) {
        AJAlertController.initialization().showAlertWithOkButton(aStrTitle: title, aStrMessage: message) { (index,title) in
        }
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertsViewController") as! CustomAlertsViewController
//
//        next.delegateOfAlertView = self
//        next.strTitle = title
//        next.strMessage = message
//
//        self.navigationController?.present(next, animated: false, completion: nil)
        
    }
   
    
}

//MARK: - Google SignIn Delegate

extension LoginViewController : GIDSignInDelegate
{
    func signInWillDispatch(signIn: GIDSignIn!, error: Error!)
    {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        UIApplication.shared.statusBarStyle = .default
        viewController.modalPresentationStyle  = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!)
    {
        UIApplication.shared.statusBarStyle = .lightContent
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)
        {
            // Perform any operations on signed in user here.
            let userId : String = user.userID // For client-side use only!
            let firstName : String  = user.profile.givenName
            let lastName : String  = user.profile.familyName
            let email : String = user.profile.email
            
            var dictUserData = [String: AnyObject]()
            var image = UIImage()
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 400)
                let imgUrl: String = (pic?.absoluteString)!
                print(imgUrl)
                self.strURLForSocialImage = imgUrl
                let url = URL(string: imgUrl )
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    image = UIImage(data: imageData)!
                }else {
                    image = UIImage(named: "iconUser")!
                }
                
                //                dictUserData["image"] = strImage as AnyObject
            }
            
            var strFullName = ""
            
            if !UtilityClass.isEmpty(str: firstName)
            {
                strFullName = strFullName + ("\(firstName)")
            }
            if !UtilityClass.isEmpty(str: strFullName) {
                strFullName = strFullName + (" \(lastName)")
            }
            //            SocialId,SocialType,DeviceType,Token,Firstname,Lastname,Lat,Lng
            
            //            dictUserData["profileimage"] = "" as AnyObject
            dictUserData["Firstname"] = firstName as AnyObject
            dictUserData["Lastname"] = lastName as AnyObject
            dictUserData["Email"] = email as AnyObject
            dictUserData["MobileNo"] = "" as AnyObject
            dictUserData["Lat"] = "\(SingletonClass.sharedInstance.latitude ?? 0.0)" as AnyObject
            dictUserData["Lng"] = "\(SingletonClass.sharedInstance.longitude ?? 0.0)" as AnyObject
            dictUserData["SocialId"] = "\(userId)" as AnyObject
            dictUserData["SocialType"] = "Google" as AnyObject
            dictUserData["Token"] = SingletonClass.sharedInstance.deviceToken as AnyObject
            dictUserData["DeviceType"] = "1" as AnyObject
            
            //
            //            SocialId , SocialType(Facebook OR Google) , DeviceType (1 OR 2) , Token , Firstname, Lastname ,  Email (optional), MobileNo , Lat , Lng , Image(optional)
            
            //            GVUserDefaults.standard().userData =  NSMutableDictionary(dictionary: dictUserData)
            
            SingletonClass.sharedInstance.isFromSocilaLogin = true
            self.SocialLogin(dictUserData as AnyObject, ImgPic: image)
        }
        else
        {
            print("\(error.localizedDescription)")
        }
        
    }
    
}


//MARK: - APPLE LOGIN

extension LoginViewController {
    
    // apple sign in
      func setupSOAppleSignIn() {
            if #available(iOS 13.0, *) {
//                let authorizationButton = ASAuthorizationAppleIDButton()
                let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
                
                authorizationButton.layer.cornerRadius = authorizationButton.frame.height / 2
                
//                let maskView = UIView(frame: CGRect(x: 0, y: 0, width: loginProviderStackView.frame.width, height: loginProviderStackView.frame.height))
//                maskView.backgroundColor = .black
//                maskView.layer.cornerRadius = loginProviderStackView.frame.width / 2
//                authorizationButton.mask = maskView
                
              
                
                authorizationButton.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
                self.loginProviderStackView.addArrangedSubview(authorizationButton)
                
                //SJ Edit Started
                
               
                
            } else {
                // Fallback on earlier versions
                loginProviderStackView.isHidden = true
            }
        }
        
        // Perform acton on click of Sign in with Apple button
        @objc func actionHandleAppleSignin() {
            if #available(iOS 13.0, *) {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
        }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // ASAuthorizationControllerDelegate function for authorization failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    @available(iOS 13.0, *)
    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let appleId = appleIDCredential.user
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            let appleUserLastName = appleIDCredential.fullName?.familyName
            let appleUserEmail = appleIDCredential.email
            print(appleId, appleUserFirstName ?? "", appleUserLastName ?? "", appleUserEmail ?? "")
            
            
            self.appleLogIn(credentials: appleIDCredential, email: appleUserEmail ?? "", firstName: appleUserFirstName ?? "", lastName: appleUserLastName ?? "")
        }
        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            
            print(appleUsername, applePassword)
        }
    }
}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    //For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}



//MARK: - Webservices Section

extension LoginViewController
{
    //MARK:- Primary Login

    func webserviceCallForLogin()
    {
        let dictparam = NSMutableDictionary()
        dictparam.setObject(txtMobile.text!, forKey: "Username" as NSCopying)
        dictparam.setObject(txtPassword.text!, forKey: "Password" as NSCopying)
        dictparam.setObject("1", forKey: "DeviceType" as NSCopying)
        dictparam.setObject("6287346872364287", forKey: "Lat" as NSCopying)
        dictparam.setObject("6287346872364287", forKey: "Lng" as NSCopying)
        dictparam.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
        UtilityClass.showACProgressHUD()
        
        webserviceForDriverLogin(dictparam) { (result, status) in
            
            if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    UtilityClass.hideACProgressHUD()
                    
                    if let profileData = result.object(forKey: "profile") as? NSDictionary, profileData.count > 0
                    {
                        SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: profileData)
                        
                        UserDefaults.standard.set(profileData, forKey: "profileData")
                        
                        if let passangerID = profileData.object(forKey: "Id")
                        {
                            SingletonClass.sharedInstance.strPassengerID = "\(passangerID)"
                        }
                        SingletonClass.sharedInstance.isUserLoggedIN = true
                        self.webserviceForAllDrivers()
                        
                    }else
                    {
                        SingletonClass.sharedInstance.isUserLoggedIN = false
                        SingletonClass.sharedInstance.strPassengerID = ""
                        UserDefaults.standard.removeObject(forKey: "profileData")
                    }
                })
                
            } else
            {
                UtilityClass.hideACProgressHUD()
                UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                }
            }
        }
    }
    
    //MARK: - Social Login

    func SocialLogin(_ dictData : AnyObject, ImgPic : UIImage)
    {
        webserviceForSocialLogin(dictData as AnyObject, image1: ImgPic, showHUD: true) { (result, status) in
            
            print(result)
            
            if(status)
            {
                _ = result as! [String : AnyObject]
                UtilityClass.hideACProgressHUD()
                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                SingletonClass.sharedInstance.strPassengerID = String(describing: SingletonClass.sharedInstance.dictProfile.object(forKey: "Id")!)//as! String
                SingletonClass.sharedInstance.isUserLoggedIN = true
                UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                self.webserviceForAllDrivers()
                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                
            }
            else
            {
                if let res = result as? String
                {
                    UtilityClass.showAlert(appName, message: res, vc: self)
                }
                else if result is NSDictionary
                {
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
                    SingletonClass.sharedInstance.strSocialEmail = dictData["Email"] as! String
                    SingletonClass.sharedInstance.strSocialFullName = "\(dictData["Firstname"] as! String) \(dictData["Lastname"] as! String)"
                    SingletonClass.sharedInstance.strSocialImage = self.strURLForSocialImage
                    self.navigationController?.pushViewController(viewController!, animated: true)
                }
                else if let resAry = result as? NSArray
                {
                    UtilityClass.showAlert(appName, message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                }
            }
        }
    }
    
    //MARK: - All Drivers

    func webserviceForAllDrivers()
    {
        webserviceForAllDriversList { (result, status) in
            
            if (status)
            {
                self.aryAllDrivers = ((result as! NSDictionary).object(forKey: "drivers") as! NSArray)
                
                SingletonClass.sharedInstance.allDiverShowOnBirdView = self.aryAllDrivers
                
                (UIApplication.shared.delegate as! AppDelegate).GoToHome()
                
                //                self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                _ = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuViewController")as? CustomSideMenuViewController
                //                let navController = UINavigationController(rootViewController: viewHomeController!)
                //                self.sideMenuController?.embed(centerViewController: navController)
            }
            else
            {
                print(result)
            }
        }
    }
    
    //MARK: - App Settings
    
    func webserviceOfAppSetting() {
        //        version : 1.0.0 , (app_type : AndroidPassenger , AndroidDriver , IOSPassenger , IOSDriver)
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        
        print("Vewsion : \(version)")
        
        var param = String()
        param = version + "/" + "IOSPassenger"
        webserviceForAppSetting(param as AnyObject) { (result, status) in
            
            if (status) {
                print("result is : \(result)")
                SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                
                //                self.viewMain.isHidden = false
                
                if ((result as! NSDictionary).object(forKey: "update") as? Bool) != nil {
                    
                    let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "UPDATE", style: .default, handler: { ACTION in
                        
                        UIApplication.shared.open((NSURL(string: "itms-apps://itunes.apple.com/app/id1518549633")! as URL), options: [:], completionHandler: { (status) in
                            
                        })
                    })
                    let Cancel = UIAlertAction(title: "Cancel".localized, style: .default, handler: { ACTION in
                        
                        if(SingletonClass.sharedInstance.isUserLoggedIN)
                        {
                            //                            self.webserviceForAllDrivers()
                            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                        }
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    alert.modalPresentationStyle  = .overCurrentContext
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    if(SingletonClass.sharedInstance.isUserLoggedIN) {
                        
                        self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                    }
                }
            }
            else {
                print(result)
                
                if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                    
                    if (update) {
                        
                        UtilityClass.showAlertWithCompletion("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self, completionHandler: { ACTION in
                            
                            UIApplication.shared.open((NSURL(string: "itms-apps://itunes.apple.com/app/id1518549633")! as URL), options: [:], completionHandler: { (status) in
                                
                            })//openURL(NSURL(string: "https://itunes.apple.com/us/app/pick-n-go/id1320783092?mt=8")! as URL)
                        })
                    }
                    else {
                        
                        UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                            if (index == 0)
                            {
                                UIApplication.shared.open((NSURL(string: "itms-apps://itunes.apple.com/app/id1518549633")! as URL), options: [:], completionHandler: { (status) in
                                    
                                })
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
}







extension LoginViewController {
    
    @available(iOS 13.0, *)
    func checkAppleId(credentials : ASAuthorizationAppleIDCredential) {
        //user.isAbove18 = true //FOR TEMP USER ONLY
        var  paramer: [String: Any] = [:]
        
        let appleId = credentials.user
        
        paramer["email"] = ""
        paramer["facebook_id"] = ""
        paramer["google_id"] = ""
        paramer["twitter_id"] = ""
        paramer["apple_id"] = appleId

//        AFAPIMaster.sharedAPIMaster.postCheckEmail_Completion(params: paramer, showLoader: true, enableInteraction: false, viewObj: (Global.appDelegate.navController?.view)!, onSuccess: { (result) in
//            print(result)
//            let Dict = JSON(result)
//
//            if  Dict["FLAG"].bool == true {
//                let strEmailAddress = "\(Dict["DATA"])"
//                let strFName = "\(Dict["DATAFNAME"])"
//                let strLName = "\(Dict["DATALNAME"])"
//
//                self.appleLogIn(credentials: credentials, email: strEmailAddress, firstName: strFName, lastName: strLName)
//            }
//            else {
//                self.appleLogIn(credentials: credentials, email: "", firstName: "", lastName: "")
//            }
//
//        }) {
//
//        }
        
        
        
        
    }

    
    @available(iOS 13.0, *)
    func appleLogIn(credentials : ASAuthorizationAppleIDCredential, email : String , firstName : String , lastName : String)  {
        
        let appleId = credentials.user
        let appleUserFirstName = credentials.fullName?.givenName
        let appleUserLastName = credentials.fullName?.familyName
        let appleUserEmail = credentials.email
        
        var  paramer: [String: Any] = [:]
        
        paramer["first_name"] =  appleUserFirstName ?? firstName
        paramer["last_name"] = appleUserLastName ?? lastName
        paramer["email"] = appleUserEmail ?? email
        paramer["apple_id"] = appleId

        print("apple login dict\(paramer)")

        WebserviceForAppleLogin(paramer as AnyObject) { (result, status) in
            print(result)
            
            if status {
                // save user to user defaults ?
                let data = result["data"] as! [String: AnyObject]
                SingletonClass.sharedInstance.dictProfile = data as! NSMutableDictionary
            } else {
                //
            }
        }
        
    }
}

