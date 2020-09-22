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
    var d_selector = WWCalendarTimeSelector.instantiate()
    
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
        d_selector = WWCalendarTimeSelector.instantiate()
        d_selector.delegate = self

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
        acController.modalPresentationStyle = .overCurrentContext
        present(acController, animated: true, completion: nil)
    }

    func openDatePicker() {
       
        d_selector.optionCalendarFontColorPastDates = UIColor.gray
        d_selector.optionButtonFontColorDone = themeYellowColor
        d_selector.optionSelectorPanelBackgroundColor = themeYellowColor
        d_selector.optionCalendarBackgroundColorTodayHighlight = themeYellowColor
        d_selector.optionTopPanelBackgroundColor = themeYellowColor
        d_selector.optionClockBackgroundColorMinuteHighlightNeedle = themeYellowColor
        d_selector.optionClockBackgroundColorHourHighlight = themeYellowColor
        d_selector.optionClockBackgroundColorAMPMHighlight = themeYellowColor
        d_selector.optionCalendarBackgroundColorPastDatesHighlight = themeYellowColor
        d_selector.optionCalendarBackgroundColorFutureDatesHighlight = themeYellowColor
        d_selector.optionClockBackgroundColorMinuteHighlight = themeYellowColor
        
        //        selector.optionStyles.showDateMonth(true)
        d_selector.optionStyles.showYear(false)
        //        selector.optionStyles.showMonth(true)
        
        d_selector.optionStyles.showTime(true)
        
        // 2. You can then set delegate, and any customization options
        
        d_selector.optionTopPanelTitle = "Please choose date"
        d_selector.optionIdentifier = "Time" as AnyObject
        let dateCurrent = Date()
        d_selector.optionCurrentDate = dateCurrent.addingTimeInterval(30 * 60)
        d_selector.modalPresentationStyle  = .overCurrentContext
        // 3. Then you simply present it from your view controller when necessary!
        self.present(d_selector, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmit(_ sender: ThemeButton) {
        
        if txtFullName.text == "" || txtMobileNumber.text == "" || /*txtPickupLocation.text == "" || txtDropOffLocation.text == "" || */ txtDataAndTimeFromCalendar.text == "" || strPassengerType == "" || paymentType == ""
        {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "All fields are required...".localized) { (index, title) in
            }
        }
        else if txtMobileNumber.text!.count < 10 {
            UtilityClass.setCustomAlert(title: "Invalid Mobile!", message: "Enter correct mobile number") { (index, title) in
            }
        }
        else {
            webserviceOFBookLater()
        }
        
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
    
    // MARK: - Book Later
    
    func webserviceOFBookLater()
    {
        var dictData = [String:AnyObject]()
        
        dictData["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["ModelId"] = strModelId as AnyObject
        dictData["PickupLocation"] = lblUserFromAddress.text as AnyObject
        dictData["DropoffLocation"] = lblUserToAddress.text as AnyObject
        dictData["PassengerType"] = strPassengerType as AnyObject
        dictData["PassengerName"] = txtFullName.text as AnyObject
        dictData["PassengerContact"] = txtMobileNumber.text as AnyObject
        dictData["PickupDateTime"] = convertDateToString as AnyObject
        dictData["PaymentType"] = paymentType as AnyObject
        dictData["Notes"] = txtDescription.text as AnyObject
        
        if let dicDefaultPaymentType = SingletonClass.getCurrentPaymentDetails(), dicDefaultPaymentType.count > 0
        {
            dictData["PaymentType"] = "card" as AnyObject
            dictData["CardId"] = dicDefaultPaymentType.object(forKey: "Id") as AnyObject
        }else
        {
            dictData["PaymentType"] = "cash" as AnyObject
        }
        
        if strPromoCode.count > 0
        {
            dictData["PromoCode"] = strPromoCode as AnyObject
        }
        
        webserviceForBookLater(dictData as AnyObject) { (result, status) in
            
            print(result)
            
            if (status)
            {
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Your ride has been booked.".localized, completionHandler: { (index, title) in
//                    self.delegateBookLater.btnRequestLater()
//                    self.navigationController?.popViewController(animated: true)
                })
                // because a new alert / notification may arrive from sockets... 
                self.delegateBookLater.btnRequestLater()
                self.navigationController?.popViewController(animated: true)
                
            }else
            {
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
