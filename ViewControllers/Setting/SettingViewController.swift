//
//  SettingViewController.swift
//  Flicha User
//
//  Created by EWW082 on 10/06/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
    var arrSettings:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCustomNavigationBar(title: kSettingsPageTitle.localized)
        self.arrSettings = ["Push Notification".localized]
    }
    
    //MARK:- Functions / Api calls :
    
    func webserviceCallForUpdateNotificationSetting(notification: Int) {
        
        var dictParam = [String:AnyObject]()
        dictParam["PassengerId"] = "1" as AnyObject
        dictParam["Notification"] = "\(notification)" as AnyObject
        dictParam["InternetAds"] = "\(notification)" as AnyObject
        
        WebserviceForUpdateNotificationSetting(dictParam as AnyObject) { (result, status) in
                
            print(result)
            
            if status == true {
                // Do nothing
                
            } else {
                // Do nothing for now
                
            }
        }
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tblCell = tableView.dequeueReusableCell(withIdentifier: "TblSettingCell") as! TblSettingCell
        tblCell.lblTitle.text = self.arrSettings[indexPath.row]
        tblCell.lblDesc.text = "Allow Push Notifications?"
        tblCell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.50)
        tblCell.contentView.layer.cornerRadius = 15.0
        tblCell.contentView.layer.masksToBounds = true
        tblCell.selectionStyle = .none
        
        tblCell.SwitchAction = {
            if tblCell.btnSwitch.isOn {
                self.webserviceCallForUpdateNotificationSetting(notification: 1)
            } else {
                self.webserviceCallForUpdateNotificationSetting(notification: 0)
            }
        }
        
        return tblCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

class TblSettingCell:UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    @IBOutlet weak var containerView: UIView!
    
    var SwitchAction:(() -> ())?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func btnSwitchAction(_ sender: UISwitch) {
        if let SwitchActionHandler = self.SwitchAction {
            SwitchActionHandler()
        }
    }
    
    
}
