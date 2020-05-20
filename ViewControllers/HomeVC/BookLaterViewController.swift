//
//  BookLaterViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 04/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import M13Checkbox
import GoogleMaps
import GooglePlaces
import SDWebImage
import FormTextField
import ACFloatingTextfield_Swift
import IQKeyboardManagerSwift

protocol isHaveCardFromBookLaterDelegate {
    func didHaveCards()
}

class BookLaterViewController: BaseViewController, UINavigationControllerDelegate, isHaveCardFromBookLaterDelegate {
   
    // MARK: - Outlets
    
    @IBOutlet weak var fromLocationView: UIStackView!
    @IBOutlet weak var toLocationView: UIStackView!
    
    @IBOutlet weak var lblUserFromAddress: UILabel!
    @IBOutlet weak var lblUserToAddress: UILabel!
    
    @IBOutlet weak var imgCareModel: UIImageView!
    @IBOutlet weak var lblCareModelClass: UILabel!

    @IBOutlet weak var lblFullNameTitle: UILabel!
    @IBOutlet weak var txtFullName: ThemeTextField!
    
    @IBOutlet weak var lblMobileNumTitle: UILabel!
    @IBOutlet weak var txtMobileNumber: FormTextField!
    
    @IBOutlet weak var lblDateAndTimeTitle: UILabel!
    @IBOutlet weak var txtDataAndTimeFromCalendar: ThemeTextField!

    @IBOutlet weak var lblNotesTitle: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
   
    @IBOutlet weak var btnSubmit: ThemeButton!

    var BackView = UIView()
    
    var delegateBookLater : deleagateForBookTaxiLater!
    var mapView : GMSMapView?
    var pickerView = UIPickerView()
    var strModelId = String()
    var BoolCurrentLocation = Bool()
    var strCarModelURL = String()
    var strPassengerType = String()
    var strPromoCode = String()
    var convertDateToString = String()
    var boolIsSelected = Bool()
    var boolIsSelectedNotes = Bool()
    var strCarName = String()
    var strFullname = String()
    var strMobileNumber = String()
    var placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    var aryOfPaymentOptionsNames = [String]()
    var aryOfPaymentOptionsImages = [String]()
    var CardID = String()
    var paymentType = String()
    var selector = WWCalendarTimeSelector.instantiate()
    
    var strPickupLocation = String()
    var strDropoffLocation = String()
    
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    
    var validationsMobileNumber = Validation()
    var inputValidatorMobileNumber = InputValidator()
    var aryCards = [[String:AnyObject]]()
    var isAddCardSelected = Bool()
    var currentDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView() {
        
        self.addCustomNavigationBar(title: "Book Later".localized)
        
        mapView = GMSMapView()
        mapView?.delegate = self
        selector.delegate = self

       

        aryOfPaymentOptionsNames = [""]
        aryOfPaymentOptionsImages = [""]
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let tapGestureFromLocation = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureLocationEdit(_:)))
        fromLocationView.tag = 101
        fromLocationView.addGestureRecognizer(tapGestureFromLocation)
        
        let tapGestureToLocation = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureLocationEdit(_:)))
        toLocationView.tag = 102
        toLocationView.addGestureRecognizer(tapGestureToLocation)
        
        imgCareModel.sd_setImage(with: URL(string: strCarModelURL), completed: nil)
        let strCardLoca = "Car Model:".localized
        lblCareModelClass.text = "\(strCardLoca) \(strCarName)"
         
        lblUserFromAddress.applyCustomTheme(title: strPickupLocation, textColor: themeBlackColor, fontStyle: UIFont.semiBold(ofSize: 13))
        lblUserToAddress.applyCustomTheme(title: strDropoffLocation, textColor: themeBlackColor, fontStyle: UIFont.semiBold(ofSize: 13))
       
        lblFullNameTitle.applyCustomTheme(title: "Full Name".localized, textColor: themeGrayTextColor, fontStyle: UIFont.regular(ofSize: 12))
        txtFullName.text = strFullname
        
        lblMobileNumTitle.applyCustomTheme(title: "Phone Number".localized, textColor: themeGrayTextColor, fontStyle: UIFont.regular(ofSize: 12))
        txtMobileNumber.text = strMobileNumber
        checkMobileNumber()
        
        lblDateAndTimeTitle.applyCustomTheme(title: "Select Date & Time".localized, textColor: themeGrayTextColor, fontStyle: UIFont.regular(ofSize: 12))
        lblNotesTitle.applyCustomTheme(title: "Message Here (Optional)".localized, textColor: themeBlackColor, fontStyle: UIFont.regular(ofSize: 12))

        txtDescription.layer.cornerRadius = 10
        txtDescription.clipsToBounds = false
        txtDescription.layer.shadowOpacity = 0.2
        txtDescription.layer.shadowOffset = CGSize(width: 3, height: 3)
        txtDescription.contentSize = CGSize(width: txtDescription.frame.size.width * 0.6, height: txtDescription.frame.size.height * 0.7)
        txtDescription.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        txtDescription.isScrollEnabled = false

        txtFullName.placeholder = "Full Name".localized
        txtMobileNumber.placeholder = "Phone Number".localized
        txtDataAndTimeFromCalendar.placeholder = "Click calendar icon to select pickup time".localized
        //txtDescription.placeholder = "Notes (Optional)".localized
        btnSubmit.setTitle("Book Later".localized, for: .normal)
      
        strPassengerType = "myself"
        paymentType = "cash"

    }

    @objc func tapGestureLocationEdit(_ sender: UITapGestureRecognizer) {
      
        if sender.view?.tag == 101
        {
            self.openGMSLocationPicker(isCurrentLocation: true)
        }else
        {
            self.openGMSLocationPicker(isCurrentLocation: false)
        }
    }
    
    
    func openGMSLocationPicker(isCurrentLocation : Bool) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        BoolCurrentLocation = isCurrentLocation
        present(acController, animated: true, completion: nil)
    }
    
    //-------------------------------------------------------------
    // MARK: - Button Actions
    //-------------------------------------------------------------
    
