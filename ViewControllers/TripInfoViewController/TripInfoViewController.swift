
//
//  TripInfoCompletedTripVC.swift
//  TiCKTOC-Driver
//
//  Created by Excellent Webworld on 06/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class TripInfoViewController: BaseViewController,delegatePesapalWebView//,delegateRateGiven
{
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    var delegate: delegateRateGiven!
    @IBOutlet var btnViewCompleteTripData: UIView!

    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    
    @IBOutlet weak var lblBaseFareTitle: UILabel!
    @IBOutlet weak var lblDiatnceFareTitle: UILabel!
    @IBOutlet weak var lblWaitingTimeCostTitle: UILabel!
    @IBOutlet weak var lblTollFeeTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblGrandTotalTitle: UILabel!
   
    
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblDiatnceFare: UILabel!
    @IBOutlet weak var lblWaitingTimeCost: UILabel!
    @IBOutlet var lblTollFee: UILabel!
    @IBOutlet var lblTax: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var stackViewPomocide: UIStackView!
    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    @IBOutlet weak var stackViewNote: UIStackView!
    @IBOutlet weak var lblExtraCharges: UILabel!
    
//    var delegate: delegateRateGiven!
    @IBOutlet weak var lblPromocodeType: UILabel!
    var dictData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCustomNavigationBar(title: "Trip Detail")
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        setLocalizaton()
        setData()
    }
      
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        btnViewCompleteTripData.layer.cornerRadius = 10
        btnViewCompleteTripData.layer.masksToBounds = true
    }

    func setLocalizaton(){
        lblPickupLocation.text = "Address".localized
        lblDropOffLocation.text = "Address".localized
        
        lblBaseFareTitle.text = "Base Fare".localized
        lblDiatnceFareTitle.text = "Distance Fare".localized
        lblWaitingTimeCostTitle.text = "Waiting Cost".localized
        lblTollFeeTitle.text = "Toll Fee".localized
        lblTaxTitle.text = "Tax".localized
        lblGrandTotalTitle.text = "Grand Total"
        
        if dictData.object(forKey: "PaymentType") as! String != "pesapal"
        {
            btnOK.setTitle("OK".localized, for: .normal)
        }
        else
        {
            btnOK.setTitle("Make Payment".localized, for: .normal)
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    func setData() {
        
//        dictData = NSMutableDictionary(dictionary: (dictData.object(forKey: "details") as! NSDictionary))
        print(dictData)
        
        lblTollFee.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TollFee") as? String))) ? "\(String(describing: dictData.object(forKey: "TollFee") as! String)) \(currencySign)": "-"
        lblPickupLocation.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "PickupLocation") as? String ))) ? (dictData.object(forKey: "PickupLocation") as? String ) : "-"
        lblDropOffLocation.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "DropoffLocation") as? String))) ?(dictData.object(forKey: "DropoffLocation") as? String): "-"
        lblGrandTotal.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "GrandTotal") as? String))) ? "\(String(describing: dictData.object(forKey: "GrandTotal") as! String)) \(currencySign)": "-"
        lblBaseFare.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripFare") as? String))) ? "\(String(describing: dictData.object(forKey: "TripFare") as! String)) \(currencySign)": "-"
        lblWaitingTimeCost.text = "\(dictData.object(forKey: "WaitingTimeCost") as! String) \(currencySign)"
        lblDiatnceFare.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "DistanceFare") as? String))) ? "\(String(describing: dictData.object(forKey: "DistanceFare") as! String)) \(currencySign)": "-"
        lblTax.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "Tax") as? String))) ? "\(dictData.object(forKey: "Tax") as! String) \(currencySign)": "-"

        
//        lblbookingID.text = "\("Booking Id :".localized) \(dictData.object(forKey: "Id") as! Int)"
//        lblTripStatus.text = dictData.object(forKey: "Status") as? String
        
        if((!UtilityClass.isEmpty(str: (dictData.object(forKey: "PromoCode") as? String))))
        {
            lblPromocodeType.text = "\(String(describing: dictData.object(forKey: "PromoCode") as! String)) applied: "
            stackViewPomocide.isHidden = false

        }
