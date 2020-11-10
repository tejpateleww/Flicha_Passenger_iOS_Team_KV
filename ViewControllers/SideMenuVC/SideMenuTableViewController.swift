//
//  SideMenuTableViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

protocol delegateForTiCKPayVerifyStatus {
    func didRegisterCompleted()
}

class SideMenuTableViewController: UIViewController, delegateForTiCKPayVerifyStatus, UpdateProfileVCDelegate  {
    
//    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet var lblLaungageName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var btnSignout: ThemeButton!

    var varifyKey = Int()
    var ProfileData = NSDictionary()
    var strSelectedLaungage = String()
    
    
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupView()
        
        let updatevc = LoginAndRegisterStoryboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        updatevc.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(SideMenuTableViewController.updateImgView), name: UpdateProPic, object: nil)
        
    }
    
    @objc func updateImgView() {
        let data = SingletonClass.sharedInstance.dictProfile
        self.imgProfile.sd_setImage(with: URL(string: data.object(forKey: "Image") as! String), completed: nil)
    }
    
    override func viewWillLayoutSubviews() {
        print("test")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("test")
    }
    
    func setupView()
    {
        self.navigationController?.isNavigationBarHidden = false
//        webserviceOfTickPayStatus()
        
//        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String
//        {
//            if SelectedLanguage == "en"
//            {
//                // lblLaungageName.text = "fr"
//            } else if SelectedLanguage == "fr"
//            {
//                lblLaungageName.text = "EN"
//            }
//        }
        
        self.lblName.font = UIFont.bold(ofSize: 15)
        self.lblName.textColor = UIColor.white
        self.lblMobileNumber.font = UIFont.regular(ofSize: 10)
        self.lblMobileNumber.textColor = themeGrayTextColor
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.masksToBounds = true
        
        self.headerView.backgroundColor = themeBlueLightColor
        self.view.backgroundColor = themeBlueColor
        self.headerView.roundCorners(with: .layerMaxXMaxYCorner, radius: 65)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.btnProfilePickClicked(_:)))
        self.headerView.addGestureRecognizer(tapGesture)
        
        ProfileData = SingletonClass.sharedInstance.dictProfile
        self.imgProfile.sd_setImage(with: URL(string: ProfileData.object(forKey: "Image") as! String), completed: nil)
        self.lblName.text = ProfileData.object(forKey: "Fullname") as? String
        self.lblMobileNumber.text = ProfileData.object(forKey: "MobileNo") as? String
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.SetRating), name: NSNotification.Name(rawValue: "rating"), object: nil)

    }
    
    func getMenuCellDetails() -> [(String,String,String)]
    {
        var titleAndImages = [(String,String,String)]()
        titleAndImages.append(("Home".localized, "homeSelect", "homeUnSelect"))
        titleAndImages.append(("My Ride".localized, "my-ride-unselect", "my-ride-select"))
//        titleAndImages.append(("Payment Method", "payment-unselect", "payment-select"))
        titleAndImages.append(("Notifications".localized, "notification-unselect", "notification-select"))
        titleAndImages.append(("Settings".localized, "setting-unselect", "setting-select"))
        titleAndImages.append(("Help".localized, "help-unselect", "help-select"))
        titleAndImages.append(("Logout".localized, "logout-unselect", "logout-select"))
        return titleAndImages
    }
    
    func setLayoutForswahilLanguage()
    {
        UserDefaults.standard.set("fr", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
    }
    
    func setLayoutForenglishLanguage()
    {
        UserDefaults.standard.set("en", forKey: "i18n_language")
        UserDefaults.standard.synchronize()
    }
   
    @objc func SetRating()
    {
        self.CollectionView.reloadData()
    }
  
    func logoutUser()
    {
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to logout?".localized, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Sign Out".localized, "Cancel".localized], tap: {(alert, buttonIndex) in
            if (buttonIndex == 2) {
                
                let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
                
                
                socket.off(SocketData.kReceiveGetEstimateFare)
                socket.off(SocketData.kNearByDriverList)
                socket.off(SocketData.kAskForTipsToPassengerForBookLater)
                socket.off(SocketData.kAskForTipsToPassenger)
                socket.off(SocketData.kAcceptBookingRequestNotification)
                socket.off(SocketData.kRejectBookingRequestNotification)
                socket.off(SocketData.kCancelTripByDriverNotficication)
                socket.off(SocketData.kPickupPassengerNotification)
                socket.off(SocketData.kBookingCompletedNotification)
                socket.off(SocketData.kAcceptAdvancedBookingRequestNotification)
                socket.off(SocketData.kRejectAdvancedBookingRequestNotification)
                socket.off(SocketData.kAdvancedBookingPickupPassengerNotification)
                socket.off(SocketData.kReceiveHoldingNotificationToPassenger)
                socket.off(SocketData.kAdvancedBookingTripHoldNotification)
                socket.off(SocketData.kReceiveDriverLocationToPassenger)
                socket.off(SocketData.kAdvancedBookingDetails)
                socket.off(SocketData.kInformPassengerForAdvancedTrip)
                socket.off(SocketData.kAcceptAdvancedBookingRequestNotify)
                //                Singletons.sharedInstance.isPasscodeON = false
                socket.disconnect()
                (UIApplication.shared.delegate as! AppDelegate).GoToLogout()
            }
        })
    }
    // MARK:- IBAction Methods
    
    @IBAction func btnLogoutAction(_ sender: UIButton)
    {
        self.logoutUser()
    }
    
    @IBAction func btnLaungageClicked(_ sender: Any)
    {
        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String
        {
            if SelectedLanguage == "en"
            {
                setLayoutForswahilLanguage()
                lblLaungageName.text = "EN"
            } else if SelectedLanguage == "fr"
            {
                setLayoutForenglishLanguage()
                lblLaungageName.text = "fr"
            }
            
            self.navigationController?.loadViewIfNeeded()
            self.CollectionView.reloadData()
            (UIApplication.shared.delegate as! AppDelegate).isAlreadyLaunched = true
            NotificationCenter.default.post(name: OpenHome, object: nil)
            sideMenuController?.toggle()
        }
    }
    
    func didRegisterCompleted()
    {
        webserviceOfTickPayStatus()
    }
    
    func didProfileUpdate(_ str: String) {
        print("It works")
        // Cant assign image to imageview here.
//        self.imgProfile.sd_setImage(with: URL(string: str), completed: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func navigateToTiCKPay()
    {
        //        webserviceOfTickPayStatus()
        
        if self.varifyKey == 0 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TickPayRegistrationViewController") as! TickPayRegistrationViewController
            next.delegateForVerifyStatus = self
            self.navigationController?.pushViewController(next, animated: true)
        }
            
        else if self.varifyKey == 1 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TiCKPayNeedToVarifyViewController") as! TiCKPayNeedToVarifyViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
            
        else if self.varifyKey == 2 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    @IBAction func btnProfilePickClicked(_ sender: Any)
    {
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//        self.navigationController?.pushViewController(next, animated: true)
        NotificationCenter.default.post(name: OpenEditProfile, object: nil)
        sideMenuController?.toggle()
    }
    
}