//    @IBAction func btnApply(_ sender: UIButton)
//    {
//        let strPromo = txtPromoCode.text
//        //        let strFinalPromo = "\(strPromo!)/\(SingletonClass.sharedInstance.strEstimatedFare)"
//        //        self.strAppliedPromoCode = strPromo!
//
//        var dictData = [String : AnyObject]()
//        dictData["PromoCode"] = strPromo as AnyObject
//        if !(UtilityClass.isEmpty(str: strPromo))
//        {
//            webserviceForValidPromocode(dictData as AnyObject, showHUD: true) { (result, status) in
//                if status
//                {
//                    print(result)
//
//                    self.lblPromoCode.text = self.txtPromoCode.text
//
//                    self.viewProocode.isHidden = true
//
////                    let strNewAmount = result["new_estimate_fare"] as! String
////                    let text = "Estimated Fare is $\(SingletonClass.sharedInstance.strEstimatedFare)   $\(strNewAmount)"
////                    let range = (text as NSString).range(of: "$\(SingletonClass.sharedInstance.strEstimatedFare)")
////                    let attributedString1 = NSMutableAttributedString(string:text)
////                    attributedString1.addAttributes([NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue], range: range)
////                    self.lblEstimatedFare.attributedText = attributedString1
////
////                    let dict =  result["promocode"] as! NSDictionary
////
////                    self.strPromoCodeDiscountType = dict.object(forKey: "DiscountType") as! String
////                    self.strPromoCodeDiscountValue = "\((dict.object(forKey: "DiscountValue")!))"
//
//
//
//                }
//                else
//                {
//                    print(result)
//
//                    if let res = result as? String
//                    {
//                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
//                            if SelectedLanguage == "en"
//                            {
//                                UtilityClass.showAlert("Error", message: res, vc: self)
//
//                            }
//                            else if SelectedLanguage == "sw"
//                            {
//                                UtilityClass.showAlert("Error", message: res, vc: self)
//                            }
//                        }
//                    }
//                    else if let resDict = result as? NSDictionary
//                    {
//
//
//                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
//                            if SelectedLanguage == "en"
//                            {
//                                UtilityClass.showAlert("Error", message: resDict.object(forKey: "message") as! String, vc: self)
//
//                            }
//                            else if SelectedLanguage == "sw"
//                            {
//                                UtilityClass.showAlert("Error", message: resDict.object(forKey: "swahili_message") as! String, vc: self)
//                            }
//                        }
//                    }
//                    else if let resAry = result as? NSArray
//                    {
//
//                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
//                            if SelectedLanguage == "en"
//                            {
//                               UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
//
//                            }
//                            else if SelectedLanguage == "sw"
//                            {
//                                UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "swahili_message") as! String, vc: self)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    

    func openDatePicker() {
       
        selector.optionCalendarFontColorPastDates = UIColor.gray
        selector.optionButtonFontColorDone = themeYellowColor
        selector.optionSelectorPanelBackgroundColor = themeYellowColor
        selector.optionCalendarBackgroundColorTodayHighlight = themeYellowColor
        selector.optionTopPanelBackgroundColor = themeYellowColor
        selector.optionClockBackgroundColorMinuteHighlightNeedle = themeYellowColor
        selector.optionClockBackgroundColorHourHighlight = themeYellowColor
        selector.optionClockBackgroundColorAMPMHighlight = themeYellowColor
        selector.optionCalendarBackgroundColorPastDatesHighlight = themeYellowColor
        selector.optionCalendarBackgroundColorFutureDatesHighlight = themeYellowColor
        selector.optionClockBackgroundColorMinuteHighlight = themeYellowColor
        
        //        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showYear(false)
        //        selector.optionStyles.showMonth(true)
        
        selector.optionStyles.showTime(true)
        
        // 2. You can then set delegate, and any customization options
        
        selector.optionTopPanelTitle = "Please choose date"
        selector.optionIdentifier = "Time" as AnyObject
        let dateCurrent = Date()
        selector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)
        
        // 3. Then you simply present it from your view controller when necessary!
        self.present(selector, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmit(_ sender: ThemeButton) {
        
        if txtFullName.text == "" || txtMobileNumber.text == "" || /*txtPickupLocation.text == "" || txtDropOffLocation.text == "" || */ txtDataAndTimeFromCalendar.text == "" || strPassengerType == "" || paymentType == ""  {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "All fields are required...".localized) { (index, title) in
            }
        }
        else {
            webserviceOFBookLater()
        }
        
    }

    
    func checkMobileNumber() {
//        txtMobileNumber.inputType = .integer
        //        var validation = Validation()
//        validationsMobileNumber.maximumLength = 10
//        validationsMobileNumber.minimumLength = 10
//        validationsMobileNumber.characterSet = NSCharacterSet.decimalDigits
//        let inputValidator = InputValidator(validation: validationsMobileNumber)
//        txtMobileNumber.inputValidator = inputValidator
        print("txtMobileNumber : \(txtMobileNumber.text!)")
    }
        
    func getPlaceFromLatLong()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            //            self.txtCurrentLocation.text = "No current place"