//        lblBookingCharge.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "BookingCharge") as? String))) ? "\(String(describing: dictData.object(forKey: "BookingCharge") as! String)) \(currencySign)": "0.0 \(currencySign)"
        
        let PickTime = Double(dictData.object(forKey: "PickupTime") as! String)
        let dropoffTime = Double(dictData.object(forKey: "DropTime") as! String)
        let unixTimestamp = PickTime //as Double//as! Double//dictData.object(forKey: "PickupTime")
        let unixTimestampDrop = dropoffTime
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp!))
        let dateDrop = Date(timeIntervalSince1970: TimeInterval(unixTimestampDrop!))
        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        //        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm" //Specify your format that you want
        //let strDate = dateFormatter.string(from: date)
        //let strDateDrop = dateFormatter.string(from: dateDrop)
//        lblDate.text = strDate
        
//        lblPickTime.text = strDate
//        lblDropTime.text = strDateDrop
//        lblPaymentType.text = dictData.object(forKey: "PaymentType") as! String
        
//        lblFlightNumber.text = strDate//dictData.object(forKey: "PickupDateTime") as? String
//
//        lblNote.text = strDateDrop //dictData.object(forKey: "PickupDateTime") as? String
        
        if((!UtilityClass.isEmpty(str: (dictData.object(forKey: "Discount") as? String))))
        {
//            lblDiscount.text = " \(String(describing: dictData.object(forKey: "Discount") as! String)) \(currencySign)"
//            stackViewPomocide.isHidden = false
        }
        //        lblTripDistance.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String))) ? (dictData.object(forKey: "TripDistance") as? String): "0.00"

//                lblTripDistance.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String))) ? (dictData.object(forKey: "TripDistance") as? String): "0.00"

       // let strTemp = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "TripDistance") as? String ))) ?  (dictData.object(forKey: "TripDistance") as! String ) : "0.00 km"

//        let distaceFloat = Float(strTemp)
//        let doubleStr = String(format: "%.2f", distaceFloat!)
//        lblTripDistance.text = (doubleStr != nil) ? "\(doubleStr) km" : "0.00 km"


//          lblWaitingTime.text = dictData.object(forKey: "WaitingTime") as? String
//        lblExtraCharges.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "ExtraCharges") as? String))) ? " \(String(describing: dictData.object(forKey: "ExtraCharges") as! String))": "-"


        //let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int((dictData.object(forKey: "WaitingTime") as? String)!) ?? 0)
        //lblWaitingTime.text = "\(getStringFrom(seconds: h)):\(getStringFrom(seconds: m)):\(getStringFrom(seconds: s))"
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBAction func btnOK(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
//        if SingletonClass.sharedInstance.passengerType == "other" || SingletonClass.sharedInstance.passengerType == "others"
//        {
////            self.completeTripInfo()
//            self.delegate.delegateforGivingRate()
//        }
//        else
//        {
//            self.delegate.delegateforGivingRate()

//        }
//         SingletonClass.sharedInstance.passengerType = ""
        
        if (btnOK.titleLabel?.text) != "Make Payment".localized//dictData.object(forKey: "PaymentType") as! String != "pesapal"
        {
            self.delegate.delegateforGivingRate()
        }
        else
        {
//            btnOK.setTitle("Make Payment".localized, for: .normal)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
            next.delegate = self
            let Amount = String((lblGrandTotal.text)!.replacingOccurrences(of: currencySign, with: "").trimmingCharacters(in: .whitespacesAndNewlines))//(lblGrandTotal.text?.replacingOccurrences(of: currencySign, with: ""))?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let url = "https://www.tantaxitanzania.com/pesapal/add_money/\(SingletonClass.sharedInstance.strPassengerID)/\("\(Amount)")/passenger"
            next.strUrl = url
//            self.present(next, animated: true, completion: nil)
self.navigationController?.pushViewController(next, animated: true)
//            let navController = UINavigationController.init(rootViewController: next)
//            UIApplication.shared.keyWindow?.rootViewController?.present(navController, animated: true, completion: nil)
        }

    }
    func didOrderPesapalStatus(status: Bool)
    {
        if status
        {
            self.btnOK.setTitle("OK", for: .normal)
            self.delegate.delegateforGivingRate()
        }
        else
        {
            self.btnOK.setTitle("Make Payment", for: .normal)
        }
    }
}
