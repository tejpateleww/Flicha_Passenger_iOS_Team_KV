
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
    @IBOutlet var btnViewCompleteTripData: UIView!
    @IBOutlet weak var lblPickUpLocationTitle: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var lblDropUpLocationTitle: UILabel!
    @IBOutlet weak var lblDropOffLocation: UILabel!
    @IBOutlet weak var lblTollFeeTitle: UILabel!
    @IBOutlet weak var lblTaxTitle: UILabel!
    @IBOutlet weak var lblGrandTotalTitle: UILabel!
    @IBOutlet weak var lblBaseFareTitle: UILabel!
    @IBOutlet weak var lblBaseFare: UILabel!
    @IBOutlet weak var lblDiatnceFareTitle: UILabel!
    @IBOutlet weak var lblDiatnceFare: UILabel!
    @IBOutlet weak var lblWaitingTimeCostTitle: UILabel!
    @IBOutlet weak var lblWaitingTimeCost: UILabel!
    @IBOutlet var lblTollFee: UILabel!
    @IBOutlet var lblTax: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var stackViewPomocide: UIStackView!
    @IBOutlet weak var stackViewFlightNumber: UIStackView!
    @IBOutlet weak var stackViewNote: UIStackView!
    @IBOutlet weak var lblExtraCharges: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblPromocodeType: UILabel!
    
    var dictData = NSDictionary()
    var delegate: delegateRateGiven!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCustomNavigationBar(title: "Trip Detail")
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        self.setupView()
    }
    
    func setupView() {
        
        self.lblPickUpLocationTitle.applyCustomTheme(title: "From".localized, textColor: themeGrayTextColor, fontStyle: UIFont.regular(ofSize: 12))
        self.lblPickupLocation.applyCustomTheme(title: "", textColor: themeBlackColor, fontStyle: UIFont.regular(ofSize: 12))
        
        self.lblDropUpLocationTitle.applyCustomTheme(title: "To".localized, textColor: themeGrayTextColor, fontStyle: UIFont.regular(ofSize: 12))
        self.lblDropOffLocation.applyCustomTheme(title: "", textColor: themeBlackColor, fontStyle: UIFont.regular(ofSize: 12))
        
        let regularFontSize = UIFont.regular(ofSize: 14)
        let boldFontSize =  UIFont.bold(ofSize: 14)
        
        self.lblBaseFareTitle.applyCustomTheme(title: "Base Fare".localized, textColor: themeBlackColor, fontStyle: regularFontSize)
        self.lblBaseFare.applyCustomTheme(title: "".localized, textColor: themeBlackColor, fontStyle: regularFontSize)
        
        self.lblDiatnceFareTitle.applyCustomTheme(title: "Distance Fare".localized, textColor: themeBlackColor, fontStyle: regularFontSize)
        self.lblDiatnceFare.applyCustomTheme(title: "", textColor: themeBlackColor, fontStyle: regularFontSize)
        
        self.lblWaitingTimeCostTitle.applyCustomTheme(title: "Waiting Cost".localized, textColor: themeBlackColor, fontStyle: regularFontSize)
        self.lblWaitingTimeCost.applyCustomTheme(title: "", textColor: themeBlackColor, fontStyle: regularFontSize)
        
        self.lblTollFeeTitle.applyCustomTheme(title: "Toll Fee".localized, textColor: themeBlackColor, fontStyle: regularFontSize)
        self.lblTollFee.applyCustomTheme(title: "", textColor: themeBlackColor, fontStyle: regularFontSize)
        
        self.lblTaxTitle.applyCustomTheme(title: "Tax".localized, textColor: themeBlackColor, fontStyle: regularFontSize)
        self.lblTax.applyCustomTheme(title: "", textColor: themeBlackColor, fontStyle: regularFontSize)
        
        self.lblGrandTotalTitle.applyCustomTheme(title: "Grand Total".localized, textColor: themeBlackColor, fontStyle: boldFontSize)
        self.lblGrandTotal.applyCustomTheme(title: "", textColor: themeBlackColor, fontStyle: boldFontSize)
        
        if let paymentType = dictData.object(forKey: "PaymentType") as? String, paymentType != "pesapal"
        {
            btnOK.setTitle("OK".localized, for: .normal)
        }
        else
        {
            btnOK.setTitle("Make Payment".localized, for: .normal)
        }
        setData()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        btnViewCompleteTripData.layer.cornerRadius = 10
        btnViewCompleteTripData.layer.masksToBounds = true
    }
    
    // MARK: - Custom Methods
    func setData()
    {
        lblPickupLocation.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "PickupLocation") as? String ))) ? (dictData.object(forKey: "PickupLocation") as? String ) : "-"
        lblDropOffLocation.text = (!UtilityClass.isEmpty(str: (dictData.object(forKey: "DropoffLocation") as? String))) ?(dictData.object(forKey: "DropoffLocation") as? String): "-"
        
        if let strBaseFare = dictData.object(forKey: "TripFare") as? String, strBaseFare.count > 0
        {
            lblBaseFare.text = strBaseFare.currencyInputFormatting()
        }else
        {
            lblBaseFare.text = "-"
        }
        
        if let strDistanceFare = dictData.object(forKey: "DistanceFare") as? String, let amountValue = strDistanceFare.currencyInputFormatting() as String? , amountValue != ""
        {
            lblDiatnceFare.text = amountValue
        }else
        {
            lblDiatnceFare.text = "-"
        }
        
        if let strWaitingTimeCost = dictData.object(forKey: "WaitingTimeCost") as? String, let amountValue = strWaitingTimeCost.currencyInputFormatting() as String? , amountValue != ""
        {
            lblWaitingTimeCost.text = amountValue
        }else
        {
            lblWaitingTimeCost.text = "-"
        }
        
        if let strTollFee = dictData.object(forKey: "TollFee") as? String, let amountValue = strTollFee.currencyInputFormatting() as String? , amountValue != ""
        {
            lblTollFee.text = amountValue
        }else
        {
            lblTollFee.text = "-"
        }
        
        if let strTax = dictData.object(forKey: "Tax") as? String, let amountValue = strTax.currencyInputFormatting() as String? , amountValue != ""
        {
            lblTax.text = amountValue
        }else
        {
            lblTax.text = "-"
        }
        
        if let strGrandTotal = dictData.object(forKey: "GrandTotal") as? String, let amountValue = strGrandTotal.currencyInputFormatting() as String? , amountValue != ""
        {
            lblGrandTotal.text = amountValue
        }else
        {
            lblGrandTotal.text = "-"
        }
        
        if((!UtilityClass.isEmpty(str: (dictData.object(forKey: "PromoCode") as? String))))
        {
            lblPromocodeType.text = "\(String(describing: dictData.object(forKey: "PromoCode") as! String)) applied: "
            stackViewPomocide.isHidden = false
        }
    }
    
    @IBAction func btnOK(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
        if (btnOK.titleLabel?.text) != "Make Payment".localized//dictData.object(forKey: "PaymentType") as! String != "pesapal"
        {
            self.delegate.delegateforGivingRate()
        }
        else
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
            next.delegate = self
            let Amount = String((lblGrandTotal.text)!.replacingOccurrences(of: currencySign, with: "").trimmingCharacters(in: .whitespacesAndNewlines))
            
            let url = "https://www.tantaxitanzania.com/pesapal/add_money/\(SingletonClass.sharedInstance.strPassengerID)/\("\(Amount)")/passenger"
            next.strUrl = url
            self.navigationController?.pushViewController(next, animated: true)
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