//            self.txtPickupLocation.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let SelectedFromLocation = "\(place.name), \(place.formattedAddress!)"
                    self.strPickupLocation = SelectedFromLocation
//                        place.formattedAddress!
                    self.doublePickupLat = place.coordinate.latitude
                    self.doublePickupLng = place.coordinate.longitude
//                    self.txtPickupLocation.text = SelectedFromLocation
//                        place.formattedAddress?.components(separatedBy: ", ")
//                        .joined(separator: "\n")
                }
            }
        })
    }
    
    func setCardIcon(str: String) -> String {
//        visa , mastercard , amex , diners , discover , jcb , other
        var CardIcon = String()
        
        switch str {
        case "visa":
            CardIcon = "Visa"
            return CardIcon
        case "mastercard":
            CardIcon = "MasterCard"
            return CardIcon
        case "amex":
            CardIcon = "Amex"
            return CardIcon
        case "diners":
            CardIcon = "Diners Club"
            return CardIcon
        case "discover":
            CardIcon = "Discover"
            return CardIcon
        case "jcb":
            CardIcon = "JCB"
            return CardIcon
        case "iconCashBlack":
            CardIcon = "iconCashBlack"
            return CardIcon
        case "iconWalletBlack":
            CardIcon = "iconWalletBlack"
            return CardIcon
        case "iconPlusBlack":
            CardIcon = "iconPlusBlack"
            return CardIcon
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
        
    }
    
    func didHaveCards() {
        aryCards.removeAll()
        //webserviceOfCardList()
    }
    
    @objc func IQKeyboardmanagerDoneMethod() {
        
        if (isAddCardSelected) {
             self.addNewCard()
        }
        
//        txtSelectPaymentMethod.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(self.IQKeyboardmanagerDoneMethod))
    }
    
  
    func addNewCard() {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        next.delegateAddCardFromBookLater = self
        self.isAddCardSelected = false
        self.navigationController?.present(next, animated: true, completion: nil)
    }

}


