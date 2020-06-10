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


class SideMenuTableViewController: UIViewController, delegateForTiCKPayVerifyStatus {
    
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
    }
    
    func setupView()
    {
        self.navigationController?.isNavigationBarHidden = false
        webserviceOfTickPayStatus()
        
        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String
        {
            if SelectedLanguage == "en"
            {
                // lblLaungageName.text = "SW"
            } else if SelectedLanguage == "sw"
            {
                lblLaungageName.text = "EN"
            }
        }
        
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
        titleAndImages.append(("Home", "homeSelect", "homeUnSelect"))
        titleAndImages.append(("My Ride", "my-ride-unselect", "my-ride-select"))
//        titleAndImages.append(("Payment Method", "payment-unselect", "payment-select"))
        titleAndImages.append(("Notification", "notification-unselect", "notification-select"))
        titleAndImages.append(("Settings", "setting-unselect", "setting-select"))
        titleAndImages.append(("Help", "help-unselect", "help-select"))
        titleAndImages.append(("Logout", "logout-unselect", "logout-select"))
        return titleAndImages
    }
    
    func setLayoutForswahilLanguage()
    {
        UserDefaults.standard.set("sw", forKey: "i18n_language")
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
        RMUniversalAlert.show(in: self, withTitle:appName, message: "Are you sure you want to logout?".localized, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: ["Sign out".localized, "Cancel".localized], tap: {(alert, buttonIndex) in
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
            } else if SelectedLanguage == "sw"
            {
                setLayoutForenglishLanguage()
                lblLaungageName.text = "SW"
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

            if menuDetails.0 == "Home"
            {
                NotificationCenter.default.post(name: OpenHome, object: nil)
                
            }else if menuDetails.0 == "My Ride"
            {
                NotificationCenter.default.post(name: OpenMyBooking, object: nil)
                
            }else if menuDetails.0 == "Payment Method"
            {
                NotificationCenter.default.post(name: OpenPaymentOption, object: nil)
                
            }else if menuDetails.0 == "Notification"
            {
                let notificationVC = PaymentMethodStoryBoard.instantiateViewController(withIdentifier: "NotificationsViewController")
                self.navigationController?.pushViewController(notificationVC, animated: true)
            }
            else if menuDetails.0 == "Wallet"
            {
                NotificationCenter.default.post(name: OpenWallet, object: nil)
                
            }else if menuDetails.0 == "Favourites"
            {
                NotificationCenter.default.post(name: OpenFavourite, object: nil)
            }
            else if menuDetails.0 == "My Receipts"
            {
                NotificationCenter.default.post(name: OpenMyReceipt, object: nil)
            }
            else if menuDetails.0 == "Invite Friends"
            {
                NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
            }
            else if menuDetails.0 == "My Ratings"
            {
                NotificationCenter.default.post(name: OpenFavourite, object: nil)
            }
            else if menuDetails.0 == "Settings"
            {
                NotificationCenter.default.post(name: OpenSetting, object: nil)
            }
            else if menuDetails.0 == "Support"
            {
                UtilityClass.setCustomAlert(title: "Info Message".localized, message: "This feature is coming soon") { (index, title) in
                }
                return
            
            }else if menuDetails.0 == "Logout"
            {
                self.logoutUser()
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

