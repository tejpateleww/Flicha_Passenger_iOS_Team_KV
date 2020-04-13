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

    var ProfileData = NSDictionary()
    var strSelectedLaungage = String()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        
        self.setupView()
        webserviceOfTickPayStatus()
        ProfileData = SingletonClass.sharedInstance.dictProfile
        self.imgProfile.sd_setImage(with: URL(string: ProfileData.object(forKey: "Image") as! String), completed: nil)
        self.lblName.text = ProfileData.object(forKey: "Fullname") as? String
        self.lblMobileNumber.text = ProfileData.object(forKey: "MobileNo") as? String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView()
    {
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.SetRating), name: NSNotification.Name(rawValue: "rating"), object: nil)
      
        self.lblName.font = UIFont.bold(ofSize: 17)
        self.lblName.textColor = UIColor.white
        self.lblMobileNumber.font = UIFont.regular(ofSize: 12)
        self.lblMobileNumber.textColor = themeGrayTextColor
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.width / 2
        self.imgProfile.layer.borderWidth = 1.0
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.masksToBounds = true
        
        self.headerView.backgroundColor = themeBlueLightColor
        self.view.backgroundColor = themeBlueColor
        self.headerView.roundCorners(with: .layerMaxXMaxYCorner, radius: 65)
    }
    
    func getMenuCellDetails() -> [(String,String,String)]
    {
        var titleAndImages = [(String,String,String)]()
        
        titleAndImages.append(("Home", "homeSelect", "homeUnSelect"))
        titleAndImages.append(("My Ride", "my-ride-unselect", "my-ride-select"))
        titleAndImages.append(("Payment Method", "payment-unselect", "payment-select"))
        titleAndImages.append(("Notification", "noification-select", "noification-select"))
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
    
    func giveGradientColor()
    {
        let colorTop =  UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let colorMiddle =  UIColor(red: 36/255, green: 24/255, blue: 3/255, alpha: 0.5).cgColor
        let colorBottom = UIColor(red: 64/255, green: 43/255, blue: 6/255, alpha: 0.8).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorMiddle, colorBottom]
        gradientLayer.locations = [ 0.0, 0.5, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
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
    
    // MARK: - Table view data source
    
    /*
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else
        {
            return arrMenuIcons.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.section == 0)
        {
            let cellHeader = tableView.dequeueReusableCell(withIdentifier: "MainHeaderTableViewCell") as! MainHeaderTableViewCell
            cellHeader.selectionStyle = .none
            cellHeader.imgProfile.layer.cornerRadius = cellHeader.imgProfile.frame.width / 2
            cellHeader.imgProfile.layer.borderWidth = 1.0
            cellHeader.imgProfile.layer.borderColor = UIColor.white.cgColor
            cellHeader.imgProfile.layer.masksToBounds = true
            
            cellHeader.imgProfile.sd_setImage(with: URL(string: ProfileData.object(forKey: "Image") as! String), completed: nil)
            cellHeader.lblName.text = ProfileData.object(forKey: "Fullname") as? String
            
            cellHeader.lblMobileNumber.text = ProfileData.object(forKey: "MobileNo") as? String
            cellHeader.lblRating.text = SingletonClass.sharedInstance.passengerRating
            
            return cellHeader
        }
        else
        {
            let cellMenu = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell") as! ContentTableViewCell
            
            cellMenu.imgDetail?.image = UIImage.init(named:  "\(arrMenuIcons[indexPath.row])")
            cellMenu.selectionStyle = .none
            
            cellMenu.lblTitle.text = arrMenuTitle[indexPath.row]
            
            return cellMenu
        }
        
        
        // Configure the cell...
        
        //        return cellHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            self.navigationController?.pushViewController(next, animated: true)
            
        }
        else if (indexPath.section == 1)
        {
            if arrMenuTitle[indexPath.row] == "New Booking" {
                NotificationCenter.default.post(name: NotificationForBookingNewTrip, object: nil)
                sideMenuController?.toggle()
                
            }
            if arrMenuTitle[indexPath.row] == "My Booking"
            {
                NotificationCenter.default.post(name: OpenMyBooking, object: nil)
                sideMenuController?.toggle()
            }
            
            if arrMenuTitle[indexPath.row] == "Payment Options" {
                NotificationCenter.default.post(name: OpenPaymentOption, object: nil)
                sideMenuController?.toggle()
            }
            else if arrMenuTitle[indexPath.row] == "Wallet" {
                NotificationCenter.default.post(name: OpenWallet, object: nil)
                sideMenuController?.toggle()
            }
            else if arrMenuTitle[indexPath.row] == "Favourites" {
                NotificationCenter.default.post(name: OpenFavourite, object: nil)
                sideMenuController?.toggle()
            }
            else if arrMenuTitle[indexPath.row] == "My Receipts" {
                NotificationCenter.default.post(name: OpenMyReceipt, object: nil)
                sideMenuController?.toggle()
            }
            else if arrMenuTitle[indexPath.row] == "Invite Friends" {
                NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
                sideMenuController?.toggle()
            }
            else if arrMenuTitle[indexPath.row] == "Settings" {
                NotificationCenter.default.post(name: OpenSetting, object: nil)
                sideMenuController?.toggle()
            }
            else if arrMenuTitle[indexPath.row] == "Become a \(appName) Driver" {
                UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/pick-n-go-driver/id1320783710?mt=8")! as URL)
            }
            else if arrMenuTitle[indexPath.row] == "Package History"
            {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "PackageHistoryViewController") as! PackageHistoryViewController
                self.navigationController?.pushViewController(next, animated: true)
            }
            
            
            if (arrMenuTitle[indexPath.row] == "LogOut")
            {
                self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                
                UserDefaults.standard.removeObject(forKey: "Passcode")
                SingletonClass.sharedInstance.setPasscode = ""
                
                UserDefaults.standard.removeObject(forKey: "isPasscodeON")
                SingletonClass.sharedInstance.isPasscodeON = false
                
            }
            //            else if (indexPath.row == arrMenuTitle.count - 2)
            //            {
            //                self.performSegue(withIdentifier: "pushToBlank", sender: self)
            //            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0)
        {
            return 130
        }
        else
        {
            return 42
        }
    }
    */
    
    
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
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    var varifyKey = Int()
    func webserviceOfTickPayStatus() {
        
        webserviceForTickpayApprovalStatus(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
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
            
            if menuDetails.0 == "My Ride"     //"My Bookings"
            {
                NotificationCenter.default.post(name: OpenMyBooking, object: nil)
                sideMenuController?.toggle()
                
            }else if menuDetails.0 == "Payment Method"
            {
                NotificationCenter.default.post(name: OpenPaymentOption, object: nil)
                sideMenuController?.toggle()
                
            }else if menuDetails.0 == "Wallet"
            {
                NotificationCenter.default.post(name: OpenWallet, object: nil)
                sideMenuController?.toggle()
                
            }else if menuDetails.0 == "Favourites"
            {
                NotificationCenter.default.post(name: OpenFavourite, object: nil)
                sideMenuController?.toggle()
            }
            else if menuDetails.0 == "My Receipts"
            {
                NotificationCenter.default.post(name: OpenMyReceipt, object: nil)
                sideMenuController?.toggle()
            }
            else if menuDetails.0 == "Invite Friends"
            {
                NotificationCenter.default.post(name: OpenInviteFriend, object: nil)
                sideMenuController?.toggle()
            }
            else if menuDetails.0 == "My Ratings"
            {
                NotificationCenter.default.post(name: OpenFavourite, object: nil)
                sideMenuController?.toggle()
            }
            else if menuDetails.0 == "Legal"
            {
                NotificationCenter.default.post(name: OpenSetting, object: nil)
                sideMenuController?.toggle()
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
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let MenuWidth = sideMenuController?.sideViewController.view.frame.width
        return CGSize(width: MenuWidth ?? 0, height: 50)
    }
}

