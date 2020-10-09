//
//  UpdateProfileViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 13/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage
import M13Checkbox
import NVActivityIndicatorView
import IQDropDownTextField

protocol UpdateProfileVCDelegate : AnyObject {
    func didProfileUpdate(_ str: String)
}

class UpdateProfileViewController: BaseViewController,IQDropDownTextFieldDelegate {
    
   // MARK: - Outlets
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblFirstName:UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet var btnChangePassword: UIButton!
    @IBOutlet var btnProfile: UIButton!
    var isEditMode : Bool = false
    var updatedProfileImage = UIImage()
    
    var delegate : UpdateProfileVCDelegate?
    
    // MARK: - Base Methods

    override func viewDidLoad(){
        super.viewDidLoad()
        self.setupView()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController
        self.delegate = vc
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileData()
        // self.setNavBarWithBack(Title: "Profile".localized, IsNeedRightButton: true)
        
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage.init(named: "edit-icon"), for: .normal)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(self.handleSaveProfile), for: .touchUpInside)
        self.addCustomNavigationBarWithRightButton(title: "Profile".localized, rightBarButton: rightButton)
    }
    
    func setupView() {
        lblHeaderTitle.font = UIFont.semiBold(ofSize: 20)
        lblFirstName.text = "First Name".localized
        lblLastName.text = "Last Name".localized
        lblEmail.text = "Email Id".localized
        lblPhoneNumber.text = "Phone Number".localized
        btnChangePassword.setTitle("Change Password".localized, for: .normal)
        btnProfile.addTarget(self, action: #selector(editProfilePicture), for: .touchUpInside)
        
        txtEmail.isUserInteractionEnabled = false
        txtPhoneNumber.isUserInteractionEnabled = false
        btnProfile.isUserInteractionEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnProfile.layer.cornerRadius = btnProfile.frame.width / 2
        btnProfile.layer.borderWidth = 1.0
        btnProfile.layer.borderColor = themeYellowColor.cgColor
        btnProfile.layer.masksToBounds = true
    }
   
    // MARK: - Actions

    @objc func handleSaveProfile(){
        
        if isEditMode
        {
            self.webserviceOfUpdateProfile()
            
        }else
        {
            isEditMode = true
            
            //SJ Edit Started    Given the tag 27 to container and right view..
            let containerView = self.view.subviews.first(where: {$0.tag == 27})
            let stackView = containerView!.subviews.first!
            let rightView = stackView.subviews.first(where: {$0.tag == 27})
            let btn = rightView!.subviews.first as? UIButton
            btn?.setImage(nil, for: .normal)
            btn?.setTitle("save", for: .normal)
            //SJ Edit Ended
            
            
            
            setInputMode(enable: true)
        }
    }
       
    @IBAction func btnChangePassword(_ sender: UIButton) {
        let next = LoginAndRegisterStoryboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func editProfilePicture() {
        
        let alert = UIAlertController(title: "Choose Image From", message: nil, preferredStyle: .actionSheet)
        
        let Camera = UIAlertAction(title: "Camera", style: .default, handler: { ACTION in
            self.PickingImageFromCamera()
        })
        
        let Gallery = UIAlertAction(title: "Gallery", style: .default, handler: { ACTION in
            self.PickingImageFromGallery()
        })
        
        let Cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(Camera)
        alert.addAction(Gallery)
        alert.addAction(Cancel)
        alert.modalPresentationStyle  = .overCurrentContext
        self.present(alert, animated: true, completion: nil)
    }
    
    func PickingImageFromGallery(){
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        // picker.stopVideoCapture()
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle  = .overCurrentContext
        present(picker, animated: true, completion: nil)
    }
    
    func PickingImageFromCamera(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle  = .overCurrentContext
        present(picker, animated: true, completion: nil)
    }
    
    func setInputMode(enable : Bool){
        self.txtFirstName.isUserInteractionEnabled = enable
        self.txtLastName.isUserInteractionEnabled = enable
        self.btnProfile.isUserInteractionEnabled = enable
    }

    func setProfileData(){
       
       setInputMode(enable: false)
       let dicProfileData = SingletonClass.sharedInstance.dictProfile
       btnProfile.sd_setImage(with: URL(string: dicProfileData.object(forKey: "Image") as! String), for: .normal, completed: nil)
       btnProfile.contentMode = .scaleToFill

        let fullName = dicProfileData.object(forKey: "Fullname") as! String
        if let fullNameArr = fullName.components(separatedBy: " ") as [String]?, fullNameArr.count > 1
        {
            txtFirstName.text = fullNameArr[0]
            txtLastName.text = fullNameArr[1]
            let hey = "Hey".localized
            lblHeaderTitle.text = hey + " " + (fullNameArr[0])
            
        }else
        {
            txtFirstName.text = fullName
            txtLastName.text = fullName
            let hey = "Hey".localized
            lblHeaderTitle.text = hey + " " + fullName
        }
        txtEmail.text = dicProfileData.object(forKey: "Email") as? String ?? ""
        txtPhoneNumber.text = dicProfileData.object(forKey: "MobileNo") as? String ?? ""
    }

}

// MARK: - PickerControllerDelegate Methods

extension UpdateProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            btnProfile.contentMode = .scaleToFill
            btnProfile.setImage(pickedImage, for: .normal)
            self.updatedProfileImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Webservice Methods

extension UpdateProfileViewController
{
    func webserviceOfUpdateProfile()
    {
        var dictData = [String:AnyObject]()
       
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["Fullname"] = txtFirstName.text! + " " + txtLastName.text! as AnyObject
        dictData["Email"] = txtEmail.text! as AnyObject
        dictData["MobileNo"] = txtPhoneNumber.text! as AnyObject
        
        dictData["Firstname"] = txtFirstName.text! as AnyObject
        dictData["Lastname"] = txtLastName.text! as AnyObject

//        let activityData = ActivityData()
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        webserviceForUpdateProfile(dictData as AnyObject, image1: self.updatedProfileImage ) { (result, status) in
            
            if (status)
            {
                
//                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                print(result)
                SingletonClass.sharedInstance.dictProfile = NSMutableDictionary(dictionary: (result as! NSDictionary).object(forKey: "profile") as! NSDictionary)
                
                UserDefaults.standard.set(SingletonClass.sharedInstance.dictProfile, forKey: "profileData")
                
                 NotificationCenter.default.post(name: UpdateProPic, object: nil)
                
                let data = SingletonClass.sharedInstance.dictProfile
                
                let imgstr = data.object(forKey: "Image") as! String
                
                
                self.delegate?.didProfileUpdate(imgstr)
               
                UtilityClass.setCustomAlert(title: "Done", message: "Your profile updated successfully".localized) { (index, title) in
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            else
            {
                print(result)
                UtilityClass.setCustomAlert(title: "Error", message: "Something went wrong, please try again".localized) { (index, title) in
                }
            }
        }
    }
}