extension BookLaterViewController : UITextFieldDelegate {
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDataAndTimeFromCalendar {
            self.openDatePicker()
            return false
        }
        return true
    }
}

// MARK: - Calendar Method

extension BookLaterViewController : WWCalendarTimeSelectorProtocol
{
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    {
        
        if currentDate < date {
            
            //            let calendarDate = Calendar.current
            //            let hour = calendarDate.component(.hour, from: date)
            //            let minutes = calendarDate.component(.minute, from: date)
            
            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            
            if  date > currentTimeInterval {
                
                let myDateFormatter: DateFormatter = DateFormatter()
                myDateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                
                let dateOfPostToApi: DateFormatter = DateFormatter()
                dateOfPostToApi.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                convertDateToString = dateOfPostToApi.string(from: date)
                
                let finalDate = myDateFormatter.string(from: date)
                
                // get the date string applied date format
                let mySelectedDate = String(describing: finalDate)
                
                txtDataAndTimeFromCalendar.text = mySelectedDate
            }
            else {
                
                txtDataAndTimeFromCalendar.text = ""
                
                UtilityClass.setCustomAlert(title: "Time should be", message: "Please select 30 minutes greater time from current time!") { (index, title) in
                }
            }
            
        }
        
    }
    
    func WWCalendarTimeSelectorWillDismiss(_ selector: WWCalendarTimeSelector) {
        
    }
    
    func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector) {
        
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        
        if currentDate < date {
            let currentTimeInterval = currentDate.addingTimeInterval(30 * 60)
            if  date > currentTimeInterval {
                return true
            }
            return false
        }
        return false
    }
    
}

//
//// MARK: - PickerView Methods
//
//extension BookLaterViewController : UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return aryCards.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 60
//    }
//
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let data = aryCards[row]
//
//        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
//
//        let centerOfmyView = myView.frame.size.height / 4
//
//
//        let myImageView = UIImageView(frame: CGRect(x:0, y:centerOfmyView, width:40, height:26))
//        myImageView.contentMode = .scaleAspectFit
//
//        var rowString = String()
//
//
//        switch row {
//
//        case 0:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 1:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 2:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 3:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 4:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 5:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 6:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 7:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 8:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 9:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        case 10:
//            rowString = data["CardNum2"] as! String
//            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        default:
//            rowString = "Error: too many rows"
//            myImageView.image = nil
//        }
//        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
//        //        myLabel.font = UIFont(name:some, font, size: 18)
//        myLabel.text = rowString
//
//        myView.addSubview(myLabel)
//        myView.addSubview(myImageView)
//
//        return myView
//    }
//
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        let data = aryCards[row]
//
//        //imgPaymentOption.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
//        // txtSelectPaymentMethod.text = data["CardNum2"] as? String
//
//        //        if data["CardNum"] as! String == "Add a Card" {
//        //
//        //            isAddCardSelected = true
//        ////            self.addNewCard()
//        //        }
//        //
//        let type = data["CardNum"] as! String
//
//        if type  == "wallet" {
//            paymentType = "wallet"
//        }
//        else if type == "cash" {
//            paymentType = "cash"
//        }
//        else {
//            paymentType = "pesapal"
//        }
//
//
//        //        if paymentType == "card" {
//        //
//        //            if data["Id"] as? String != "" {
//        //                CardID = data["Id"] as! String
//        //            }
//        //        }
//
//        // do something with selected row
//    }
//}

// MARK: - GMSMapView Delegate

extension BookLaterViewController : GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let SelectedLocation = "\(place.name ?? ""), \(place.formattedAddress ?? "")"

        if BoolCurrentLocation
        {
            lblUserFromAddress.text = SelectedLocation
            strPickupLocation = SelectedLocation
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            
        }
        else
        {
            lblUserToAddress.text = SelectedLocation
            strDropoffLocation = SelectedLocation
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}

// // MARK:- Delegates to handle events for the location manager.
extension BookLaterViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
//        print("Location: \(location)")
        
