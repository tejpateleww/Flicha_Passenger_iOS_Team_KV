//
//  SignUpViewController.swift
//  Flicha User
//
//  Created by Mehul Panchal on 11/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController {

    @IBOutlet weak var lblTitle: ThemeTitleLabel!
    @IBOutlet weak var lblSubTitle: ThemeDescriptionsLabel!
    @IBOutlet weak var txtFirstName: ThemeTextField!
    @IBOutlet weak var txtLastName: ThemeTextField!
    @IBOutlet weak var txtEmail: ThemeTextField!
    @IBOutlet weak var txtPhoneNumber: ThemeTextField!
    @IBOutlet weak var txtPassword: ThemeTextField!
    @IBOutlet weak var txtConfirmPassword: ThemeTextField!
    @IBOutlet weak var btnSignUp: ThemeButton!
    @IBOutlet weak var lblAlreadyAccount: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var ProfileImageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView()
    {
        self.lblTitle.text = "Create Account".localized
        self.lblSubTitle.text = "Sign up to get started".localized
        self.txtFirstName.placeholder = "First Name".localized
        self.txtLastName.placeholder = "Last Name".localized
        self.txtEmail.placeholder = "Email Id".localized
        self.txtPhoneNumber.placeholder = "Phone Number".localized
        self.txtPassword.placeholder = "Password".localized
        self.txtConfirmPassword.placeholder = "Confirm Password".localized
        self.btnSignUp.setTitle("Sign Up".localized, for: .normal)
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.layer.masksToBounds = true
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.layer.masksToBounds = true
        let signin = "SIGN IN".localized
        self.lblAlreadyAccount.attributedText =  "\("Already Have an Account?".localized) \(signin)".underLineWordsIn(highlightedWords: signin, fontStyle: UIFont.semiBold(ofSize: 12), textColor: themeYellowColor)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.btnSignInClickAction(_:)))
        self.lblAlreadyAccount.isUserInteractionEnabled = true
        self.lblAlreadyAccount.addGestureRecognizer(tapGesture)
        
        if SingletonClass.sharedInstance.isFromSocilaLogin == true
        {
            var image = UIImage()

            self.txtFirstName.text = SingletonClass.sharedInstance.strSocialFullName
            let url = URL(string: SingletonClass.sharedInstance.strSocialImage)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                image = UIImage(data: imageData)!
            }else {
                image = UIImage(named: "iconUser")!
            }
            
            self.imgProfile.image = image
        }
        
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
    
    @objc func btnSignInClickAction(_ recognizer: UITapGestureRecognizer)
    {
        guard let text = self.lblAlreadyAccount?.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: "SIGN IN".localized),
            recognizer.didTapAttributedTextInLabel(label: self.lblAlreadyAccount, inRange: NSRange(range, in: text))
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSignUpClickAction(_ sender: Any)
    {
//        self.webServiceCallForRegister()
        
        if checkValidation() {
            let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVerificationViewController") as! SignUpVerificationViewController
            
            verifyVC.mobile = self.txtPhoneNumber.text!
            verifyVC.email = self.txtEmail.text!
            
            let dictParams = NSMutableDictionary()
            dictParams.setObject(txtFirstName.text ?? "", forKey: "Firstname" as NSCopying)
            dictParams.setObject(txtLastName.text ?? "", forKey: "Lastname" as NSCopying)
            dictParams.setObject("", forKey: "ReferralCode" as NSCopying)
            dictParams.setObject("", forKey: "ZipCode" as NSCopying)
            dictParams.setObject("", forKey: "Address" as NSCopying)
            dictParams.setObject(txtPhoneNumber.text ?? "", forKey: "MobileNo" as NSCopying)
            dictParams.setObject(txtEmail.text ?? "", forKey: "Email" as NSCopying)
            dictParams.setObject(txtPassword.text ?? "", forKey: "Password" as NSCopying)
            dictParams.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
            dictParams.setObject("1", forKey: "DeviceType" as NSCopying)
            dictParams.setObject("", forKey: "Gender" as NSCopying)
            dictParams.setObject("12376152367", forKey: "Lat" as NSCopying)
            dictParams.setObject("2348273489", forKey: "Lng" as NSCopying)
            dictParams.setObject("", forKey: "DOB" as NSCopying)
            verifyVC.dict = dictParams
            
            verifyVC.userImg = imgProfile.image!
            
            
            self.navigationController?.pushViewController(verifyVC, animated: true)
        }
        
    }
    
    @IBAction func btnChooseImage(_ sender: Any)
    {
        self.chooseProfilePictureOptions()
    }
}
//MARK:- Helper Methods

