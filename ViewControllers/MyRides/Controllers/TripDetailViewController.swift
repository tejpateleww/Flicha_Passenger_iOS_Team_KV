//
//  TripDetailViewController.swift
//  Flicha User
//
//  Created by EWW082 on 10/06/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class TripDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView_TripDetails: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK:- Properties
    var arr_TripDetails : [String] = ["Pickup Time","DropOff Time","Vehicle type","Payment Type","Booking Fee","Trip Fare","Distance Fare","Tax"]
//    var arr_TripDetailss
    
    //MARKL- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // clearLbls()
        self.addCustomNavigationBar(title: "Trip Detail")
    }
    
    override func viewDidLayoutSubviews() {
       
    }
    
    
    //MARK:- Events:
    
    @IBAction func btnAction_OKPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Functions:
    
    
    //MARK:- Tableview DatasourceDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Dynamic arr count from tripdetails + 2 (first for locations and last for 'grand total/ok btn'
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let topCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailTopCell", for: indexPath) as! TripDetailTopCell
            topCell.lbl_SourceAddress.text = "Address"
            topCell.imgView_SeperatorLinePAth.clipsToBounds = false
            
            topCell.preservesSuperviewLayoutMargins = false
            topCell.contentView.preservesSuperviewLayoutMargins = false
            return topCell
            
        } else if indexPath.row == arr_TripDetails.count + 1 {
            let bottomCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailBottomCell", for: indexPath) as! TripDetailBottomCell
            bottomCell.lbl_GrandTotal.text = "DA2000"
            bottomCell.OkAction = {
                self.navigationController?.popViewController(animated: true)
            }
            return bottomCell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailCell", for: indexPath) as! TripDetailCell
            cell.lbl_TripDetail.text = arr_TripDetails[indexPath.row-1]
            cell.lbl_TripDescription.text = "Description"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 140
            
        case (arr_TripDetails.count + 1):
            return 170
            
        default:
            return 70
        }
    }
    
}


class TripDetailTopCell : UITableViewCell {
    
    //Properties:
    @IBOutlet weak var vw_AddressContainer: UIView!
    @IBOutlet weak var lbl_SourceAddress: UILabel!
    @IBOutlet weak var lbl_DestinationAddress: UILabel!
    @IBOutlet weak var imgView_SeperatorLinePAth: UIImageView!
    
    override class func awakeFromNib() {
           super.awakeFromNib()
        
        
        
       }
}


class TripDetailCell : UITableViewCell {

    //Properties:
    @IBOutlet weak var lbl_TripDetail: UILabel!
    @IBOutlet weak var lbl_TripDescription: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
}

class TripDetailBottomCell : UITableViewCell {

    //Properties:
    @IBOutlet weak var lbl_GrandTotal: UILabel!
    @IBOutlet weak var btn_Ok: ThemeButton!
    
    var OkAction:(() -> ())?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    @IBAction func btnAction_OKPressed(_ sender: Any) {
        if let OkActionHandler = self.OkAction {
            OkActionHandler()
        }
    }
    
}
