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
    var arr_TripDetails : [String] = ["Pickup Time","DropOff Time","Vehicle Type","Payment Type","Booking Fare","Trip Fare","Distance Fare","Tax"]
    var arr_TripDescriptions : [String: Any] = [:]
    
    //MARKL- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // clearLbls()
        self.addCustomNavigationBar(title: "Trip Detail".localized)
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
        
        
        print(arr_TripDescriptions)
        
        if indexPath.row == 0 {
            let topCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailTopCell", for: indexPath) as! TripDetailTopCell
            
            topCell.lbl_From.text = "From".localized
            topCell.lbl_To.text = "To".localized
            
            topCell.lbl_SourceAddress.text = arr_TripDescriptions["PickupLocation"] as? String
            topCell.lbl_DestinationAddress.text = arr_TripDescriptions["DropoffLocation"] as? String
            topCell.imgView_SeperatorLinePAth.clipsToBounds = false
            
            topCell.preservesSuperviewLayoutMargins = false
            topCell.contentView.preservesSuperviewLayoutMargins = false
            return topCell
            
        } else if indexPath.row == arr_TripDetails.count + 1 {
            let bottomCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailBottomCell", for: indexPath) as! TripDetailBottomCell
            
            bottomCell.lbl_textGrandTotal.text = "Grand Total (Tax Included)".localized
            
            bottomCell.lbl_GrandTotal.text = "\(arr_TripDescriptions["GrandTotal"] as? String ?? "") DA"
            bottomCell.OkAction = {
                self.navigationController?.popViewController(animated: true)
            }
            return bottomCell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailCell", for: indexPath) as! TripDetailCell
            let text = (arr_TripDetails[indexPath.row-1])
            cell.lbl_TripDetail.text = text.localized
            let field = text
        
            switch field {
            case "Pickup Time":
                if let pickupDateAndTimee = arr_TripDescriptions["PickupTime"] as? String {
                    let timeStamp = Double(pickupDateAndTimee)
                    let date = Date(timeIntervalSince1970: timeStamp!)
                    let dateStr = date.toString(dateFormat: "dd MMM YYYY, hh:mm a")
                    cell.lbl_TripDescription.text = dateStr
                }
                
            case "DropOff Time":
                if let pickupDateAndTimee = arr_TripDescriptions["DropTime"] as? String {
                    let timeStamp = Double(pickupDateAndTimee)
                    let date = Date(timeIntervalSince1970: timeStamp!)
                    let dateStr = date.toString(dateFormat: "dd MMM YYYY, hh:mm a")
                    cell.lbl_TripDescription.text = dateStr
                }
                
            case "Vehicle Type":
                cell.lbl_TripDescription.text = arr_TripDescriptions["Model"] as? String
                
            case "Payment Type":
                cell.lbl_TripDescription.text = arr_TripDescriptions["PaymentType"] as? String
                
            case "Booking Fare":
                cell.lbl_TripDescription.text = "DA \(arr_TripDescriptions["BookingCharge"] as? String ?? "")"
                
            case "Trip Fare":
                cell.lbl_TripDescription.text = "DA \(arr_TripDescriptions["TripFare"] as? String ?? "")"
                
            case "Distance Fare":
                cell.lbl_TripDescription.text = "DA \(arr_TripDescriptions["DistanceFare"] as? String ?? "")"
                
            case "Tax":
                cell.lbl_TripDescription.text = "DA \(arr_TripDescriptions["Tax"] as? String ?? "")"
                
            
            default:
                cell.lbl_TripDescription.text = "-"
            }
            
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
    @IBOutlet weak var lbl_From: UILabel!
    @IBOutlet weak var lbl_To: UILabel!
    
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
    
    @IBOutlet weak var lbl_textGrandTotal: UILabel!
    
    
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