extension SignUpViewController
{
    func checkValidation() -> Bool
    {
        
        if (txtFirstName.text?.count == 0) && (txtLastName.text?.count == 0) && (txtEmail.text?.count == 0) && (txtPhoneNumber.text?.count == 0) && (txtPassword.text?.count == 0) && (txtConfirmPassword.text?.count == 0) {
            
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please fill all details".firstCharacterUpperCase().localized) { (index, title) in
            }
            return false
        }
        else if (txtFirstName.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: ("Please enter first name")){ (index, title) in
            }
            return false
        }
        else if (txtLastName.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter last name".firstCharacterUpperCase().localized) { (index, title) in
            }
            return false
        
        }else if (txtEmail.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter email".firstCharacterUpperCase().localized) { (index, title) in
            }
            return false
        
        }else if (!(txtEmail.text?.isValidEmail() ?? false))
        {
            UtilityClass.setCustomAlert(title: "Incorrect".localized, message: "Please enter a valid email".localized) { (index, title) in
            }
            return false
        }
        else if (txtPhoneNumber.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter phone number".localized) { (index, title) in
            }
            return false
       
        }else if (txtPhoneNumber.text!.count < 10)
         {
             UtilityClass.setCustomAlert(title: "Invalid".localized, message: "Please enter valid email or phone number".localized) { (index, title) in
             }
             return false
        
         }else if (txtPassword.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please enter password".localized) { (index, title) in
            }
            return false
       
        }else if (txtPassword.text?.count ?? 0 < 6)
        {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Password must contain atleast 6 characters".localized) { (index, title) in
            }
            return false
            
        }
        else if (txtConfirmPassword.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing".localized, message: "Please confirm password".localized) { (index, title) in
            }
            return false
      
        }else if txtPassword.text != txtConfirmPassword.text
        {
            UtilityClass.setCustomAlert(title: "Missmatch".localized, message: "Password and confirm password must be same".localized) { (index, title) in
            }
            return false
        }
//        else if imgProfile.image!.isEqualToImage(image: UIImage(named: "icon_UserImage")!) {
//
//            UtilityClass.setCustomAlert(title: "Missing", message: "Please choose profile picture") { (index, title) in
//            }
//            return false
//        }
        return true
    }
    
    func chooseProfilePictureOptions() {
        
        let alert = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .alert)
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle  = .overCurrentContext
            self.present(picker, animated: true, completion: nil)
        })
        
        let Camera  = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle  = .overCurrentContext
            self.present(picker, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alert.addAction(Gallery)
        alert.addAction(Camera)
        alert.addAction(cancel)
        alert.modalPresentationStyle  = .overCurrentContext
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- Image PickerController Delegate

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgProfile.contentMode = .scaleToFill
            imgProfile.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
//MARK:- API Section

extension SignUpViewController
{
    func webServiceCallForRegister(params: NSMutableDictionary, img: UIImage)
    {
//        if checkValidation()
//        {
            UtilityClass.showACProgressHUD()
            
//            let dictParams = NSMutableDictionary()
//
//            dictParams.setObject(txtFirstName.text ?? "", forKey: "Firstname" as NSCopying)
//            dictParams.setObject(txtLastName.text ?? "", forKey: "Lastname" as NSCopying)
//            dictParams.setObject("", forKey: "ReferralCode" as NSCopying)
//            dictParams.setObject("", forKey: "ZipCode" as NSCopying)
//            dictParams.setObject("", forKey: "Address" as NSCopying)
//            dictParams.setObject(txtPhoneNumber.text ?? "", forKey: "MobileNo" as NSCopying)
//            dictParams.setObject(txtEmail.text ?? "", forKey: "Email" as NSCopying)
//            dictParams.setObject(txtPassword.text ?? "", forKey: "Password" as NSCopying)
//            dictParams.setObject(SingletonClass.sharedInstance.deviceToken, forKey: "Token" as NSCopying)
//             dictParams.setObject("1", forKey: "DeviceType" as NSCopying)
//            dictParams.setObject("", forKey: "Gender" as NSCopying)
//            dictParams.setObject("12376152367", forKey: "Lat" as NSCopying)
//            dictParams.setObject("2348273489", forKey: "Lng" as NSCopying)
//            dictParams.setObject("", forKey: "DOB" as NSCopying)
        
            webserviceForRegistrationForUser(params, image1: img) { (result, status) in
                
                print(result)
                
                if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
                {
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        UtilityClass.hideACProgressHUD()
                       
                        
                        // msg
                        UtilityClass.setCustomAlert(title: "Alert!", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
//                            print(index)
                        }
                        
                    })
                }
                else
                {
                    UtilityClass.hideACProgressHUD()
                    UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
//        }
        
    }
    
}

extension SignUpViewController : SignupRemotely {
    func signInAfterOTP(_ data: NSMutableDictionary, img: UIImage) {
        webServiceCallForRegister(params: data, img: img)
        
    }
    
    
}