//        self.getPlaceFromLatLong()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

// MARK: - Webservice Methods

extension BookLaterViewController {
    
    func webserviceOfCardList()
    {
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                print(result)
                
                //                if let res = result as? [String:AnyObject] {
                //                    if let cards = res["cards"] as? [[String:AnyObject]] {
                //                        self.aryCards = cards
                //                    }
                //                }
                
                var dict = [String:AnyObject]()
                dict["CardNum"] = "cash" as AnyObject
                dict["CardNum2"] = "cash" as AnyObject
                dict["Type"] = "iconCashBlack" as AnyObject
                
                var dict2 = [String:AnyObject]()
                dict2["CardNum"] = "wallet" as AnyObject
                dict2["CardNum2"] = "wallet" as AnyObject
                dict2["Type"] = "iconWalletBlack" as AnyObject
                
                var dict3 = [String:AnyObject]()
                dict3["CardNum"] = "pesapal" as AnyObject
                dict3["CardNum2"] = "pesapal" as AnyObject
                dict3["Type"] = "icon_SelectedCard" as AnyObject
                
                self.aryCards.append(dict)
                self.aryCards.append(dict2)
                self.aryCards.append(dict3)
                //
                //                if self.aryCards.count == 2 {
                //                    var dict3 = [String:AnyObject]()
                //                    dict3["Id"] = "000" as AnyObject
                //                    dict3["CardNum"] = "Add a Card" as AnyObject
                //                    dict3["CardNum2"] = "Add a Card" as AnyObject
                //                    dict3["Type"] = "iconPlusBlack" as AnyObject
                //                    self.aryCards.append(dict3)
                //
                //                }
                //
                //                self.pickerView.selectedRow(inComponent: 0)
                let data = self.aryCards[0]
                //
                //self.imgPaymentOption.image = UIImage(named: self.setCardIcon(str: data["Type"] as! String))
                //self.txtSelectPaymentMethod.text = data["CardNum2"] as? String
                
                let type = data["CardNum"] as! String
                
                if type  == "wallet"
                {
                    self.paymentType = "wallet"
                }
                else if type == "cash"
                {
                    self.paymentType = "cash"
                }
                else
                {
                    self.paymentType = "pesapal"
                }
                //                if self.paymentType == "card" {
                //
                //                    if data["Id"] as? String != "" {
                //                        self.CardID = data["Id"] as! String
                //                    }
                //                }
                //                 self.paymentType = "cash"
                self.pickerView.reloadAllComponents()
                
                /*
                 {
                 cards =     (
                 {
                 Alias = visa;
                 CardNum = 4639251002213023;
                 CardNum2 = "xxxx xxxx xxxx 3023";
                 Id = 59;
                 Type = visa;
                 }
                 );
                 status = 1;
                 }
                 */
                
                
            }else
            {
                print(result)
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    // MARK: - Webservice For Book Later
    
    //PassengerId,ModelId,PickupLocation,DropoffLocation,PassengerType(myself,other),PassengerName,PassengerContact,PickupDateTime,FlightNumber,
    //PromoCode,Notes,PaymentType,CardId(If paymentType is card)
    
    func webserviceOFBookLater()
    {
        var dictData = [String:AnyObject]()
        
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["ModelId"] = strModelId as AnyObject
        dictData["PickupLocation"] = lblUserFromAddress.text as AnyObject
        dictData["DropoffLocation"] = lblUserFromAddress.text as AnyObject
        dictData["PassengerType"] = strPassengerType as AnyObject
        dictData["PassengerName"] = txtFullName.text as AnyObject
        dictData["PassengerContact"] = txtMobileNumber.text as AnyObject
        dictData["PickupDateTime"] = convertDateToString as AnyObject
        dictData["PromoCode"] = strPromoCode as AnyObject
        //dictData["FlightNumber"] = "" as AnyObject
        dictData["PaymentType"] = paymentType as AnyObject
        dictData["Notes"] = txtDescription.text as AnyObject

        webserviceForBookLater(dictData as AnyObject) { (result, status) in
            
            print(result)

            if (status)
            {
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your ride has been booked.".localized, completionHandler: { (index, title) in
                    self.delegateBookLater.btnRequestLater()
                    self.navigationController?.popViewController(animated: true)
                })
                
            }else {
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
        
    }
    
}
