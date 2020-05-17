//
//  TripDetailsViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TripDetailsViewController: BaseViewController {

    var arrData = NSMutableArray()
    let dictData = NSMutableDictionary()
    var delegate: CompleterTripInfoDelegate!
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------

    @IBOutlet weak var lblPickUpTitle: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDistanceFare: UILabel!
    @IBOutlet weak var lblNightFare: UILabel!
    @IBOutlet weak var lblTollFee: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblBookingCharge: UILabel!
    @IBOutlet weak var lblSpecialExtraCharge: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var stackViewSpecialExtraCharge: UIStackView!
    @IBOutlet weak var tblObject : UITableView!
    @IBOutlet weak var lblDropuplocation: UILabel!
    @IBOutlet weak var lblDrpupLocationDetail: UILabel!
    @IBOutlet weak var lblBaseFareDesc: UILabel!
    @IBOutlet weak var lblBaseFareTitle: UILabel!
    @IBOutlet weak var lblDistanceFareTitle: UILabel!
    @IBOutlet weak var lblNightFareTitle: UILabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblGrandTotalTitle: UILabel!
    @IBOutlet weak var lblDiscountTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var txtSpecialExtrsCharging: UILabel!
    @IBOutlet weak var lblBookingChargeTitle: UILabel!
    @IBOutlet weak var lblTollFreeTitle: UILabel!
    @IBOutlet weak var lblWaitingCostTitle: UILabel!
    @IBOutlet weak var btnCall: UIButton!

    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        setTripDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalization()
    }
    
    func setLocalization()
    {
        lblPickUpTitle.text = "Pickup Location".localized
        lblDistanceFareTitle.text = "Dropoff Location".localized
        lblBaseFareTitle.text = "Distance Fare:".localized
        lblDistanceFareTitle.text = "Distance Fare:".localized
        lblNightFare.text = "Night Fare:".localized
        lblTollFreeTitle.text = "Toll Fee".localized
        lblSubTotalTitle.text = "Sub Total".localized
        lblBookingChargeTitle.text = "Booking Charge".localized
        lblTaxTitle.text = "Toll Fee".localized
        lblGrandTotalTitle.text = "Grand Total".localized
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setTripDetails()
    {
        if let data = arrData.object(at: 0) as? NSDictionary {
            
            let distanceFare = "\(data.object(forKey: "DistanceFare")!) (\(data.object(forKey: "TripDistance")!) km)"
            
            lblPickupLocation.text = data.object(forKey: "PickupLocation") as? String
            lblDistanceFare.text = distanceFare
            lblNightFare.text = data.object(forKey: "NightFare") as? String
            lblTollFee.text = data.object(forKey: "TollFee") as? String
            lblSubTotal.text = data.object(forKey: "SubTotal") as? String
            lblBookingCharge.text = data.object(forKey: "BookingCharge") as? String
            lblTax.text = data.object(forKey: "Tax") as? String
            lblGrandTotal.text = data.object(forKey: "GrandTotal") as? String
            
            var strSpecial = ""
            if let special = data.object(forKey: "Special") as? String
            {
                strSpecial = special
                
            } else if let special = data.object(forKey: "Special") as? Int
            {
                strSpecial = String(special)
            }
            
            stackViewSpecialExtraCharge.isHidden = true
            if strSpecial == "1"
            {
                stackViewSpecialExtraCharge.isHidden = false
                lblSpecialExtraCharge.text = data.object(forKey: "SpecialExtraCharge") as? String
            }
        }
    }
   
    @IBAction func btCallClicked(_ sender: UIButton)
    {
        let contactNumber = helpLineNumber
        if contactNumber == ""
        {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
           
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    private func callNumber(phoneNumber:String)
    {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
   
}
    
   
