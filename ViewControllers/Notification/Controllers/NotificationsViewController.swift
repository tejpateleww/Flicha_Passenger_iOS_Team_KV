//
//  NotificationsViewController.swift
//  Flicha User
//
//  Created by Mehul Panchal on 15/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var arrayNotificationsList : [[String:AnyObject]]? = nil
    private let CellID = "NotificationsAlertTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.addCustomNavigationBar(title: kNotificationsPageTitle)
        self.tableView.register(UINib(nibName: "NotificationsAlertTableViewCell", bundle: nil), forCellReuseIdentifier: CellID)
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addCustomNavigationBar(title: kNotificationsPageTitle)
        self.getNotificationsList()
    }
    
    func getNotificationIconImageName(notificationType : String) -> String {
    
        if notificationType.lowercased() == "CompleteBooking".lowercased()
        {
            return "blueRightTick"
       
        }else if notificationType.lowercased() == "CancelBooking".lowercased()
        {
            return "redCross"
            
        }else
        {
            return "blueWallet"
        }
        
    }
    
}

// MARK: - TableView Delegate and DataSoruce Methods

extension NotificationsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayNotificationsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! NotificationsAlertTableViewCell
        cell.selectionStyle = .none
        
        if let notficationInfo = self.arrayNotificationsList?[indexPath.row]
        {
            cell.lblTitle.text = notficationInfo["NotificationName"] as? String ?? ""
            cell.lblDescriptions.text = notficationInfo["Description"] as? String ?? ""
            
            if let notificationType = notficationInfo["NotificationType"] as? String
            {
                cell.imgIcon.image = UIImage(named: self.getNotificationIconImageName(notificationType: notificationType))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}


// MARK: - Webservice Methods

extension NotificationsViewController
{
    func getNotificationsList() {
        
        webserviceForNotificationList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status)
            {
                if let cardList = (result as? NSDictionary)?.object(forKey: "data") as? [[String:AnyObject]]
                {
                    self.arrayNotificationsList = cardList
                    self.tableView.reloadData()
                }
            }
            else
            {
                if let res = result as? String
                {
                    UtilityClass.setCustomAlert(title: "Error", message: res.firstCharacterUpperCase()) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary
                {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray
                {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
}
