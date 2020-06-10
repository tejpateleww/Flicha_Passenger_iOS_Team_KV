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
    
    func setupView()
    {
        self.lblTitle.text = "Create Account"
        self.lblSubTitle.text = "Sign up to get started"
        self.txtFirstName.placeholder = "First Name"
        self.txtLastName.placeholder = "Last Name"
        self.txtEmail.placeholder = "Email Id"
        self.txtPhoneNumber.placeholder = "Phone Number"
        self.txtPassword.placeholder = "Password"
        self.txtConfirmPassword.placeholder = "Confirm Password"
        self.btnSignUp.setTitle("Sign UP", for: .normal)
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.layer.masksToBounds = true
        self.ProfileImageView.layer.cornerRadius = self.ProfileImageView.frame.size.width / 2
        self.ProfileImageView.layer.masksToBounds = true
        self.lblAlreadyAccount.attributedText =  "\("Already Have an Account?".localized) SIGN IN".underLineWordsIn(highlightedWords: "SIGN IN", fontStyle: UIFont.semiBold(ofSize: 12), textColor: themeYellowColor)
        
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
        
        if let range = text.range(of: "SIGN IN"),
            recognizer.didTapAttributedTextInLabel(label: self.lblAlreadyAccount, inRange: NSRange(range, in: text))
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSignUpClickAction(_ sender: Any)
    {
        self.webServiceCallForRegister()
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
        if (txtFirstName.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Enter first name") { (index, title) in
            }
            return false
        }
        else if (txtLastName.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Enter last name") { (index, title) in
            }
            return false
        
        }else if (txtEmail.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Enter your email address") { (index, title) in
            }
            return false
        
        }else if (!(txtEmail.text?.isValidEmail() ?? false))
        {
            UtilityClass.setCustomAlert(title: "Incorrect", message: "Enter valid email address.") { (index, title) in
            }
            return false
        }
        else if (txtPhoneNumber.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Enter your phone number") { (index, title) in
            }
            return false
       
        }else if (txtPassword.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Enter password") { (index, title) in
            }
            return false
       
        }else if (txtConfirmPassword.text?.count == 0)
        {
            UtilityClass.setCustomAlert(title: "Missing", message: "Enter confirm password") { (index, title) in
            }
            return false
      
        }else if txtPassword.text != txtConfirmPassword.text
        {
            UtilityClass.setCustomAlert(title: "Missmatch", message: "Password and confirm password must be same") { (index, title) in
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
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
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
    func webServiceCallForRegister()
    {
        if checkValidation()
        {
            UtilityClass.showACProgressHUD()
            
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
            
            webserviceForRegistrationForUser(dictParams, image1: imgProfile.image!) { (result, status) in
                
                print(result)
                
                if ((result as! NSDictionary).object(forKey: "status") as! Int == 1)
                {
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        UtilityClass.hideACProgressHUD()
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else
                {
                    UtilityClass.hideACProgressHUD()
                    UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
        
    }
    
}