// MARK: - UICollectionView DataSource & Delegate

extension SideMenuTableViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.getMenuCellDetails().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let customCell = self.CollectionView.dequeueReusableCell(withReuseIdentifier: "SideMenuCollectionViewCell", for: indexPath) as! SideMenuCollectionViewCell
        
        if let menuDetails = self.getMenuCellDetails()[indexPath.row] as (String, String,String)?
        {
            customCell.lblTitle.text = menuDetails.0
            customCell.imgDetail?.image = UIImage.init(named:  menuDetails.1)
            
            customCell.imgDetail.contentMode = .scaleAspectFit
        }
        
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
         if let menuDetails = self.getMenuCellDetails()[indexPath.row] as (String, String,String)?
         {

            if menuDetails.0 == "Home".localized
            {
                NotificationCenter.default.post(name: OpenHome, object: nil)
                
            }else if menuDetails.0 == "My Ride".localized
            {
                NotificationCenter.default.post(name: OpenMyBooking, object: nil)
                
            }else if menuDetails.0 == "Payment Method".localized
            {
                NotificationCenter.default.post(name: OpenPaymentOption, object: nil)
                
            }else if menuDetails.0 == "Notifications".localized
            {
//                let notificationVC = PaymentMethodStoryBoard.instantiateViewController(withIdentifier: "NotificationsViewController")
//                self.navigationController?.pushViewController(notificationVC, animated: true)
                
                NotificationCenter.default.post(name: OpenNotification, object: nil)
            }
            else if menuDetails.0 == "Wallet".localized
            {
                NotificationCenter.default.post(name: OpenWallet, object: nil)
                
            }else if menuDetails.0 == "Favourites".localized
            {
                NotificationCenter.default.post(name: OpenFavourite, object: nil)
            }
            else if menuDetails.0 == "My Receipts".localized
            {
                NotificationCenter.default.post(name: OpenMyReceipt, object: nil)
            }
            else if menuDetails.0 == "Invite Friends".localized
            {
                NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
            }
            else if menuDetails.0 == "My Ratings".localized
            {
                NotificationCenter.default.post(name: OpenFavourite, object: nil)
            }
            else if menuDetails.0 == "Settings".localized
            {
                NotificationCenter.default.post(name: OpenSetting, object: nil)
            }
            else if menuDetails.0 == "Support".localized
            {
                UtilityClass.setCustomAlert(title: "Info Message".localized, message: "This feature is coming soon") { (index, title) in
                }
                return
            
            }else if menuDetails.0 == "Logout".localized
            {
                self.logoutUser()
            }
            else if menuDetails.0 == "Help".localized
            {
                NotificationCenter.default.post(name: OpenHelp, object: nil)
            }
            
            sideMenuController?.toggle()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let MenuWidth = sideMenuController?.sideViewController.view.frame.width
        return CGSize(width: MenuWidth ?? 0, height: 60)
    }
}

// MARK: - Webservice Methods

extension SideMenuTableViewController {
    
    func webserviceOfTickPayStatus() {
        
        webserviceForTickpayApprovalStatus(SingletonClass.sharedInstance.strPassengerID) { (result, status) in
            
            if (status) {
                print(result)
                
                if let id = (result as! [String:AnyObject])["Verify"] as? String {
                    
                    //                    SingletonClass.sharedInstance.TiCKPayVarifyKey = Int(id)!
                    self.varifyKey = Int(id)!
                }
                else if let id = (result as! [String:AnyObject])["Verify"] as? Int {
                    
                    //                    SingletonClass.sharedInstance.TiCKPayVarifyKey = id
                    self.varifyKey = id
                }
                
            }
            else {
                print(result)
            }
        }
    }
    
}

