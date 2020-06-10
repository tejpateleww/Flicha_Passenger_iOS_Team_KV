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
        self.addCustomNavigationBar(title: kSettingsPageTitle)
        self.arrSettings = ["Push Notification"]
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tblCell = tableView.dequeueReusableCell(withIdentifier: "TblSettingCell") as! TblSettingCell
        tblCell.lblTitle.text = self.arrSettings[indexPath.row]
        tblCell.lblDesc.text = "This is test Wording, Allow Push Notifications"
        tblCell.containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.50)
        tblCell.containerView.layer.cornerRadius = 15.0
        tblCell.containerView.layer.masksToBounds = true
        tblCell.selectionStyle = .none
        return tblCell
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
