//
//  HomeViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 26/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//import SideMenu
import SocketIO
import SDWebImage
import NVActivityIndicatorView
import M13Checkbox

protocol FavouriteLocationDelegate {
    func didEnterFavouriteDestination(Source: [String: AnyObject])
}

protocol CompleterTripInfoDelegate {
    func didRatingCompleted()
}

protocol addCardFromHomeVCDelegate {
    func didAddCardFromHomeVC()
}
protocol deleagateForBookTaxiLater
{
    func btnRequestLater()
}

class HomeViewController: BaseViewController, FavouriteLocationDelegate, NVActivityIndicatorViewable, UIGestureRecognizerDelegate, FloatRatingViewDelegate, ARCarMovementDelegate, GMSMapViewDelegate, addCardFromHomeVCDelegate, SelectCardDelegate,delegateRateGiven,deleagateForBookTaxiLater
{
    
    @IBOutlet weak var lblUserFromAddress: UILabel!
    @IBOutlet weak var lblUserToAddress: UILabel!
    @IBOutlet weak var lblCurrentLocationForDefaultView: UILabel!
    @IBOutlet weak var defaultModeView: UIView!
    @IBOutlet weak var fromLocationView: UIStackView!
    @IBOutlet weak var toLocationView: UIStackView!
    @IBOutlet weak var txtPromodeCode: UITextField!
    @IBOutlet weak var btnApplyPromoCode: UIButton!
    @IBOutlet weak var btnBookRideNow: ThemeButton!
    @IBOutlet weak var btnBookRideLater: UIButton!
    @IBOutlet weak var readyToBookRideView: UIView!
//    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverEmail: UILabel!
    @IBOutlet weak var lblDriverPhoneNumber: UILabel!
    @IBOutlet weak var imgDriverImage: UIImageView!
    @IBOutlet weak var viewDriverInformation: UIView!
    @IBOutlet weak var viewTripActions: UIView!
    @IBOutlet weak var viewDriverDetails: UIView!
    @IBOutlet weak var btnCancelBooking: UIButton!
    @IBOutlet weak var btnDriverPhoto: UIButton!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblCarDescriptions: UILabel!
    @IBOutlet weak var btnMessageDriver: UIButton!
    @IBOutlet weak var lblDistanceTitle: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!
    @IBOutlet weak var imageViewCarType: UIImageView!
    
    @IBOutlet weak var lblTimeValue: UILabel!
    @IBOutlet weak var lblTimeTitle: UILabel!
    @IBOutlet weak var btnCallDriver: UIButton!
    @IBOutlet weak var lblDriverRatings: UILabel!
    @IBOutlet weak var lblPriceValue: UILabel!
    
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var viewFromToSubmitButton: UIView!
    @IBOutlet weak var viewCarLists: UIView!
    @IBOutlet weak var viewShareRideView: UIView!
    @IBOutlet weak var imgIsShareRideON: UIImageView!
    @IBOutlet var btnRequestNow: UIButton!
    @IBOutlet var btnBookLater: ThemeButton!
    @IBOutlet var btnBookNow: ThemeButton!
    @IBOutlet var btnSubmitRating: UIButton!
    @IBOutlet var lblHowwasyourExperienceTitle: UILabel!
    @IBOutlet var lblYourRequestPendingStatusTitle: UILabel!
    
    // MARK: - Final Rating View
    
    @IBOutlet weak var MarkerCurrntLocation: UIButton!
    @IBOutlet weak var viewMainFinalRating: UIView!
    @IBOutlet weak var viewSubFinalRating: UIView!
    @IBOutlet weak var txtFeedbackFinal: UITextField!
    @IBOutlet weak var giveRating: FloatRatingView!
    @IBOutlet weak var viewBookNowLater: UIView!
    @IBOutlet weak var btnSwapAddress: UIButton!
    @IBOutlet weak var constantLeadingOfShareRideButton: NSLayoutConstraint! // 10 or -150
    @IBOutlet weak var btnShareRideToggle: UIButton!
    
    @IBOutlet var HomeViewGrandParentView: UIView!
    @IBOutlet weak var viewDestinationLocation: UIView!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var txtDestinationLocation: UITextField!
    @IBOutlet weak var txtCurrentLocation: UITextField!
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var collectionViewCars: UICollectionView!
    @IBOutlet var viewAddressandBooknowlaterBTN: UIView!
    
    @IBOutlet weak var ConstantViewCarListsHeight: NSLayoutConstraint! // 170
    @IBOutlet weak var constraintTopSpaceViewDriverInfo: NSLayoutConstraint!
    @IBOutlet weak var viewForMainFavourite: UIView!
    @IBOutlet weak var viewForFavourite: UIView!
    @IBOutlet weak var btnDoneForLocationSelected: ThemeButton!

    let CellID = "AvailablesCarsListCollectionViewCell"

    var strModelId = String()
    var strPickupLocation = String()
    var strDropoffLocation = String()
    var doublePickupLat = Double()
    var doublePickupLng = Double()
    var doubleUpdateNewLat = Double()
    var doubleUpdateNewLng = Double()
    var doubleDropOffLat = Double()
    var doubleDropOffLng = Double()
    var arrDataAfterCompletetionOfTrip = NSMutableArray()
    var selectedIndexPath: IndexPath?
    var strSpecialRequest = String()
    var strSpecialRequestFareCharge = String()
    var strPickUpLatitude = String()
    var strPickUpLongitude = String()
       
    var loadingView: NVActivityIndicatorView!
    //---------------
    var sumOfFinalDistance = Double()
    var selectedRoute: Dictionary<String, AnyObject>!
    var overviewPolyline: Dictionary<String, AnyObject>!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var dropoffLat = Double()
    var dropoffLng = Double()
    
    /// if intShareRide = 1 than ON and if intShareRide = 0 OFF
    var intShareRide:Int = 0
    var isShareRideON = Bool()
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    let baseUrlForGetAddress = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseUrlForAutocompleteAddress = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    
    let apikey = googlApiKey//googlPlacesApiKey //"AIzaSyCKEP5WGD7n5QWtCopu0QXOzM9Qec4vAfE"
    let socket = SocketIOClient(socketURL: URL(string: SocketData.kBaseURL)!, config: [.log(false), .compress])
    
    //    let socket = (UIApplication.shared.delegate as! AppDelegate).SocketManager
    var boolTimeEnd = Bool()
    var moveMent: ARCarMovement!
    var driverMarker: GMSMarker!
    var strTipAmount = String()
    var alertForTip = UIAlertController()
    var timer = Timer()
    var timerToGetDriverLocation : Timer!
    var aryCards = [[String:AnyObject]]()
    var aryCompleterTripData = [Any]()
    let completeProgress: CGFloat = 30
    var progressCompleted: CGFloat = 1
    var timerOfRequest : Timer!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView = GMSMapView()
    var placesClient = GMSPlacesClient()
    var zoomLevel: Float = 17.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var defaultLocation = CLLocation(latitude: 6.9422744, longitude: 79.9196117)
    var arrNumberOfAvailableCars = NSMutableArray()
    var arrTotalNumberOfCars = NSMutableArray()
    var arrNumberOfOnlineCars = NSMutableArray()
    //    var dictCars = NSMutableDictionary()
    var strCarModelClass = String()
    var aryRequestAcceptedData = NSArray()
    var strCarModelID = String()
    var strCarModelIDIfZero = String()
    var strNavigateCarModel = String()
    var aryEstimateFareData = NSMutableArray()
    var strSelectedCarMarkerIcon = String()
    var ratingToDriver = Float()
    var commentToDriver = String()
    var strSelectedCarTotalFare = String()
    var currentLocationMarkerText = String()
    var destinationLocationMarkerText = String()
    var aryCardsListForBookNow = [[String:AnyObject]]()
    var timesOfAccept = Int()
    var strDestinationLocationForBookLater = String()
    var dropOffLatForBookLater = Double()
    var dropOffLngForBookLater = Double()
    var cardData = [[String:AnyObject]]()

    // MARK: - Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.viewBookNowLater.isHidden = true
        self.setNavBarWithMenu(Title: "Home", IsNeedRightButton: true)
        self.setupView()
        webserviceOfCardList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setLocationFromBarAndClub(_:)), name: NotificationBookNow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setBookLaterDestinationAddress(_:)), name: NotificationBookLater, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.webserviceOfRunningTripTrack), name: NotificationTrackRunningTrip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.newBooking(_:)), name: NotificationForBookingNewTrip, object: nil)
        
        //Menu Navigation Observer
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoProfilePage), name: OpenEditProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoMyBookingPage), name: OpenMyBooking, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoPaymentPage), name: OpenPaymentOption, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoWalletPage), name: OpenWallet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoMyReceiptPage), name: OpenMyReceipt, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoFavouritePage), name: OpenFavourite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoInviteFriendPage), name: OpenInviteFriend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoSettingPage), name: OpenSetting, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoSupportPage), name: OpenSupport, object: nil)
                
        
        self.stackViewNumberOfPassenger.isHidden = true
        self.btnDoneForLocationSelected.isHidden = true
        
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
        
        currentLocationMarkerText = "Current Location"
        destinationLocationMarkerText = "Destination Location"
        
        imgIsShareRideON.image = UIImage(named: "iconRed")
        currentLocationMarker.isDraggable = true
        destinationLocationMarker.isDraggable = true
        moveMent = ARCarMovement()
        moveMent.delegate = self
        mapView.delegate = self
        
        mapView.isHidden = true
        self.perform(#selector(btnCurrentLocation(_:)), with: nil, afterDelay: 2.0)
        self.setupGoogleMap()
        sortCarListFirstTime()
        webserviceOfCurrentBooking()
        setPaymentType()
        
        viewMainFinalRating.isHidden = true
        btnCurrentLocation.layer.cornerRadius = 5
        btnCurrentLocation.layer.masksToBounds = true
        giveRating.delegate = self
        ratingToDriver = 0.0
        //        paymentType = "cash"
        self.viewBookNow.isHidden = true
        stackViewOfPromocode.isHidden = true
        viewMainActivityIndicator.isHidden = true
        viewActivity.type = .ballPulse
        viewActivity.color = themeYellowColor
        viewHavePromocode.tintColor = themeYellowColor
        viewHavePromocode.stateChangeAnimation = .fill
        viewHavePromocode.boxType = .square
        viewTripActions.isHidden = true
        viewForMainFavourite.isHidden = true
        viewForFavourite.layer.cornerRadius = 5
        viewForFavourite.layer.masksToBounds = true
        SingletonClass.sharedInstance.isFirstTimeDidupdateLocation = true;
        //        self.view.bringSubview(toFront: btnFavourite)
        
        callToWebserviceOfCardListViewDidLoad()
        
        //
        //        // Do any additional setup after loading the view.
        //
        //
        //        viewCurrentLocation.layer.shadowOpacity = 0.3
        //        viewCurrentLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //
        //        viewDestinationLocation.layer.shadowOpacity = 0.3
        //        viewDestinationLocation.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        //
        //        self.setupSideMenu()
        ////        webserviceCallForGettingCarLists()
        //
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setLocalization()
        self.btnDoneForLocationSelected.isHidden = true
        
        self.setNavBarWithMenu(Title: "Home".localized, IsNeedRightButton: true)
        //        setupGoogleMap()
        
        //        viewTripActions.isHidden = true
        
        // This is For Book Later Address
        if (SingletonClass.sharedInstance.isFromNotificationBookLater) {
            
            if strCarModelID == ""
            {
                UtilityClass.setCustomAlert(title: "Missing", message: "No Driver Available Right Now.".localized) { (index, title) in
                }
            }
            else if strDestinationLocationForBookLater != ""
            {
                let profileData = SingletonClass.sharedInstance.dictProfile
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterViewController
                
                SingletonClass.sharedInstance.isFromNotificationBookLater = false
                
                next.delegateBookLater = self
                next.strModelId = strCarModelID
                next.strCarModelURL = strNavigateCarModel
                next.strCarName = strCarModelClass
                next.strFullname = profileData.object(forKey: "Fullname") as! String
                next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                next.strDropoffLocation = strDestinationLocationForBookLater
                next.doubleDropOffLat = dropOffLatForBookLater
                next.doubleDropOffLng = dropOffLngForBookLater
                
                self.navigationController?.pushViewController(next, animated: true)
            }
            else
            {
                UtilityClass.setCustomAlert(title: "Missing", message: "We did not get proper address") { (index, title) in
                }
            }
        }
        
        viewSubFinalRating.layer.cornerRadius = 5
        viewSubFinalRating.layer.masksToBounds = true
        
        //        viewSelectPaymentOption.layer.borderWidth = 1.0
        //        viewSelectPaymentOption.layer.borderColor = UIColor.gray.cgColor
        //        viewSelectPaymentOption.layer.cornerRadius = 5
        //        viewSelectPaymentOption.layer.masksToBounds = true
        
        viewSelectPaymentOptionParent.layer.cornerRadius = 5
        viewSelectPaymentOptionParent.layer.masksToBounds = true
        
        if(locationManager != nil)
        {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupView()
    {
        collectionViewCars.register(UINib(nibName: "AvailablesCarsListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CellID)
       
        let tapGestureFromLocation = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureLocationEdit(_:)))
        fromLocationView.tag = 101
        fromLocationView.addGestureRecognizer(tapGestureFromLocation)
        
        let tapGestureToLocation = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureLocationEdit(_:)))
        toLocationView.tag = 102
        toLocationView.addGestureRecognizer(tapGestureToLocation)
        
        self.viewTripActions.dropShadow()
        self.lblUserToAddress.text = ""
        self.lblUserFromAddress.text = ""
        self.lblCurrentLocationForDefaultView.text = ""
        self.defaultModeView.isHidden = true
        self.readyToBookRideView.isHidden = true
        btnApplyPromoCode.setTitle("Apply", for: .normal)
        txtPromodeCode.placeholder = "Enter your promotion code"
        btnBookRideNow.setTitle("Book Now".localized, for: .normal)
        btnBookRideLater.setImage(UIImage.init(named: "material-date-range"), for: .normal)
      
        btnDriverPhoto.imageView?.contentMode = .scaleToFill
        self.lblDriverName.text = ""
        self.lblDriverName.font = UIFont.regular(ofSize: 14)
        self.lblDriverRatings.text = ""
        self.lblDriverRatings.font = UIFont.regular(ofSize: 12)
        self.lblCarDescriptions.text = ""
        self.lblCarDescriptions.font = UIFont.regular(ofSize: 12)
        self.lblDistanceTitle.text = "DISTANCE"
        self.lblDistanceTitle.font = UIFont.regular(ofSize: 12)
        self.lblTimeTitle.text = "TIME"
        self.lblTimeTitle.font = UIFont.regular(ofSize: 12)
        self.lblPriceTitle.text = "PRICE"
        self.lblPriceTitle.font = UIFont.regular(ofSize: 12)
      
        self.viewDriverDetails.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
        self.viewTripActions.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
        self.viewDriverDetails.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func setLocalization()
    {
        btnDoneForLocationSelected.setTitle("Done".localized, for: .normal)
        btnBookNow.setTitle("Book Now".localized, for: .normal)
        btnBookLater.setTitle("Book Later".localized, for: .normal)
        btnRequestNow.setTitle("REQUEST NOW".localized, for: .normal)
        lblPromocode.text = "Have a promocode?".localized
        txtNote.placeholder = "Notes".localized
        lblYourRequestPendingStatusTitle.text = "Your request status pending...".localized
        btnCancelBooking.setTitle("Cancel Booking".localized, for: .normal)
//        btnDriverInfo.setTitle("Driver Info".localized, for: .normal)
        txtHavePromocode.placeholder = "Enter Promocode".localized
        btnPesaPal.setTitle("pesapal".localized, for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.arrTotalNumberOfCars = NSMutableArray(array: SingletonClass.sharedInstance.arrCarLists)
        //        self.setupGoogleMap()
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        giveRating.rating = rating
        ratingToDriver = giveRating.rating
    }
    
    @IBAction func btnSubmitFinalRating(_ sender: UIButton) {
        
        var param = [String:AnyObject]()
        param["BookingId"] = SingletonClass.sharedInstance.bookingId as AnyObject
        param["Rating"] = ratingToDriver as AnyObject
        param["Comment"] = txtFeedbackFinal.text as AnyObject
        param["BookingType"] = strBookingType as AnyObject
        
        webserviceForRatingAndComment(param as AnyObject) { (result, status) in
            
            print(result)
            if (status)
            {
                self.txtFeedbackFinal.text = ""
                self.ratingToDriver = 0
                self.completeTripInfo()
            }
            else
            {
                if let res = result as? String
                {
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String
                    {
                        if SelectedLanguage == "en"
                        {
                            UtilityClass.showAlert("Error", message: res, vc: self)
                            
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.showAlert("Error", message: res, vc: self)
                        }
                    }
                }
                else if let resDict = result as? NSDictionary
                {
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                       
                        if SelectedLanguage == "en"
                        {
                            UtilityClass.showAlert("Error", message: resDict.object(forKey: "message") as! String, vc: self)
                            
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.showAlert("Error", message: resDict.object(forKey: "swahili_message") as! String, vc: self)
                        }
                    }
                }
                else if let resAry = result as? NSArray
                {
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String
                    {
                        if SelectedLanguage == "en"
                        {
                            UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                            
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.showAlert("Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "swahili_message") as! String, vc: self)
                        }
                    }
                }
            }
        }
    }
    
    func btnRequestLater()
    {
        //        self.clearDataAfteCompleteTrip()
        clearMap()
        self.MarkerCurrntLocation.isHidden = false
        self.lblUserToAddress.text = ""
        self.lblUserFromAddress.text = ""
        
        self.viewCarLists.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        
        self.btnDoneForLocationSelected.isHidden = true
        self.viewBookNowLater.isHidden = true
        
//        self.btnclo.isHidden = true
//        self.btnCloseDropoffAddress.isHidden = true
        //        self.dropoffLat = 0
        //        self.doublePickupLng = 0
        self.btnCurrentLocation(self.btnCurrentLocation)
        //        SingletonClass.sharedInstance.strPassengerID = ""
        
    }

    @IBAction func btnShareRide(_ sender: UIButton) {
        isShareRideON = !isShareRideON
        
        if (isShareRideON) {
            imgIsShareRideON.image = UIImage(named: "iconGreen")
            intShareRide = 1
            SingletonClass.sharedInstance.isShareRide = 1
        }
        else {
            imgIsShareRideON.image = UIImage(named: "iconRed")
            intShareRide = 0
            SingletonClass.sharedInstance.isShareRide = 0
        }
        
        postPickupAndDropLocationForEstimateFare()
        
    }
    
    @IBAction func btnShareRideToggle(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "iconRightArraw") {
            
            sender.setImage(UIImage(named: "iconArrowSmall"), for: .normal)
            constantLeadingOfShareRideButton.constant = 10
            
            UIView.animate(withDuration: 0.5) {
                self.viewShareRideView.layoutIfNeeded()
            }
        }
        else {
            
            sender.setImage(UIImage(named: "iconRightArraw"), for: .normal)
            constantLeadingOfShareRideButton.constant = -150
            
            UIView.animate(withDuration: 0.5) {
                self.viewShareRideView.layoutIfNeeded()
            }
        }
        
    }

    func setNotificationcenter()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setLocationFromBarAndClub(_:)), name: NotificationBookNow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.setBookLaterDestinationAddress(_:)), name: NotificationBookLater, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.webserviceOfRunningTripTrack), name: NotificationTrackRunningTrip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.newBooking(_:)), name: NotificationForBookingNewTrip, object: nil)
        
        
        //Menu Navigation Observer
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoProfilePage), name: OpenEditProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoMyBookingPage), name: OpenMyBooking, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoPaymentPage), name: OpenPaymentOption, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoWalletPage), name: OpenWallet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoMyReceiptPage), name: OpenMyReceipt, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoFavouritePage), name: OpenFavourite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoInviteFriendPage), name: OpenInviteFriend, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoSettingPage), name: OpenSetting, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoSupportPage), name: OpenSupport, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.GotoHomePage), name: OpenHome, object: nil)
    }
    
    
    // MARK: - Button Actions
    @IBAction func btnApplyPromocodeClickAction(_ sender: Any) {
        
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

    //-------------------------------------------------------------
    // MARK: - Notification Center Methods
    //-------------------------------------------------------------
    
    @objc func setLocationFromBarAndClub(_ notification: NSNotification) {
        
        print("Notification Data : \(notification)")
        
        if let Address = notification.userInfo?["Address"] as? String {
            // do something with your image
            self.lblUserToAddress.text = Address
            strDropoffLocation = Address
            
            if let lat = notification.userInfo?["lat"] as? Double {
                
                if lat != 0 {
                    doubleDropOffLat = Double(lat)
                }
            }
            
            if let lng = notification.userInfo?["lng"] as? Double {
                
                if lng != 0 {
                    doubleDropOffLng = Double(lng)
                }
            }
        }
        
    }
    
    @objc func setBookLaterDestinationAddress(_ notification: NSNotification) {
        
        print("Notification Data : \(notification)")
        
        if let Address = notification.userInfo?["Address"] as? String {
            // do something with your image
            strDestinationLocationForBookLater = Address
            
            if let lat = notification.userInfo?["lat"] as? Double {
                
                if lat != 0 {
                    dropOffLatForBookLater = Double(lat)
                }
            }
            
            if let lng = notification.userInfo?["lng"] as? Double {
                
                if lng != 0 {
                    dropOffLngForBookLater = Double(lng)
                }
            }
            
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - setMap and Location Methods
    //-------------------------------------------------------------
        @IBAction func btnDoneForLocationSelected(_ sender: ThemeButton) {
        
        clearMap()
        self.routePolyline.map = nil
        self.updateCounting()
        
//            if strLocationType == currentLocationMarkerText {
//
//                btnDoneForLocationSelected.isHidden = true
//                self.viewBookNowLater.isHidden = false
//                if txtDestinationLocation.text?.count != 0 {
//                    txtDestinationLocation.becomeFirstResponder()
//                }
//            }
//            else if strLocationType == destinationLocationMarkerText {
//
//                btnDoneForLocationSelected.isHidden = true
//                self.viewBookNowLater.isHidden = false
//            }

        if (self.lblUserFromAddress.text != "" && self.lblUserToAddress.text != ""){
            
            setupBothCurrentAndDestinationMarkerAndPolylineOnMap()
            
            self.collectionViewCars.reloadData()
            btnDoneForLocationSelected.isHidden = true
            self.viewBookNowLater.isHidden = false
            self.viewCarLists.isHidden = false
            
            self.viewCarLists.backgroundColor = UIColor.white
            self.viewCarLists.layer.shadowColor = UIColor.darkGray.cgColor
            self.viewCarLists.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            self.viewCarLists.layer.shadowOpacity = 0.4
            self.viewCarLists.layer.shadowRadius = 1
            
            self.viewCarLists.layer.cornerRadius = 10
//            self.viewShareRideView.isHidden = false
            self.ConstantViewCarListsHeight.constant = 150
        }
        else
        {
            
            if UtilityClass.isEmpty(str: lblUserFromAddress.text!)
            {
                UtilityClass.showAlert("", message: "Please enter pick up location".localized, vc: self)
                
            }
            else if UtilityClass.isEmpty(str: lblUserToAddress.text!)
            {
                UtilityClass.showAlert("", message: "Please enter drop off location".localized, vc: self)
            }
            else
            {
                self.ConstantViewCarListsHeight.constant = 0
                self.viewCarLists.isHidden = true
            }
        }
        
    }
    
    
    @IBOutlet weak var btnCurrentLocation: UIButton!
    var currentLocationMarker = GMSMarker()
    var destinationLocationMarker = GMSMarker()
    
    var routePolyline = GMSPolyline()
    var demoPolylineOLD = GMSPolyline()
    
    var setDummyLineIndex = 0
    var dummyTimer = Timer()
    
    
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
//        self.getDummyDataLinedata()
//        dummyTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(dummyCarMovement), userInfo: nil, repeats: true)
        
        currentLocationAction()
    }
    
    @objc func dummyCarMovement() {
        
        self.setDummyLine(index: setDummyLineIndex)
        setDummyLineIndex += 1
        
        if setDummyLineIndex == aryDummyLineData.count {
            setDummyLineIndex = 0
            self.setDummyLine(index: setDummyLineIndex)
        }
       
    }
    
    func currentLocationAction()
    {
        clearMap()
        self.lblUserFromAddress.text = ""
        self.lblUserToAddress.text = ""

        strDropoffLocation = ""
        doubleDropOffLat = 0
        doubleDropOffLng = 0
        self.destinationLocationMarker.map = nil
        self.currentLocationMarker.map = nil
        self.strLocationType = self.currentLocationMarkerText
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
//        self.viewShareRideView.isHidden = true
        
        mapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17)
        
        mapView.camera = camera
        
        self.MarkerCurrntLocation.isHidden = false
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.doublePickupLat = (defaultLocation.coordinate.latitude)
        self.doublePickupLng = (defaultLocation.coordinate.longitude)
        
                let strLati: String = "\(self.doublePickupLat)"
                let strlongi: String = "\(self.doublePickupLng)"
        //
                getAddressForLatLng(latitude: strLati, longitude: strlongi, markerType: currentLocationMarkerText)
        
        //        let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        //        currentLocationMarker = GMSMarker(position: position)
        //        currentLocationMarker.map = self.mapView
        //        currentLocationMarker.snippet = currentLocationMarkerText // "Current Location"
        //        currentLocationMarker.icon = UIImage(named: "iconCurrentLocation")
        //        currentLocationMarker.isDraggable = true
    }
    
    let geocoder = GMSGeocoder()
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        self.btnDoneForLocationSelected.isHidden = true
    }
    
    var strLocationType = String()
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        print("idleAt cameraPosition : \(cameraPosition)")
        
        if Connectivity.isConnectedToInternet() {
            
            if MarkerCurrntLocation.isHidden == false {
                
                //                geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
                //                    guard error == nil else {
                //                        return
                //                    }
                //                }
                
                if self.strLocationType != "" {
                    
                    //                     UtilityClass.showACProgressHUD()
                    
                    
                    self.btnDoneForLocationSelected.isHidden = false
                    self.viewBookNowLater.isHidden = true
                    
                    if self.strLocationType == self.currentLocationMarkerText {
                        
                        self.doublePickupLat = cameraPosition.target.latitude
                        self.doublePickupLng = cameraPosition.target.longitude
                        
                        getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: strLocationType)
                        
                        
                    }
                    else if self.strLocationType == self.destinationLocationMarkerText {
                        
                        self.doubleDropOffLat = cameraPosition.target.latitude
                        self.doubleDropOffLng = cameraPosition.target.longitude
                        
                        getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: strLocationType)
                    }
                    
                    if self.lblUserFromAddress.text?.count != 0 && self.lblUserToAddress.text?.count != 0 && self.btnDoneForLocationSelected.isHidden != false
                    {
                        self.strLocationType = ""
                    }
                }
                
                //                getAddressForLatLng(latitude: "\(cameraPosition.target.latitude)", longitude: "\(cameraPosition.target.longitude)", markerType: strLocationType) // currentLocationMarkerText
            }
        }
        else {
            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
        print("didBeginDragging")
        
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
        
        //        currentLocationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude))
        //        currentLocationMarker.map = self.mapView
        //        currentLocationMarker.snippet = currentLocationMarkerText // "Current Location"
        //        currentLocationMarker.icon = UIImage(named: "iconCurrentLocation")
        
    }
    
    func mapView(_ mapView: GMSMapView, did position: GMSCameraPosition) {
        
        print("did position: \(position)")
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        //        print("didChange position: \(position)")
        
        
        //        print("\(position.target.latitude) \(position.target.longitude)")
        
        //        currentLocationMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude))
        //        currentLocationMarker.map = self.mapView
        //        currentLocationMarker.snippet = currentLocationMarkerText // "Current Location"
        //        currentLocationMarker.icon = UIImage(named: "iconCurrentLocation")
        //
        //        let latitude = mapView.camera.target.latitude
        //        let longitude = mapView.camera.target.longitude
        
        //        let locat = CLLocation(latitude: latitude, longitude: longitude)
        /*
         if self.strLocationType != "" {
         
         if self.strLocationType == self.currentLocationMarkerText {
         
         self.doublePickupLat = position.target.latitude
         self.doublePickupLng = position.target.longitude
         
         getAddressForLatLng(latitude: "\(position.target.latitude)", longitude: "\(position.target.longitude)", markerType: strLocationType)
         }
         else if self.strLocationType == self.destinationLocationMarkerText {
         
         self.doubleDropOffLat = position.target.latitude
         self.doubleDropOffLng = position.target.longitude
         
         getAddressForLatLng(latitude: "\(position.target.latitude)", longitude: "\(position.target.longitude)", markerType: strLocationType)
         }
         
         if txtCurrentLocation.text?.count != 0 && txtDestinationLocation.text?.count != 0 && btnDoneForLocationSelected.isHidden != false {
         self.strLocationType = ""
         }
         }
         */
        
        /*
         
         let ceo = CLGeocoder()
         let loc = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
         print("Locations : \(loc)")
         //----------------------------------------------------------------------
         
         // ----------------------------------------------------------------------
         ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
         
         if placemarks != nil {
         let placemark = placemarks![0] as? CLPlacemark
         
         let address = (placemark?.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: ", ")
         
         if self.strLocationType == self.currentLocationMarkerText {
         
         print("Address: \(address)")
         self.txtCurrentLocation.text = address
         self.strPickupLocation = address
         self.doublePickupLat = (placemark?.location?.coordinate.latitude)!
         self.doublePickupLng = (placemark?.location?.coordinate.longitude)!
         }
         else if self.strLocationType == self.destinationLocationMarkerText {
         
         print("Address: \(address)")
         self.txtDestinationLocation.text = address
         self.strDropoffLocation = address
         self.doubleDropOffLat = (placemark?.location?.coordinate.latitude)!
         self.doubleDropOffLng = (placemark?.location?.coordinate.longitude)!
         }
         
         print("didEndDragging")
         }
         }
         */
    }
    
    func getAddressForLatLng(latitude: String, longitude: String, markerType: String)
    {
        if markerType == currentLocationMarkerText
        {
            guard let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(apikey)") else {return}
            
            guard let autoCompleteHTTPs = NSURL(string: "\(baseUrlForAutocompleteAddress)input=35&location=\(latitude),\(longitude)&radius=1000&sensor=true&key=\(apikey)&components=&language=en") else {return}

            print("autoCompleteHTTPs Link is : \(autoCompleteHTTPs)")
            print("Link is : \(url)")
            
//            do {
//                let data = NSData(contentsOf: autoCompleteHTTPs as! URL)
//                if data != nil {
//                    if let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
//                        if let result = json["predictions"] as? [[String:AnyObject]] {
//                            if result != nil {
//                                if result.count > 0 {
//                                    if result.first != nil && result.first?.count != 0 {
//                                        self.txtCurrentLocation.text = result.first?["description"] as? String
//                                        self.strPickupLocation = result.first!["descriptton"] as! String
//                                        self.btnDoneForLocationSelected.isHidden = false
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
            
            guard let data = NSData(contentsOf: url as URL) else {
                return
            }
            
            do {
                
                let json = try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let result = json["results"] as? [[String:AnyObject]] {
                    if result.count > 0 {
                        if let address = result[0]["address_components"] as? [[String:AnyObject]] {
                            
                            if address.count > 1 {
                                
                                var streetNumber = String()
                                var streetStreet = String()
                                var streetCity = String()
                                var streetState = String()
                                
                                for i in 0..<address.count {
                                    
                                    if i == 0 {
                                        if let number = address[i]["long_name"] as? String {
                                            streetNumber = number
                                        }
                                    }
                                    else if i == 1 {
                                        if let street = address[i]["long_name"] as? String {
                                            streetStreet = street
                                        }
                                    }
                                    else if i == 2 {
                                        if let city = address[i]["long_name"] as? String {
                                            streetCity = city
                                        }
                                    }
                                    else if i == 3 {
                                        if let state = address[i]["long_name"] as? String {
                                            streetState = state
                                        }
                                    }
                                    else if i == 4 {
                                        if let city = address[i]["long_name"] as? String {
                                            streetCity = city
                                        }
                                    }
                                }
                                
                                //                    let zip = address[6]["short_name"] as? String
                                print("\n\(streetNumber) \(streetStreet), \(streetCity), \(streetState)")
                                
                                let fullAddress = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
                                
                                //self.txtCurrentLocation.text = fullAddress
                                self.lblCurrentLocationForDefaultView.text = fullAddress
                                self.strPickupLocation = fullAddress
                                btnDoneForLocationSelected.isHidden = false
                                self.viewBookNowLater.isHidden = true
                                //                                UtilityClass.hideHUD()
                            }
                        }
                    }
                }
            }
            catch
            {
                print("Not Geting Address")
            }
        }else if markerType == destinationLocationMarkerText
        {
            
           guard let url = NSURL(string: "\(baseUrlForGetAddress)latlng=\(latitude),\(longitude)&key=\(apikey)") else {return}
            
            print("Link is : \(url)")
      
                let data = NSData(contentsOf: url as URL)
                let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let result = json["results"] as? [[String:AnyObject]] {
                    if result.count > 0 {
                        if let address = result[0]["address_components"] as? [[String:AnyObject]] {
                            
                            if address.count > 1 {
                                
                                var streetNumber = String()
                                var streetStreet = String()
                                var streetCity = String()
                                var streetState = String()
                                
                                
                                for i in 0..<address.count {
                                    
                                    if i == 0 {
                                        if let number = address[i]["long_name"] as? String {
                                            streetNumber = number
                                        }
                                    }
                                    else if i == 1 {
                                        if let street = address[i]["long_name"] as? String {
                                            streetStreet = street
                                        }
                                    }
                                    else if i == 2 {
                                        if let city = address[i]["long_name"] as? String {
                                            streetCity = city
                                        }
                                    }
                                    else if i == 3 {
                                        if let state = address[i]["long_name"] as? String {
                                            streetState = state
                                        }
                                    }
                                    else if i == 4 {
                                        if let city = address[i]["long_name"] as? String {
                                            streetCity = city
                                        }
                                    }
                                }
                                /*
                                 if address.count == 4 {
                                 if let number = address[0]["short_name"] as? String {
                                 streetNumber = number
                                 }
                                 if let street = address[1]["short_name"] as? String {
                                 streetStreet = street
                                 }
                                 if let city = address[2]["short_name"] as? String {
                                 streetCity = city
                                 }
                                 if let state = address[3]["short_name"] as? String {
                                 streetState = state
                                 }
                                 }
                                 else {
                                 
                                 if let number = address[0]["short_name"] as? String {
                                 streetNumber = number
                                 }
                                 if let street = address[1]["short_name"] as? String {
                                 streetStreet = street
                                 }
                                 if let city = address[2]["short_name"] as? String {
                                 streetCity = city
                                 }
                                 if let state = address[4]["short_name"] as? String {
                                 streetState = state
                                 }
                                 }
                                 */
                                //                    let zip = address[6]["short_name"] as? String
                                print("\n\(streetNumber) \(streetStreet), \(streetCity), \(streetState)")
                                
                                self.lblUserToAddress.text = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
                                self.strDropoffLocation = "\(streetNumber) \(streetStreet), \(streetCity), \(streetState)"
                              
                                btnDoneForLocationSelected.isHidden = false
                                self.viewBookNowLater.isHidden = true
                                //                                UtilityClass.hideHUD()
                            }
                        }
                    }
                }
            }
            
     //   btnDoneForLocationSelected.isHidden = false
    }
    
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
        /*
         if (marker.snippet == currentLocationMarkerText) {
         let ceo = CLGeocoder()
         var loc = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
         ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
         
         if placemarks != nil {
         
         let placemark = placemarks![0] as? CLPlacemark
         
         //            print(placemark?.addressDictionary ?? "")
         
         //            print("placemark \(String(describing: placemark))")
         //            //String to hold address
         //            var locatedAt: String? = (placemark?.addressDictionary?["FormattedAddressLines"] as AnyObject).joined(separator: ", ")
         //            print("addressDictionary \(String(describing: placemark?.addressDictionary) ?? "")")
         
         let address = (placemark?.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: ", ")
         
         self.strPickupLocation = address
         self.doublePickupLat = (placemark?.location?.coordinate.latitude)!
         self.doublePickupLng = (placemark?.location?.coordinate.longitude)!
         
         let strLati: String = "\(self.doublePickupLat)"
         let strlongi: String = "\(self.doublePickupLng)"
         
         if (marker.snippet != nil) {
         self.getAddressForLatLng(latitude: strLati, longitude: strlongi, markerType: marker.snippet!)
         }
         
         }
         
         print("didEndDragging")
         }
         }
         else if (marker.snippet == destinationLocationMarkerText) {
         let ceo = CLGeocoder()
         var loc = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
         ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
         
         if placemarks != nil {
         
         let placemark = placemarks![0] as? CLPlacemark
         
         //            print(placemark?.addressDictionary ?? "")
         
         //            print("placemark \(String(describing: placemark))")
         //            //String to hold address
         //            var locatedAt: String? = (placemark?.addressDictionary?["FormattedAddressLines"] as AnyObject).joined(separator: ", ")
         //            print("addressDictionary \(String(describing: placemark?.addressDictionary) ?? "")")
         
         let address = (placemark?.addressDictionary?["FormattedAddressLines"] as! [String]).joined(separator: ", ")
         
         self.strDropoffLocation = address
         self.doubleDropOffLat = (placemark?.location?.coordinate.latitude)!
         self.doubleDropOffLng = (placemark?.location?.coordinate.longitude)!
         
         let strLati: String = "\(self.doubleDropOffLat)"
         let strlongi: String = "\(self.doubleDropOffLng)"
         
         if marker.snippet != nil {
         self.getAddressForLatLng(latitude: strLati, longitude: strlongi, markerType: marker.snippet!)
         }
         
         }
         
         print("didEndDragging")
         }
         }
         
         */
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        //        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    
    @IBOutlet weak var btnFavourite: UIButton!
    @IBAction func btnFavourite(_ sender: UIButton) {
        
        if self.lblUserToAddress.text?.count == 0 {
            
            UtilityClass.setCustomAlert(title: "Missing", message: "Enter Destination Address") { (index, title) in
            }
        }
        else {
            UIView.transition(with: viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.viewForMainFavourite.isHidden = false
            }) { _ in }
            
        }
        
    }
    
//
//    @IBOutlet weak var btnCall: UIButton!
//    @IBAction func btCallClicked(_ sender: UIButton)
//    {
//
//        let contactNumber = helpLineNumber
//
//        if contactNumber == "" {
//
//            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
//            }
//        }
//        else
//        {
//            callNumber(phoneNumber: contactNumber)
//        }
//    }
    
//    private func callNumber(phoneNumber:String) {
//
//        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
//
//            let application:UIApplication = UIApplication.shared
//            if (application.canOpenURL(phoneCallURL)) {
//                application.open(phoneCallURL, options: [:], completionHandler: nil)
//            }
//        }
//    }
    
    
    func setPaymentType() {
        
//        pickerView.selectRow(0, inComponent: 0, animated: true)
//
//        imgPaymentType.image = UIImage(named: "iconCashBlack")
//        txtSelectPaymentOption.text = "cash"
//        self.SetPaymentOption(SelectionIndex: 0)
        paymentType = "cash"
    }
    
    func setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: Bool)
    {
        viewCurrentLocation.isHidden = status
        viewDestinationLocation.isHidden = status
        viewAddressandBooknowlaterBTN.isHidden = status
        btnCurrentLocation.isHidden = status
        defaultModeView.isHidden = status
    }
    
    //Mark - Webservice Call For Miss Booking Request
    func webserviceCallForMissBookingRequest()
    {
        var dictParam = [String:AnyObject]()
        dictParam["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictParam["ModelId"] = strCarModelIDIfZero as AnyObject
        dictParam["PickupLocation"] = self.strPickupLocation as AnyObject
        dictParam["DropoffLocation"] = self.strDropoffLocation as AnyObject
        dictParam["PickupLat"] = doublePickupLat as AnyObject
        dictParam["PickupLng"] = doublePickupLng as AnyObject
        dictParam["DropOffLat"] = doubleDropOffLat as AnyObject
        dictParam["DropOffLon"] = doubleDropOffLng as AnyObject
        dictParam["Notes"] = "" as AnyObject
        
        webserviceForMissBookingRequest(dictParam as AnyObject) { (result, status) in
            
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - View Book Now
    //-------------------------------------------------------------
    
    @IBAction func tapToDismissActivityIndicator(_ sender: UITapGestureRecognizer) {
        viewMainActivityIndicator.isHidden = true
        
        //        socketMethodForCancelRequestTrip()
        
    }
    @IBOutlet weak var viewMainActivityIndicator: UIView!
    @IBOutlet weak var viewActivity: NVActivityIndicatorView!
    @IBOutlet weak var viewBookNow: UIView!
    @IBOutlet weak var viewSelectPaymentOptionParent: UIView!
    @IBOutlet weak var viewSelectPaymentOption: UIView!
    @IBOutlet weak var txtSelectPaymentOption: UITextField!
    @IBOutlet weak var viewHavePromocode: M13Checkbox!
    @IBOutlet weak var stackViewOfPromocode: UIStackView!
    @IBOutlet weak var stackViewNumberOfPassenger: UIStackView!
    @IBOutlet weak var txtNumberOfPassengers: UITextField!
    @IBOutlet weak var imgPaymentType: UIImageView!
    @IBOutlet weak var txtHavePromocode: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    var boolIsSelected = Bool()
    var pickerView = UIPickerView()
    var pickerViewForNoOfPassenger = UIPickerView()
    var CardID = String()
    var paymentType = String()
    var intNumberOfPassengerOnShareRiding = Int()
    
    @IBAction func btnPromocode(_ sender: UIButton) {
        
        boolIsSelected = !boolIsSelected
        
        if (boolIsSelected) {
            stackViewOfPromocode.isHidden = false
            viewHavePromocode.checkState = .checked
            viewHavePromocode.stateChangeAnimation = .fill
        }
        else {
            stackViewOfPromocode.isHidden = true
            viewHavePromocode.checkState = .unchecked
            viewHavePromocode.stateChangeAnimation = .fill
        }
        
    }
    
    @IBAction func viewHavePromocode(_ sender: M13Checkbox) {
        
        //        boolIsSelected = !boolIsSelected
        //
        //        if (boolIsSelected) {
        //            stackViewOfPromocode.isHidden = false
        //        }
        //        else {
        //            stackViewOfPromocode.isHidden = true
        //
        //        }
    }
    @IBAction func tapToDismissBookNowView(_ sender: UITapGestureRecognizer) {
        viewBookNow.isHidden = true
    }
    
    @IBAction func txtPaymentOption(_ sender: UITextField) {
        pickerView.delegate = self
        pickerView.dataSource = self
        txtSelectPaymentOption.inputView = pickerView
    }
    
    @IBAction func txtNumberOfPassenger(_ sender: UITextField) {
        pickerViewForNoOfPassenger.delegate = self
        pickerViewForNoOfPassenger.dataSource = self
//        pickerViewForNoOfPassenger.sc
        txtNumberOfPassengers.inputView = pickerViewForNoOfPassenger
    }
    
    @IBAction func btnRequestNow(_ sender: UIButton) {
        self.webserviceCallForBookingCar()
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
        case "other":
            CardIcon = "iconDummyCard"
            return CardIcon
        default:
            return ""
        }
        
    }
    
    func callToWebserviceOfCardListViewDidLoad() {
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reloadWebserviceOfCardList), name: NSNotification.Name(rawValue: "CardListReload"), object: nil)
    }
    
    var isReloadWebserviceOfCardList = Bool()
    
    @objc func reloadWebserviceOfCardList() {
        self.webserviceOfCardList()
        isReloadWebserviceOfCardList = true
        //        self.paymentOptions()
    }
    
//    //MARK:- SideMenu Methods
//
//    @IBOutlet weak var openSideMenu: UIButton!
//    @IBAction func openSideMenu(_ sender: Any) {
//
//        sideMenuController?.toggle()
//
//    }
    
    
    func onGetEstimateFare() {
        
        self.socket.on(SocketData.kReceiveGetEstimateFare, callback: { (data, ack) in
            //print("onGetEstimateFare() is \(data)")
            

            if (((data as NSArray).firstObject as? NSDictionary) != nil) {
                var estimateData = (data as! [[String:AnyObject]])
                
                if estimateData[0]["estimate_fare"] != nil
                {
                    estimateData =  estimateData[0]["estimate_fare"] as! [[String:AnyObject]]
                
                let sortedArray = estimateData.sorted {($0["sort"] as! Int) < ($1["sort"] as! Int)}
                
                
                if self.aryEstimateFareData == self.aryEstimateFareData {

                    let ary1 = self.aryEstimateFareData as! [[String:AnyObject]]
                    let ary2 = sortedArray

                    for i in 0..<self.aryEstimateFareData.count {

                        let dict1 = ary1[i] as NSDictionary
                        let dict2 = ary2[i] as NSDictionary

                        if dict1 != dict2 {

                            UIView.performWithoutAnimation {
                                self.collectionViewCars.reloadData()
                            }
                        }

                    }

                }

                self.aryEstimateFareData = NSMutableArray(array: sortedArray).mutableCopy() as! NSMutableArray
                var count = Int()
                for i in 0..<self.arrNumberOfOnlineCars.count
                {
                    let dictOnlineCarData = (self.arrNumberOfOnlineCars.object(at: i) as! NSDictionary)
                    count = count + (dictOnlineCarData["carCount"] as! Int)
                    if (count == 0)
                    {
                        
                        if(self.arrNumberOfOnlineCars.count == 0)
                        {
                            
                            let alert = UIAlertController(title: "",
                                                          message: "Book Now cars not available. Please click OK to Book Later.",
                                                          preferredStyle: UIAlertControllerStyle.alert)
                            
                            
                            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (action) in
                                self.btnBookLater((Any).self)
                            }))
                            
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                            }))
                            
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                
                UIView.performWithoutAnimation {
                    self.collectionViewCars.reloadData()
                }
            }
            
        }
         
        })
    }
    
    //MARK: - Setup Google Maps
    func setupGoogleMap()
    {
        // Initialize the location manager.
        //        locationManager = CLLocationManager()
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        //        locationManager.distanceFilter = 0.1
        //        locationManager.delegate = self
        //        locationManager.startUpdatingLocation()
        //        locationManager.startUpdatingHeading()
        
        locationManager.delegate = self
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            if (locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) || locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
            {
                if locationManager.location != nil
                {
                    locationManager.startUpdatingLocation()
                }
            }
        }
        
        placesClient = GMSPlacesClient.shared()
        mapView.delegate = self
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 17)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.camera = camera
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.tiltGestures = false
        
        //        let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        //        let marker = GMSMarker(position: position)
        //        marker.map = self.mapView
        //        marker.isDraggable = true
        //        marker.icon = UIImage(named: "iconCurrentLocation")
        //        mapView.settings.myLocationButton = false
        //        mapView.isMyLocationEnabled = true
        
        //        self.mapView.padding = UIEdgeInsets(top:txtDestinationLocation.frame.size.height + txtDestinationLocation.frame.origin.y, left: 0, bottom: 0, right: 0)
        viewMap.addSubview(mapView)
        mapView.isHidden = true
    }
    
    func getPlaceFromLatLong()
    {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            //            self.txtCurrentLocation.text = "No current place"
            self.lblUserFromAddress.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let SelectedCurrentLocation = "\(place.name ?? ""), \(place.formattedAddress ?? "")"
                    self.strPickupLocation = SelectedCurrentLocation
//                        place.formattedAddress!
                    self.doublePickupLat = place.coordinate.latitude
                    self.doublePickupLng = place.coordinate.longitude
                    self.lblUserFromAddress.text = SelectedCurrentLocation
                    self.lblCurrentLocationForDefaultView.text = SelectedCurrentLocation
//                   place.formattedAddress?.components(separatedBy: ", ")
//                        .joined(separator: "\n")
                    self.strLocationType = self.currentLocationMarkerText
                    
                }
            }
        })
    }
    
    //MARK:- IBActions
    
    @objc func newBooking(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "New Booking", message: "This will clear old trip details on map for temporary now.", preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
            self.clearSetupMapForNewBooking()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
           
        })
        alert.addAction(OK)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCollectionViewScrollRight(_ sender: Any) {
        if (arrTotalNumberOfCars.count <= 5) {
            
//            self.collectionViewCars.scrollToItem(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .right, animated: true)
        }
        else {
            
            if self.collectionViewCars!.contentSize.width >= 150 {
                self.collectionViewCars.scrollToItem(at: NSIndexPath(row: arrTotalNumberOfCars.count, section: 0) as IndexPath, at: .right, animated: true)
            }
        }
    }
    
    @IBAction func btnCollectionViewScrollLeft(_ sender: Any)
    {
        self.collectionViewCars.scrollToItem(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .left, animated: true)
    }
    
    
    @IBAction func btnBookNow(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet()
        {
            if intShareRide == 1
            {
                //self.stackViewNumberOfPassenger.isHidden = false
                txtNumberOfPassengers.text = "1"
            }
            else
            {
                //self.stackViewNumberOfPassenger.isHidden = true
                txtNumberOfPassengers.text = ""
            }
            
            if SingletonClass.sharedInstance.strPassengerID == "" || strModelId == "" || strPickupLocation == "" || strDropoffLocation == "" || doublePickupLat == 0 || doublePickupLng == 0 || doubleDropOffLat == 0 || doubleDropOffLng == 0 || strCarModelID == ""
            {
                if self.lblUserFromAddress.text?.count == 0
                {
                    UtilityClass.setCustomAlert(title: "Missing", message: "Please enter your pickup location again") { (index, title) in
                    }
                }
                else if self.lblUserToAddress.text?.count == 0 {
                    
                    UtilityClass.setCustomAlert(title: "Missing", message: "Please enter your destination again") { (index, title) in
                    }
                }
                else if strModelId == ""
                {
                    
                    //                UtilityClass.setCustomAlert(title: "Missing", message: "Please Select Car".localized) { (index, title) in
                    //                }
                    UtilityClass.setCustomAlert(title: "Missing", message: "No Driver Available Right Now.".localized) { (index, title) in
                    }
                    //                    UtilityClass.setCustomAlert(title: appName, message: "There are no cars available. Do you want to pay extra chareges?") { (index, title) in
                    //                    }
                    
                    
                    //"There are no vehicles available within 5 kms and do u want to pay additional \(currencySign) \(strSpecialRequestFareCharge) and make a booking?"
                    
//                    let alert = UIAlertController(title: appName, message: "Car not available"  , preferredStyle: .alert)
//                    let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
////                        self.strSpecialRequest = "1"
////                        self.bookingRequest()
////                        self.webserviceCallForMissBookingRequest()
//
//                    })
////                    let Cancel = UIAlertAction(title: "No", style: .destructive, handler: { ACTION in
////
////                        self.webserviceCallForMissBookingRequest()
////
////                    })
////
//
//                    alert.addAction(OK)
////                    alert.addAction(Cancel)
//                    self.present(alert, animated: true, completion: nil)
                    
                }
                else {
                    
                    UtilityClass.setCustomAlert(title: "Missing", message: "Locations or select available car") { (index, title) in
                    }
                }
                
            }
            else {
                strSpecialRequest = "0"
                bookingRequest()
                
                //                if (SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0) && self.aryCardsListForBookNow.count == 2 {
                //                    //                UtilityClass.showAlert("", message: "There is no card, If you want to add card than choose payment options to add card.", vc: self)
                //
                //                    let alert = UIAlertController(title: nil, message: "Do you want to add card.", preferredStyle: .alert)
                //                    let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
                //
                //                        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
                //
                //                        next.delegateAddCardFromHomeVC = self
                //
                //                        self.navigationController?.present(next, animated: true, completion: nil)
                //
                //                    })
                //                    let Cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ACTION in
                //                        self.paymentOptions()
                //                    })
                //                    alert.addAction(OK)
                //                    alert.addAction(Cancel)
                //                    self.present(alert, animated: true, completion: nil)
                //
                //                }
                //                else {
                //                    self.paymentOptions()
                //                }
            }
            
        }
        else {
            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        }
    }
    
    
    func bookingRequest()
    {
        
//        if (SingletonClass.sharedInstance.CardsVCHaveAryData.count == 0) && self.aryCardsListForBookNow.count == 2 {
//            //                UtilityClass.showAlert("", message: "There is no card, If you want to add card than choose payment options to add card.", vc: self)
//
//            let alert = UIAlertController(title: nil, message: "Do you want to add card.", preferredStyle: .alert)
//            let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
//
//                let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//
//                next.delegateAddCardFromHomeVC = self
//
//                self.navigationController?.present(next, animated: true, completion: nil)
//
//            })
//            let Cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { ACTION in
//                self.paymentOptions()
//            })
//            alert.addAction(OK)
//            alert.addAction(Cancel)
//            self.present(alert, animated: true, completion: nil)
//
//        }
//        else {
            self.paymentOptions()
//        }
        
        
    }
    
    
    @IBOutlet weak var lblSelectPaymentTitle: UILabel!
    
    @IBOutlet weak var lblPromocode: UILabel!
    @IBOutlet weak var PayCashView: UIView!
    
    @IBOutlet weak var CashLogo: UIImageView!
    @IBOutlet weak var btnCash: UIButton!
    
    
    
    @IBOutlet weak var PayWalletView: UIView!
    @IBOutlet weak var WalletLogo: UIImageView!
    @IBOutlet weak var btnWallet: UIButton!
    
    
    @IBOutlet weak var PayCardView: UIView!
    @IBOutlet weak var CardLogo: UIImageView!
    @IBOutlet weak var btnPesaPal: UIButton!
    
    
    
    @IBAction func btnPayment(_ sender: UIButton) {
    
        switch sender {
        case self.btnCash:
            self.SetPaymentOption(SelectionIndex: 0)
            
        case self.btnWallet:
            self.SetPaymentOption(SelectionIndex: 1)
            
        case self.btnPesaPal:
            self.SetPaymentOption(SelectionIndex: 2)
            
        default:
            break
        }

    
    }
    
    @IBAction func btnPesaPalOptionClicked(_ sender: UIButton)
    {
        
    }
    func SetPaymentOption(SelectionIndex:Int) {
        
        self.CashLogo.image = UIImage(named: "icon_CashUnselected")
        self.WalletLogo.image = UIImage(named: "icon_UnSelectedWallet")
        self.CardLogo.image = UIImage(named: "icon_UnselectedCard")

        self.btnCash.isSelected = false
        self.btnWallet.isSelected = false
        self.btnPesaPal.isSelected = false

        self.PayCashView.backgroundColor = UIColor.init(hex: "E5E5E5")
        self.PayWalletView.backgroundColor = UIColor.init(hex: "E5E5E5")
        self.PayCardView.backgroundColor = UIColor.init(hex: "E5E5E5")


        if SelectionIndex == 0 {
            self.CashLogo.image = UIImage(named: "icon_SelectedCash")
            self.btnCash.isSelected = true
            self.PayCashView.backgroundColor = UIColor.black
            paymentType = "cash"

        } else if SelectionIndex == 1 {
            self.WalletLogo.image = UIImage(named: "icon_SelectedWallet")
            self.btnWallet.isSelected = true
            self.PayWalletView.backgroundColor = UIColor.black
            paymentType = "wallet"
        } else if SelectionIndex == 2 {
            self.CardLogo.image = UIImage(named: "icon_SelectedCard")
            self.btnPesaPal.isSelected = true
            self.PayCardView.backgroundColor = UIColor.black
            paymentType = "pesapal"//"card"
        }
        
        
        
//        paymentType = "cash"
    }
    
    
    @IBAction func btnAddCard(_ sender: Any) {
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
//        SingletonClass.sharedInstance.isFromTopUP = true
//        next.delegateForTopUp = self
//        self.navigationController?.pushViewController(next, animated: true)
        
        
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
//
//        next.delegateAddCardFromHomeVC = self
//
//        self.navigationController?.present(next, animated: true, completion: nil)
        
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Select Card Delegate Methods
    //-------------------------------------------------------------
    
    func didSelectCard(dictData: [String : AnyObject]) {
        print(dictData)
        CardID = dictData["Id"] as! String
        self.SetPaymentOption(SelectionIndex: 2)
    }
    
    func paymentOptions()
    {
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count != 0 {
            
            cardData = SingletonClass.sharedInstance.CardsVCHaveAryData
            
            for i in 0..<aryCardsListForBookNow.count {
                cardData.append(aryCardsListForBookNow[i])
            }
            
            if self.aryCardsListForBookNow.count != 0 {
                cardData = self.aryCardsListForBookNow
            }
            
        }
        else {
            cardData.removeAll()
            
            for i in 0..<aryCardsListForBookNow.count {
                cardData.append(aryCardsListForBookNow[i])
            }
        }
        self.pickerView.reloadAllComponents()
        
        let data = cardData[0]
        
        //        imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        //        txtSelectPaymentOption.text = data["CardNum2"] as? String
        //
        let type = data["CardNum"] as! String
        
        if type  == "wallet" {
            paymentType = "wallet"
        }
        else if type == "cash" {
            paymentType = "cash"
        }
        else {
            paymentType = "pesapal"//"card"
        }
        
        if paymentType == "card" {
            CardID = data["Id"] as! String
        }
        
        //        self.SetPaymentOption(SelectionIndex: 0)
        //viewBookNow.isHidden = false
        paymentType = "cash"
        self.webserviceCallForBookingCar()
    }
    
    func didAddCardFromHomeVC() {
        paymentOptions()
    }
    
    @IBAction func btnBookLater(_ sender: Any)
    {
        if Connectivity.isConnectedToInternet() {
            
            let profileData = SingletonClass.sharedInstance.dictProfile
            // This is For Book Later Address
            if (SingletonClass.sharedInstance.isFromNotificationBookLater) {
                
                if strCarModelID == ""
                {
                    UtilityClass.setCustomAlert(title: "Missing", message: "No Driver Available Right Now.".localized) { (index, title) in
                    }
                }
                else
                {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterViewController
                    
                    SingletonClass.sharedInstance.isFromNotificationBookLater = false
                    next.delegateBookLater = self
                    next.strModelId = strCarModelID
                    next.strCarModelURL = strNavigateCarModel
                    next.strCarName = strCarModelClass
                    
                    next.strFullname = profileData.object(forKey: "Fullname") as! String
                    next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                    
                    next.strPickupLocation = strPickupLocation
                    next.doublePickupLat = doublePickupLat
                    next.doublePickupLng = doublePickupLng
                    
                    next.strDropoffLocation = strDropoffLocation
                    next.doubleDropOffLat = doubleDropOffLat
                    next.doubleDropOffLng = doubleDropOffLng
                    
                    self.navigationController?.pushViewController(next, animated: true)
                }
            }
            else {
                
                if strCarModelID == "" && strCarModelIDIfZero == ""{
                    //                UtilityClass.setCustomAlert(title: "Missing", message: "Please Select Car".localized) { (index, title) in
                    //                }
                    UtilityClass.setCustomAlert(title: "Missing", message: "No Driver Available Right Now.".localized) { (index, title) in
                    }
                }
                else {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "BookLaterViewController") as! BookLaterViewController
                    next.delegateBookLater = self
                    next.strModelId = strCarModelID
                    next.strCarModelURL = strNavigateCarModel
                    next.strCarName = strCarModelClass
                    
                    next.strPickupLocation = strPickupLocation
                    next.doublePickupLat = doublePickupLat
                    next.doublePickupLng = doublePickupLng
                    
                    next.strDropoffLocation = strDropoffLocation
                    next.doubleDropOffLat = doubleDropOffLat
                    next.doubleDropOffLng = doubleDropOffLng
                    
                    next.strFullname = profileData.object(forKey: "Fullname") as! String
                    next.strMobileNumber = profileData.object(forKey: "MobileNo") as! String
                    
                    self.navigationController?.pushViewController(next, animated: true)
                    
                }
            }
        }
        else
        {
            UtilityClass.showAlert("", message: "Internet connection not available", vc: self)
        }
    }
    
    @IBAction func btnGetFareEstimate(_ sender: Any) {
        
        if lblUserFromAddress.text == "" || lblUserToAddress.text == "" {
            UtilityClass.setCustomAlert(title: "Missing", message: "Please enter both address.") { (index, title) in
            }
        }
        else
        {
            self.postPickupAndDropLocationForEstimateFare()
        }
    }
    
    @IBAction func btnCancelBookingClickAction(_ sender: ThemeButton)
    {
        let alert = UIAlertController(title: nil, message: "If you cancel the trip then you will be partially charged. Are you sure you want to cancel the trip?".localized, preferredStyle: .alert)
        let OK = UIAlertAction(title: "YES".localized, style: .default, handler: { ACTION in
            
            if self.strBookingType == "BookLater"
            {
                self.CancelBookLaterTripAfterDriverAcceptRequest()
            }
            else
            {
                self.socketMethodForCancelRequestTrip()
            }
            
            self.clearMap()
            self.lblUserToAddress.text = ""
            self.lblUserFromAddress.text = ""
            self.clearDataAfteCompleteTrip()
            self.getPlaceFromLatLong()
            self.viewTripActions.isHidden = true
            self.viewCarLists.isHidden = false
            self.ConstantViewCarListsHeight.constant = 150
        })
        let Cancel = UIAlertAction(title: "NO".localized, style: .destructive, handler: { ACTION in
            //            self.paymentOptions()
        })
        alert.addAction(OK)
        alert.addAction(Cancel)
        self.present(alert, animated: true, completion: nil)
        //        Utilities.presentPopupOverScreen(alert)
        //        self.constraintTopSpaceViewDriverInfo.constant = 170
        //        self.viewShareRideView.isHidden = true
        
    }
    
//    @IBOutlet weak var btnDriverInfo: ThemeButton!
    @IBAction func btnDriverInfo(_ sender: ThemeButton) {
   
        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        let carInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        
        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
    }
    
    @IBAction func swipDownDriverInfo(_ sender: UISwipeGestureRecognizer) {
        //        constraintTopSpaceViewDriverInfo.constant = 170
    }
    
    @IBAction func TapToDismissGesture(_ sender: UITapGestureRecognizer) {
        UIView.transition(with: viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewForMainFavourite.isHidden = true
        }) { _ in }
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        //        self.dismiss(animated: true, completion: nil)
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    //-------------------------------------------------------------
    // MARK: - Favourite Delegate Methods
    //-------------------------------------------------------------
    
    func didEnterFavouriteDestination(Source: [String:AnyObject]) {
        lblUserToAddress.text = Source["Address"] as? String
        strDropoffLocation = Source["Address"] as! String
        doubleDropOffLat = Double(Source["Lat"] as! String)!
        doubleDropOffLng = Double(Source["Lng"] as! String)!
    }
    
    //-------------------------------------------------------------
    // MARK: - Favourites Actions
    //-------------------------------------------------------------
    
    @IBAction func btnHome(_ sender: UIButton) {
        webserviceOfAddAddressToFavourite(type: "Home")
    }
    
    @IBAction func btnOffice(_ sender: UIButton) {
        webserviceOfAddAddressToFavourite(type: "Office")
    }
    
    @IBAction func btnAirport(_ sender: UIButton) {
        webserviceOfAddAddressToFavourite(type: "Airport")
    }
    
    @IBAction func btnOthers(_ sender: UIButton) {
        webserviceOfAddAddressToFavourite(type: "Others")
    }
    
    @IBAction func btnSwapAddress(_ sender: UIButton) {
        
        let pickupLet = self.doublePickupLat
        let pickuplong = self.doublePickupLng
        
        let dropoffLet = self.doubleDropOffLat
        let dropoffLong = self.doubleDropOffLng
        
        //let FromAddress:String = self.txtCurrentLocation.text!
        //let ToAddress:String = self.txtDestinationLocation.text!
        
        self.doublePickupLat = dropoffLet
        self.doublePickupLng = dropoffLong
        
        self.doubleDropOffLat = pickupLet
        self.doubleDropOffLng = pickuplong
        
        //self.txtDestinationLocation.text = FromAddress
        //self.txtCurrentLocation.text = ToAddress
    }
    
    //-------------------------------------------------------------
    // MARK: - Sound Implement Methods
    //-------------------------------------------------------------
    
    var audioPlayer:AVAudioPlayer!
    
    //    RequestConfirm.m4a
    //    ringTone.mp3
    
    
    func playSound(fileName: String, extensionType: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            audioPlayer.numberOfLoops = 1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound(fileName: String, extensionType: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            audioPlayer.stop()
            audioPlayer = nil
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
   
    
    var markerOnlineCars = GMSMarker()
    var aryMarkerOnlineCars = [GMSMarker]()
    var carLocationsLat = Double()
    var carLocationsLng = Double()
    //MARK - Set car icons
    func setData()
    {
        var k = 0 as Int
        self.arrNumberOfOnlineCars.removeAllObjects()
        aryTempOnlineCars = NSMutableArray()
        
        for j in 0..<self.arrTotalNumberOfCars.count
        {
            if ((self.arrTotalNumberOfCars[j] as! [String:AnyObject])["Status"] as! String) == "1" {
                
                k = 0
                let tempAryLocationOfDriver = NSMutableArray()
                
                let totalCarsAvailableCarTypeID = (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary).object(forKey: "Id") as! String
                for i in 0..<self.arrNumberOfAvailableCars.count
                {
                    let dictLocation = NSMutableDictionary()
                    
                    let carType = (self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "CarType") as! String
                    
                    if (totalCarsAvailableCarTypeID == carType)
                    {
                        k = k+1
                    }
                    
                    carLocationsLat = ((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray).object(at: 0) as! Double
                    carLocationsLng = ((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray).object(at: 1) as! Double
                    dictLocation.setDictionary(((self.arrNumberOfAvailableCars.object(at: i) as! NSDictionary) as! [AnyHashable : Any]))
                    tempAryLocationOfDriver.add(dictLocation)
                    
                }

                let tempDict =  NSMutableDictionary(dictionary: (self.arrTotalNumberOfCars.object(at: j) as! NSDictionary))
                tempDict.setObject(k, forKey: "carCount" as NSCopying)
                tempDict.setObject(carLocationsLat, forKey: "Lat" as NSCopying)
                tempDict.setObject(carLocationsLng, forKey: "Lng" as NSCopying)
                tempDict.setObject(tempAryLocationOfDriver, forKey: "locations" as NSCopying)
                
                
                aryTempOnlineCars.add(tempDict)
            }
            
        }
        
        SortIdOfCarsType()
        
    }
    
    var aryTempOnlineCars = NSMutableArray()
    var checkTempData = NSArray()
    var aryOfOnlineCarsIds = [String]()
    var aryOfTempOnlineCarsIds = [String]()
    func SortIdOfCarsType() {
        
        //        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
        
        let sortedArray = (self.aryTempOnlineCars as NSArray).sortedArray(using: [NSSortDescriptor(key: "Sort", ascending: true)]) as! [[String:AnyObject]]
        
        self.arrNumberOfOnlineCars = NSMutableArray(array: sortedArray)
        
        if self.checkTempData.count == 0 {
            
            SingletonClass.sharedInstance.isFirstTimeReloadCarList = true
            self.checkTempData = self.aryTempOnlineCars as NSArray
            
            self.collectionViewCars.reloadData()
        }
        else {
            
            for i in 0..<self.aryTempOnlineCars.count {
                
                let arySwif = self.aryTempOnlineCars.object(at: i) as! NSDictionary
                
                if (self.checkTempData.object(at: i) as! NSDictionary) == arySwif {
                    
                    if SingletonClass.sharedInstance.isFirstTimeReloadCarList == true {
                        SingletonClass.sharedInstance.isFirstTimeReloadCarList = false
                        
                        if self.lblUserFromAddress.text?.count != 0 && self.lblUserToAddress.text?.count != 0 && self.aryOfOnlineCarsIds.count != 0
                        {
                            self.postPickupAndDropLocationForEstimateFare()
                        }
                        self.collectionViewCars.reloadData()
                        
                    }
                }
                else
                {
                    self.checkTempData = self.aryTempOnlineCars as NSArray
                    
                    if self.lblUserFromAddress.text?.count != 0 && self.lblUserToAddress.text?.count != 0 && self.aryOfOnlineCarsIds.count != 0
                    {
                        self.postPickupAndDropLocationForEstimateFare()
                    }
                    self.collectionViewCars.reloadData()
                    
                }
            }
        }
        //        })
        
    }
    
    //    func markertIcon(index: Int) -> String {
    //
    //        switch index {
    //        case 0: // "1":
    //            return "imgTaxi"
    //        case 1: // "2":
    //            return "imgTaxi"
    //        case 2: // "3":
    //            return "imgTaxi"
    //        case 3: // "4":
    //            return "imgTaxi"
    //        case 4: // "5":
    //            return "imgTaxi"
    //        case 5: // "6":
    //            return "imgTaxi"
    //        case 6: // "7":
    //            return "imgTaxi"
    //            //        case "8":
    //            //            return "imgTaxi"
    //            //        case "9":
    //            //            return "imgTaxi"
    //            //        case "10":
    //            //            return "imgTaxi"
    //            //        case "11":
    //        //            return "imgTaxi"
    //        default:
    //            return "imgTaxi"
    //        }
    
    func setCarImage(modelId : String) -> String {
        
        var CarModel = String()
        
        switch modelId {
//        case "1":
//            CarModel = "imgBusinessClass"
//            return CarModel
//        case "2":
//            CarModel = "imgMIni"
//            return CarModel
//        case "3":
//            CarModel = "imgVan"
//            return CarModel
//        case "4":
//            CarModel = "imgNano"
//            return CarModel
//        case "5":
//            CarModel = "imgTukTuk"
//            return CarModel
//        case "6":
//            CarModel = "imgBreakdown"
//            return CarModel
        default:
            CarModel = "dummyCar"
            return CarModel
        }
    }
    
    /*/
     switch index {
     case 0: // "1":
     return "iconNano"
     case 1: // "2":
     return "iconPremium"
     case 2: // "3":
     return "iconBreakdownServices"
     case 3: // "4":
     return "iconVan"
     case 4: // "5":
     return "iconTukTuk"
     case 5: // "6":
     return "iconMiniCar"
     case 6: // "7":
     return "iconBusRed"
     //        case "8":
     //            return "Motorbike"
     //        case "9":
     //            return "Car Delivery"
     //        case "10":
     //            return "Van / Trays"
     //        case "11":
     //            return "3T truck"
     default:
     return "imgTaxi"
     }
     */
    
    //        switch index {
    //        case 0:
    //            return "imgFirstClass"
    //        case 1:
    //            return "imgBusinessClass"
    //        case 2:
    //            return "imgEconomy"
    //        case 3:
    //            return "imgTaxi"
    //        case 4:
    //            return "imgLUXVAN"
    //        case 5:
    //            return "imgDisability"
    //        default:
    //            return ""
    //        }
    
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue)
    {
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "seguePresentTripDetails")
        {
            let drinkViewController = segue.destination as! TripDetailsViewController
            drinkViewController.arrData = arrDataAfterCompletetionOfTrip as NSMutableArray
            drinkViewController.delegate = self
            
        }
        
        if(segue.identifier == "segueDriverInfo")
        {
            //            let deiverInfo = segue.destination as! DriverInfoViewController
        }
        if(segue.identifier == "showRating")
        {
            
            let GiveRatingVC = segue.destination as! GiveRatingViewController
            GiveRatingVC.strBookingType = self.strBookingType
            //            GiveRatingVC.delegate = self
        }
    }
    
    
    //MARK:- Side Menu Navigation
    @objc func GotoProfilePage() {
        /* Raj Changes
        let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(NextPage, animated: true) */
        
        let viewController = LoginAndRegisterStoryboard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController        
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @objc func GotoHomePage()
    {
//        let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        self.navigationController?.pushViewController(NextPage, animated: true)
        self.setLocalization()
        self.setNavBarWithMenu(Title: "Home".localized, IsNeedRightButton: true)
    }
    
    @objc func GotoMyBookingPage() {
        let NextPage = MyRidesStoryBoard.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoPaymentPage() {
        
        if SingletonClass.sharedInstance.CardsVCHaveAryData.count > 0
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
        else
        {
            //let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletCardsVC") as! WalletCardsVC
            
            let paymentMethodsVC = PaymentMethodStoryBoard.instantiateViewController(withIdentifier: "PaymentMethodsViewController") as! PaymentMethodsViewController
            self.navigationController?.pushViewController(paymentMethodsVC, animated: true)
        }
    }
    
    @objc func GotoWalletPage() {
        if (SingletonClass.sharedInstance.isPasscodeON) {
            
            if SingletonClass.sharedInstance.setPasscode == "" {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasscodeViewController") as! SetPasscodeViewController
                viewController.strStatusToNavigate = "Wallet"
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else {
                
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPasswordViewController") as! VerifyPasswordViewController
                viewController.strStatusToNavigate = "Wallet"
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            self.navigationController?.pushViewController(next, animated: true)
        }
        
//        let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
//        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoMyReceiptPage() {
        let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "MyReceiptsViewController") as! MyReceiptsViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoFavouritePage() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MyRatingViewController") as! MyRatingViewController
        
//        next.delegateForFavourite = self
        
        self.navigationController?.pushViewController(next, animated: true)
        
//        let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
//        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoInviteFriendPage() {
        let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "InviteDriverViewController") as! InviteDriverViewController
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoSettingPage() {
        let NextPage = self.storyboard?.instantiateViewController(withIdentifier: "SettingPasscodeVC") as! SettingPasscodeVC
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func GotoSupportPage()
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "webViewVC") as! webViewVC
        next.headerName = "\(appName)"
        next.strURL = "https://www.tantaxitanzania.com/front/about"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    func BookingConfirmed(dictData : NSDictionary)
    {
        
        let DriverInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "DriverInfo") as! NSArray).object(at: 0) as! NSDictionary
        let carInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary
        let bookingInfo = ((self.aryRequestAcceptedData.object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        
        
        //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
    }
    
    //MARK: - Socket Methods
    func socketMethods()
    {
        var isSocketConnected = Bool()
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print ("socket is disconnected please reconnect")
        }
        
        socket.on(clientEvent: .reconnect) { (data, ack) in
            print ("socket is reconnected")
        }
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
            self.methodsAfterConnectingToSocket()
            
            if self.socket.status != .connected {
                
                print("socket.status != .connected")
            }
            
            if (isSocketConnected == false) {
                isSocketConnected = true
                
                self.socketMethodForGettingBookingAcceptNotification()  // Accept Now Req
                self.socketMethodForGettingBookingRejectNotification()  // Reject Now Req
                self.socketMethodForGettingPickUpNotification()         // Start Now Req
                self.socketMethodForGettingTripCompletedNotification()  // CompleteTrip Now Req
                self.onTripHoldingNotificationForPassengerLater()       // Hold Trip Later
                self.onReceiveDriverLocationToPassenger()               // Driver Location Receive
                self.socketMethodForGettingBookingRejectNotificatioByDriver()   // Reject By Driver
                self.onAcceptBookLaterBookingRequestNotification()              // Accept Later Req
                self.onRejectBookLaterBookingRequestNotification()              // Reject Later Req
                self.onPickupPassengerByDriverInBookLaterRequestNotification()
                self.onTripHoldingNotificationForPassenger()                    // Hold Trip Now
                self.onBookingDetailsAfterCompletedTrip()                       // Booking Details After Complete Trip
                self.socketMethodForGiveTipToDriver()
                self.socketMethodForGiveTipToDriverBookLater()
                self.onAdvanceTripInfoBeforeStartTrip()                         // Start Later Req
                self.onReceiveNotificationWhenDriverAcceptRequest()
                self.onGetEstimateFare()
            }
            
            // Get Estimate
            
            self.socket.on(SocketData.kNearByDriverList, callback: { (data, ack) in
                //                print("data is \(data)")
                
                self.arrNumberOfAvailableCars = NSMutableArray(array: ((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray)
                self.setData()
                
                if (((data as NSArray).object(at: 0) as! NSDictionary).count != 0)
                {
                    for i in 0..<(((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).count
                    {
                        
                        let arrayOfCoordinte = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "Location") as! NSArray
                        let lat = arrayOfCoordinte.object(at: 0) as! Double
                        let long = arrayOfCoordinte.object(at: 1) as! Double
                        
                        let DriverId = ((((data as NSArray).object(at: 0) as! NSDictionary).object(forKey: "driver") as! NSArray).object(at: i) as! NSDictionary).object(forKey: "DriverId") as! String
                        
                        self.aryOfTempOnlineCarsIds.append(DriverId)
                        self.aryOfOnlineCarsIds = self.uniq(source: self.aryOfTempOnlineCarsIds)
                        
                    }
                }
                self.postPickupAndDropLocationForEstimateFare()
                
                
            })
            
        }
        
        socket.connect()
    }
    
    @objc func bookingAcceptNotificationMethodCallInTimer() {
        timesOfAccept += 1
        print("ACCCEPT by Timer: \(timesOfAccept)")
        
        self.socketMethodForGettingBookingAcceptNotification()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func updateCounting(){
        let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Lat": doublePickupLat, "Long": doublePickupLng, "Token" : SingletonClass.sharedInstance.deviceToken, "ShareRide": SingletonClass.sharedInstance.isShareRide] as [String : Any]
        socket.emit(SocketData.kUpdatePassengerLatLong , with: [myJSON])
        
    }
    
    func methodsAfterConnectingToSocket()
    {
        scheduledTimerWithTimeInterval()
    }
    func socketMethodForGiveTipToDriverBookLater()
    {
        self.socket.on(SocketData.kAskForTipsToPassengerForBookLater, callback: { (data, ack) in
            print("kAskForTipsToPassenger for BookLater: \(data)")
            
            
            self.showTimerProgressViaInstance()
            
            
            let msg = (data as NSArray)
            
            self.alertForTip = UIAlertController(title: "Tip Alert".localized,
                                                 message: (msg.object(at: 0) as! NSDictionary).object(forKey: "message") as? String,
                                                 preferredStyle: UIAlertControllerStyle.alert)
            
            //2. Add the text field. You can configure it however you need.
            self.alertForTip.addTextField { (textField) in
                textField.placeholder = "Add Tip".localized
                textField.keyboardType = .decimalPad
//                Utilities.setLeftPaddingInTextfield(textfield: textField, padding: 10)
                
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            self.alertForTip.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { ACTION in
                let textField = self.alertForTip.textFields![0] // Force unwrapping because we know it exists.
                self.strTipAmount = (textField.text)!
                print("Text field: \(String(describing: textField.text))")
                
//                if !UtilityClass.isEmpty(str: (textField.text)!)
//                {
                    let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Amount": self.strTipAmount, "BookingId": SingletonClass.sharedInstance.bookingId] as [String : Any]
                    self.socket.emit(SocketData.kReceiveTipsForBookLater , with: [myJSON])
//                }
//                else
//                {
//                    let alret = UIAlertController(title: appName,
//                                                         message: "Please enter amount",
//                                                         preferredStyle: UIAlertControllerStyle.alert)
//                    alret.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in
//                        
//                        
//                    }))
//                    UtilityClass.presentPopupOverScreen(alret)
//                }
            }))
            
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            self.alertForTip.addAction(UIAlertAction(title: "NO".localized, style: .destructive, handler: { [] (_) in
                
                let myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Amount": "", "BookingId": SingletonClass.sharedInstance.bookingId] as [String : Any]
                self.socket.emit(SocketData.kReceiveTipsForBookLater , with: [myJSON])
                
                self.strTipAmount = ""
                
            }))
            
            // 4. Present the alert.
            self.present(self.alertForTip, animated: true, completion: nil)
            
            
        })
    }
    func showTimerProgressViaInstance()
    {
        if timerOfRequest == nil {
            timerOfRequest = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.showTimer), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func showTimer()
    {
        progressCompleted += 1
        if progressCompleted >= 25
        {
            self.boolTimeEnd = true
            self.timerDidEnd()
            timerOfRequest.invalidate()
        }
    }
    func timerDidEnd()
    {
        if (boolTimeEnd)
        {
            timerOfRequest.invalidate()
            alertForTip.dismiss(animated: true, completion: nil)
        }
        else
        {
            timerOfRequest.invalidate()
            alertForTip.dismiss(animated: true, completion: nil)
        }
    }
    func socketMethodForGiveTipToDriver()
    {
        self.socket.on(SocketData.kAskForTipsToPassenger, callback: { (data, ack) in
            print("kAskForTipsToPassenger: \(data)")
            
            //            kAskForTipsToPassenger: [{
            //            message = "Tesluxe driver Ask For Tips. Do you want to give tips?";
            //            }]
            
            
            self.showTimerProgressViaInstance()
            
            
            let msg = (data as NSArray)
            
            self.alertForTip = UIAlertController(title: "Tip Alert".localized,
                                                 message: (msg.object(at: 0) as! NSDictionary).object(forKey: "message") as? String,
                                                 preferredStyle: UIAlertControllerStyle.alert)
            
            //2. Add the text field. You can configure it however you need.
            self.alertForTip.addTextField { (textField) in
                textField.placeholder = "Add Tip".localized
                textField.keyboardType = .decimalPad
//                Utilities.setLeftPaddingInTextfield(textfield: textField, padding: 10)
                
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            self.alertForTip.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { ACTION in
                let textField = self.alertForTip.textFields![0] // Force unwrapping because we know it exists.
                self.strTipAmount = (textField.text)!
                print("Text field: \(String(describing: textField.text))")
                
//                if !UtilityClass.isEmpty(str: (textField.text)!)
//                {
//
                    let myJSON = ["Running": 0,"PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Amount": self.strTipAmount, "BookingId": SingletonClass.sharedInstance.bookingId] as [String : Any]
                    self.socket.emit(SocketData.kReceiveTips , with: [myJSON])

                    print("kReceiveTips yes tip is given: \(myJSON)")
//
//                }
//                else
//                {
//                    let alret = UIAlertController(title: appName,
//                                                  message: "Please enter amount",
//                                                  preferredStyle: UIAlertControllerStyle.alert)
//                    alret.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in
//
//
//                    }))
//                    self.present(alret, animated: true, completion: nil)
////                    UtilityClass.presentPopupOverScreen(alret)
//                }
            }))
            
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            self.alertForTip.addAction(UIAlertAction(title: "NO".localized, style: .destructive, handler: { [] (_) in
                
                let myJSON = ["Running": 0,"PassengerId" : SingletonClass.sharedInstance.strPassengerID, "Amount": "", "BookingId": SingletonClass.sharedInstance.bookingId] as [String : Any]
                self.socket.emit(SocketData.kReceiveTips , with: [myJSON])
                print("kReceiveTips no tip not given: \(myJSON)")
                self.strTipAmount = ""
                
            }))
            
            // 4. Present the alert.
            //            self.present(self.alertForTip, animated: true, completion: nil)
            
//            Utilities.presentPopupOverScreen(self.alertForTip)
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(self.alertForTip, animated: true, completion: nil)
            
        })
    }
    
    func socketMethodForGettingBookingAcceptNotification()
    {
        // Socket Accepted
        self.socket.on(SocketData.kAcceptBookingRequestNotification, callback: { (data, ack) in
            print("AcceptBooking data is \(data)")
            
            self.locationManager.startUpdatingLocation()
            
            if let getInfoFromData = data as? [[String:AnyObject]] {
                
                if let infoData = getInfoFromData[0] as? [String:AnyObject] {
                    if let bookingInfo = infoData["BookingInfo"] as? [[String:AnyObject]] {
                        var bookingIdIs = String()
                        if let nowBookingID: Int = (bookingInfo[0])["Id"] as? Int {
                            bookingIdIs = "\(nowBookingID)"
                        }
                        else if let nowBookingID: String = (bookingInfo[0])["Id"] as? String
                        {
                            bookingIdIs = nowBookingID
                        }
                        print("bookingIdIs: \(bookingIdIs)")
                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String
                        {
                            if SelectedLanguage == "en"
                            {
                                UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                                    
                                })
                            }
                            else if SelectedLanguage == "sw"
                            {
                                UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                                    
                                })
                            }
                        }
                        if SingletonClass.sharedInstance.bookingId != ""
                        {
                            if SingletonClass.sharedInstance.bookingId == bookingIdIs {
                                self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                            }
                        }
                        else
                        {
                            self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                        }
                    }
                }
            }
            
        })
    }
    
    func DriverInfoAndSetToMap(driverData: NSArray)
    {
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: true)
        
        //        SingletonClass.sharedInstance.isTripContinue = true
        
        self.MarkerCurrntLocation.isHidden = true
        self.viewTripActions.isHidden = false
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        
        self.viewActivity.stopAnimating()
        self.viewMainActivityIndicator.isHidden = true
        self.btnCancelBooking.isHidden = false
        self.btnCancelBooking.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.btnCancelBooking.bottomAnchor.constraint(equalTo: viewTripActions.bottomAnchor, constant: -16).isActive = true
        
        self.aryRequestAcceptedData = NSArray(array: driverData)
        var bookingInfo : NSDictionary = NSDictionary()
        var DriverInfo: NSDictionary = NSDictionary()
        var carInfo: NSDictionary = NSDictionary()
        var details: NSDictionary = NSDictionary()

        
        if let dicDriverDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "DriverInfo") as? NSDictionary
        {
            DriverInfo = dicDriverDetails
            
        }else if let arrayDriverDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "DriverInfo") as? NSArray, arrayDriverDetails.count > 0
        {
            if let dicDriverDetails = arrayDriverDetails[0] as? NSDictionary
            {
                DriverInfo = dicDriverDetails
            }
        }
        
        
        if let dicBookingsDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "BookingInfo") as? NSDictionary
        {
            DriverInfo = dicBookingsDetails
            
        }else if let arrayBookingsDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "BookingInfo") as? NSArray, arrayBookingsDetails.count > 0
        {
            if let dicBookingsDetails = arrayBookingsDetails[0] as? NSDictionary
            {
                bookingInfo = dicBookingsDetails
            }
        }
        
        if let dicCarDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSDictionary
        {
            carInfo = dicCarDetails
            
        }else if let arrayCarDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSArray, arrayCarDetails.count > 0
        {
            if let dicCarDetails = arrayCarDetails[0] as? NSDictionary
            {
                carInfo = dicCarDetails
            }
        }
        
        
        if let dicDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "Details") as? NSDictionary
        {
            details = dicDetails
            
        }else if let arrayDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "Details") as? NSArray, arrayDetails.count > 0
        {
            if let dicDetails = arrayDetails[0] as? NSDictionary
            {
                details = dicDetails
            }
        }
        
        self.displayOnGoingRideDetails(bookingInfo: bookingInfo, driverInfo: DriverInfo, carInfo: carInfo, details: details)

        if let passengerType = bookingInfo.object(forKey: "PassengerType") as? String {
            
            if passengerType == "other" || passengerType == "others" {
                
                SingletonClass.sharedInstance.passengerTypeOther = true
            }
        }
        
        SingletonClass.sharedInstance.dictDriverProfile = DriverInfo
        SingletonClass.sharedInstance.dictCarInfo = (carInfo as? [String: AnyObject])!
        //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
        
        self.sendPassengerIDAndDriverIDToGetLocation(driverID: String(describing: DriverInfo.object(forKey: "Id")!) , passengerID: String(describing: bookingInfo.object(forKey: "PassengerId")!))
        
        
        self.BookingConfirmed(dictData: (driverData[0] as! NSDictionary) )
        
        let driverInfo = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
        //        let details = (((self.aryRequestAcceptedData as NSArray).object(at: 0) as! NSDictionary).object(forKey: "Details") as! NSArray).object(at: 0) as! NSDictionary
        
        if let bookID =  bookingInfo.object(forKey: SocketDataKeys.kBookingIdNow) as? String
        {
            SingletonClass.sharedInstance.bookingId = bookID
        }
        else if let bookID = bookingInfo.object(forKey: "Id") as? String
        {
            SingletonClass.sharedInstance.bookingId = bookID
        }
        else if let bookID = bookingInfo.object(forKey: "Id") as? Int
        {
            SingletonClass.sharedInstance.bookingId = "\(bookID)"
        }
        
        self.displayOnGoingRideDetails(bookingInfo: bookingInfo, driverInfo: driverInfo, carInfo: carInfo, details: details)
                
        let PickupLat = bookingInfo.object(forKey: "PickupLat") as! String
        let PickupLng =  bookingInfo.object(forKey: "PickupLng") as! String
        
        let DropOffLat = DriverInfo.object(forKey: "Lat") as! String
        let DropOffLon = DriverInfo.object(forKey: "Lng") as! String
        
        let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
        
        let waypointLatitude = Double(PickupLat)! - dummyLatitude
        let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        strPickUpLatitude = PickupLat
        strPickUpLongitude = PickupLng
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(DropOffLat)!,
                                              longitude: Double(DropOffLon)!,
                                              zoom: 17)
        
        mapView.camera = camera
        
        self.getDirectionsAcceptRequest(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil) { (index, title) in
        }
        
//        updatePolyLineToMapFromDriverLocation()
        
//        NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
        
    }
    
    func methodAfterStartTrip(tripData: NSArray) {
        
        self.MarkerCurrntLocation.isHidden = true
        
        SingletonClass.sharedInstance.isTripContinue = true
        
        destinationCordinate = CLLocationCoordinate2D(latitude: dropoffLat, longitude: dropoffLng)
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: true)
        
        self.viewTripActions.isHidden = false
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        // self.viewFromToSubmitButton.isHidden = true
//        self.viewShareRideView.isHidden = true
        
        self.viewActivity.stopAnimating()
        self.viewMainActivityIndicator.isHidden = true
        self.btnCancelBooking.isHidden = true
        self.btnCancelBooking.heightAnchor.constraint(equalToConstant: 0).isActive = true
        self.btnCancelBooking.bottomAnchor.constraint(equalTo: viewTripActions.bottomAnchor, constant: 0).isActive = true
        
        var bookingInfo : NSDictionary = NSDictionary()
        var DriverInfo: NSDictionary = NSDictionary()
        var carInfo: NSDictionary = NSDictionary()
        var details: NSDictionary = NSDictionary()

        
        if let dicDriverDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "DriverInfo") as? NSDictionary
        {
            DriverInfo = dicDriverDetails
      
        }else if let arrayDriverDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "DriverInfo") as? NSArray, arrayDriverDetails.count > 0
        {
            if let dicDriverDetails = arrayDriverDetails[0] as? NSDictionary
            {
                DriverInfo = dicDriverDetails
            }
        }
        
       
        if let dicBookingsDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "BookingInfo") as? NSDictionary
        {
            DriverInfo = dicBookingsDetails
            
        }else if let arrayBookingsDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "BookingInfo") as? NSArray, arrayBookingsDetails.count > 0
        {
            if let dicBookingsDetails = arrayBookingsDetails[0] as? NSDictionary
            {
                bookingInfo = dicBookingsDetails
            }
        }
        
        
        if let dicCarDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSDictionary
        {
            carInfo = dicCarDetails
            
        }else if let arrayCarDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSArray, arrayCarDetails.count > 0
        {
            if let dicCarDetails = arrayCarDetails[0] as? NSDictionary
            {
                carInfo = dicCarDetails
            }
        }
        
        if let dicDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "Details") as? NSDictionary
        {
            details = dicDetails
            
        }else if let arrayDetails = (self.aryRequestAcceptedData.object(at: 0) as? NSDictionary)?.object(forKey: "Details") as? NSArray, arrayDetails.count > 0
        {
            if let dicDetails = arrayDetails[0] as? NSDictionary
            {
                details = dicDetails
            }
        }
        
        self.displayOnGoingRideDetails(bookingInfo: bookingInfo, driverInfo: DriverInfo, carInfo: carInfo, details: details)
        
        SingletonClass.sharedInstance.dictDriverProfile = DriverInfo
        SingletonClass.sharedInstance.dictCarInfo = carInfo as! [String: AnyObject]
        //        showDriverInfo(bookingInfo: bookingInfo, DriverInfo: DriverInfo, carInfo: carInfo)
        
        // ------------------------------------------------------------
        let DropOffLat = bookingInfo.object(forKey: "DropOffLat") as! String
        let DropOffLon = bookingInfo.object(forKey: "DropOffLon") as! String
        
        let picklat = bookingInfo.object(forKey: "PickupLat") as! String
        let picklng = bookingInfo.object(forKey: "PickupLng") as! String
        
        dropoffLat = Double(DropOffLat)!
        dropoffLng = Double(DropOffLon)!
        
        self.lblUserFromAddress.text = bookingInfo.object(forKey: "PickupLocation") as? String
        self.lblUserToAddress.text = bookingInfo.object(forKey: "DropoffLocation") as? String
        
        let PickupLat = self.defaultLocation.coordinate.latitude
        let PickupLng = self.defaultLocation.coordinate.longitude
        
        //        let PickupLat = Double(picklat)
        //        let PickupLng = Double(picklng)
        
        
        let dummyLatitude = Double(PickupLat) - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng) - Double(DropOffLon)!
        
        let waypointLatitude = self.defaultLocation.coordinate.latitude - dummyLatitude
        let waypointSetLongitude = self.defaultLocation.coordinate.longitude - dummyLongitude
        
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: Double(picklat)!, longitude: Double(picklng)!), coordinate: CLLocationCoordinate2D(latitude: Double(DropOffLat)!, longitude: Double(DropOffLon)!))
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(100))
        self.mapView.animate(with: update)
        self.mapView.moveCamera(update)
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
        NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
        
    }
    
    //MARK:- Show Driver Information
    
    func displayOnGoingRideDetails(bookingInfo : NSDictionary, driverInfo: NSDictionary, carInfo : NSDictionary, details : NSDictionary)
    {
        self.lblUserFromAddress.text = bookingInfo.object(forKey: "PickupLocation") as? String ?? ""
        self.lblUserToAddress.text = bookingInfo.object(forKey: "DropoffLocation") as? String ?? ""
        
        self.lblDriverName.text = driverInfo.object(forKey: "Fullname") as? String ?? ""
        //self.lblDriverRatings.text = driverInfo.object(forKey: "Fullname") as? String ?? ""
        
        if let driverImageName = driverInfo.object(forKey: "DriverLicense") as? String
        {
            self.btnDriverPhoto.sd_setImage(with: URL(string:  WebserviceURLs.kImageBaseURL + driverImageName), for: .normal, completed: nil)
        }
        
        if let vechicalImageName = carInfo.object(forKey: "VehicleImage") as? String
        {
            self.imageViewCarType.sd_setImage(with: URL(string:  WebserviceURLs.kImageBaseURL + vechicalImageName), completed: nil)
        }
        
        let vehicleNumber = carInfo.object(forKey: "VehicleRegistrationNo") as? String ?? ""
        let vehicleModel = (carInfo.object(forKey: "Model") as? NSDictionary)?.object(forKey: "Name") as? String ?? ""
        self.lblCarDescriptions.text = "\(vehicleNumber) - \(vehicleModel)"
        
        if let distance = details.object(forKey: "TripDistance") as? String{
            self.lblDistanceValue.text = "\(distance)"
        }
        
        if let time = details.object(forKey: "TripDuration") as? String{
            self.lblTimeValue.text = "\(time)"
        }
        
        if let price = details.object(forKey: "TripFare") as? String{
            self.lblPriceValue.text = "\(price)"
        }
    }
    
    func showDriverInfo(bookingInfo : NSDictionary, DriverInfo: NSDictionary, carInfo : NSDictionary)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DriverInfoViewController") as! DriverInfoViewController
        
        next.strDriverName = DriverInfo.object(forKey: "Fullname") as! String
        next.strPickupLocation = "\(bookingInfo.object(forKey: "PickupLocation") as! String)"
        next.strDropoffLocation = "\(bookingInfo.object(forKey: "DropoffLocation") as! String)"
        if let carClass = carInfo.object(forKey: "Model") as? NSDictionary {
            next.strCarClass = carClass.object(forKey: "Name") as! String // String(describing: carInfo.object(forKey: "VehicleModel")!)
        }
        else {
            next.strCarClass = String(describing: carInfo.object(forKey: "VehicleModel")!)
        }
        
        if let carPlateNumber = carInfo.object(forKey: "VehicleRegistrationNo") as? String {
            next.strCarPlateNumber = carPlateNumber
        }
        
        next.strCareName = "\(carInfo.object(forKey: "Company") as! String) - \(next.strCarClass) - \(next.strCarPlateNumber)"
        next.strDriverImage = WebserviceURLs.kImageBaseURL + (DriverInfo.object(forKey: "Image") as! String)
        next.strCarImage = WebserviceURLs.kImageBaseURL + (carInfo.object(forKey: "VehicleImage") as! String)
        
        //        if (SingletonClass.sharedInstance.passengerTypeOther) {
        //            next.strPassengerMobileNumber = bookingInfo.object(forKey: "PassengerContact") as! String
        //        }
        //        else {
        next.strPassengerMobileNumber = DriverInfo.object(forKey: "MobileNo") as! String
        //        }
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(next, animated: true, completion: nil)
    }
    
    func socketMethodForGettingBookingRejectNotification()
    {
        // Socket Accepted
        self.socket.on(SocketData.kRejectBookingRequestNotification, callback: { (data, ack) in
            print("socketMethodForGettingBookingRejectNotification() is \(data)")
            
            self.clearMap()
            self.lblCurrentLocationForDefaultView.text = ""
            self.lblUserToAddress.text = ""
            self.lblUserToAddress.text = ""
            self.clearDataAfteCompleteTrip()
            self.getPlaceFromLatLong()
            self.viewTripActions.isHidden = true
            self.viewCarLists.isHidden = false
            self.ConstantViewCarListsHeight.constant = 150
            self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0] as? [String:AnyObject]
            {
                if let bookingInfo = bookingInfoData["BookingId"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData["BookingId"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != ""
                {
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        self.viewActivity.stopAnimating()
                        self.viewMainActivityIndicator.isHidden = true
                        
                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String
                        {
                            if SelectedLanguage == "en"
                            {
                                UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                                })
                            }
                            else if SelectedLanguage == "sw"
                            {
                                UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                                    
                                })
                            }
                        }
                        
                    }
                }
                else
                {
                    self.viewActivity.stopAnimating()
                    self.viewMainActivityIndicator.isHidden = true
                    //                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                    //
                    //                    })
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                        if SelectedLanguage == "en" {
                            
                            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                                
                            })
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                                
                            })
                        }
                    }
                }
            }
            
            //            self.viewActivity.stopAnimating()
            //            self.viewMainActivityIndicator.isHidden = true
            //            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //            })
            
            /*
             [{
             BookingId = 7623;
             message = "Your Booking request has been canceled";
             type = BookingRequest;
             }]
             */
            
            
        })
    }
    
    func socketMethodForGettingBookingRejectNotificatioByDriver()
    {
        // Socket Accepted
        self.socket.on(SocketData.kCancelTripByDriverNotficication, callback: { (data, ack) in
            print("socketMethodForGettingBookingRejectNotificatioByDriver() is \(data)")
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        
                        self.viewActivity.stopAnimating()
                        self.viewMainActivityIndicator.isHidden = true
                        self.currentLocationAction()
                        self.getPlaceFromLatLong()
                        self.clearDataAfteCompleteTrip()
                        self.currentLocationAction()
                        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                        
                        self.viewTripActions.isHidden = true
                        SingletonClass.sharedInstance.passengerTypeOther = false
                        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                        //                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        //
                        //                        })
                        if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                            if SelectedLanguage == "en" {
                                
                                UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                                    
                                })
                            }
                            else if SelectedLanguage == "sw"
                            {
                                UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                                    
                                })
                            }
                        }
                        
                        
                    }
                } else {
                    self.viewActivity.stopAnimating()
                    self.viewMainActivityIndicator.isHidden = true
                    self.currentLocationAction()
                    self.getPlaceFromLatLong()
                    self.clearDataAfteCompleteTrip()
                    self.currentLocationAction()
                    self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                    
                    self.viewTripActions.isHidden = true
                    SingletonClass.sharedInstance.passengerTypeOther = false
                    self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                    //                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                    //
                    //                    })
                    
                    if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                        if SelectedLanguage == "en" {
                            
                            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                                
                            })
                        }
                        else if SelectedLanguage == "sw"
                        {
                            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                                
                            })
                        }
                    }
                    
                }
            }
        })
    }
    
    func socketMethodForGettingPickUpNotification()
    {
        self.socket.on(SocketData.kPickupPassengerNotification, callback: { (data, ack) in
            print("socketMethodForGettingPickUpNotification() is \(data)")
            //            self.stopTimer()
            /*
             [{
             BookingId = 7625;
             DriverId = 70;
             message = "Your trip has now started.";
             }]
             */
            
            //            let alert = UIAlertController(title: appName, message: "Your trip has now started.", preferredStyle: .alert)
            //            let OK = UIAlertAction(title: "OK", style: .default, handler: { ACTION in
            //            })
            //            alert.addAction(OK)
            //            //            self.present(alert, animated: true, completion: nil)
            //
            //            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            //            alertWindow.rootViewController = UIViewController()
            //            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            //            alertWindow.makeKeyAndVisible()
            //            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
            
            
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en" {
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
                        
                    })
                }
                else if SelectedLanguage == "sw"
                {
                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["swahili_message"]! as! String, completionHandler: { (index, title) in
                        
                    })
                }
            }
            
            self.btnCancelBooking.isHidden = true
            self.btnCancelBooking.heightAnchor.constraint(equalToConstant: 0).isActive = true
            self.btnCancelBooking.bottomAnchor.constraint(equalTo: self.viewTripActions.bottomAnchor, constant: 0).isActive = true
            
            self.methodAfterStartTrip(tripData: NSArray(array: data))
            
            //            var bookingIdIs = String()
            //
            //            if let bookingData = data as? [[String:AnyObject]] {
            //                if let id = bookingData[0]["BookingId"] as? String {
            //                    bookingIdIs = id
            //                }
            //                else if let id = bookingData[0]["BookingId"] as? Int {
            //                    bookingIdIs = "\(id)"
            //                }
            //
            //                if SingletonClass.sharedInstance.bookingId != "" {
            //                    if SingletonClass.sharedInstance.bookingId == bookingIdIs {
            //                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            //                        UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //                        })
            //
            //                        self.btnCancelBooking.isHidden = true
            //                        self.btnCancelStartedTrip.isHidden = true
            //
            //                        self.methodAfterStartTrip(tripData: NSArray(array: data))
            //                    }
            //                }
            //                else {
            //                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            //                    UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //                    })
            //
            //                    self.btnCancelBooking.isHidden = true
            //                    self.btnCancelStartedTrip.isHidden = true
            //
            //                    self.methodAfterStartTrip(tripData: NSArray(array: data))
            //                }
            //
            //            }
            
            
            //            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            //            UtilityClass.setCustomAlert(title: "\(appName)", message: (data as! [[String:AnyObject]])[0]["message"]! as! String, completionHandler: { (index, title) in
            //
            //            })
            //
            //            self.btnCancelBooking.isHidden = true
            //            self.btnCancelStartedTrip.isHidden = true
            //
            //            self.methodAfterStartTrip(tripData: NSArray(array: data))
            
        })
    }
    
    func socketMethodForGettingTripCompletedNotification()
    {
        self.socket.on(SocketData.kBookingCompletedNotification, callback: { (data, ack) in
            print("socketMethodForGettingTripCompletedNotification() is \(data)")
            
            SingletonClass.sharedInstance.isTripContinue = false
            self.aryCompleterTripData = data
            
            if (SingletonClass.sharedInstance.passengerTypeOther)
            {
                SingletonClass.sharedInstance.passengerTypeOther = false
                self.completeTripInfo()
            }
            else
            {
                self.completeTripInfo()
                //                self.performSegue(withIdentifier: "showRating", sender: nil)
            }
            
            //            if let getInfoFromData = data as? [[String:AnyObject]] {
            //
            //                if let infoData = getInfoFromData[0] as? [String:AnyObject] {
            //                    if let bookingInfo = infoData["Info"] as? [[String:AnyObject]] {
            //                        var bookingIdIs = String()
            //                        if let nowBookingID: Int = (bookingInfo[0])["Id"] as? Int {
            //                            bookingIdIs = "\(nowBookingID)"
            //                        }
            //                        else if let nowBookingID: String = (bookingInfo[0])["Id"] as? String {
            //                            bookingIdIs = nowBookingID
            //                        }
            //                        print("bookingIdIs: \(bookingIdIs)")
            //
            //                        if SingletonClass.sharedInstance.bookingId != "" {
            //                            if SingletonClass.sharedInstance.bookingId == bookingIdIs {
            //                                if (SingletonClass.sharedInstance.passengerTypeOther) {
            //
            //                                    SingletonClass.sharedInstance.passengerTypeOther = false
            //                                    self.completeTripInfo()
            //                                }
            //                                else {
            //                                    self.completeTripInfo()
            //                                    //                self.performSegue(withIdentifier: "showRating", sender: nil)
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            
            /*
             
             let bookingId = ((((data as! [[String:AnyObject]])[0] as! [String:AnyObject])["Info"] as! [[String:AnyObject]])[0] as! [String:AnyObject])["Id"]
             
             //            self.viewMainFinalRating.isHidden = false
             
             if (SingletonClass.sharedInstance.passengerTypeOther) {
             
             SingletonClass.sharedInstance.passengerTypeOther = false
             self.completeTripInfo()
             }
             else {
             
             self.completeTripInfo()
             //                self.performSegue(withIdentifier: "showRating", sender: nil)
             }
             
             //            let next = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
             //            next.strBookingType = self.strBookingType
             //            next.delegate = self
             //            next.modalPresentationStyle = .overCurrentContext
             //            self.present(next, animated: true, completion: nil)
             */
            
        })
    }
    
    func delegateforGivingRate()
    {
        let ratingVC = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
        ratingVC.delegateRating = self
        ratingVC.strBookingType = strBookingType
        
        //        ifself.strBookingType
        //        {
        //            ViewController?.strBookingType = "BookLater""
        //        }
        ratingVC.dictData = self.arrDataAfterCompletetionOfTrip[0] as? NSDictionary
        
        UIApplication.shared.windows.first?.rootViewController?.present(ratingVC, animated: true, completion: nil)
        
        
//        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//        alertWindow.rootViewController = UIViewController()
//        alertWindow.windowLevel = UIWindowLevelAlert + 1;
//        alertWindow.makeKeyAndVisible()
//        alertWindow.rootViewController?.present(ViewController!, animated: true, completion: nil)
        
        
        
        //        ViewController?.dictPassengerInfo = PassengerInfo
        //        Utilities.presentPopupOverScreen(ViewController!)
        //         self.resetMapView()
        /*
         let getBookingAndPassengerInfo = self.getBookingAndPassengerInfo(data: self.aryPassengerData)
         
         let PassengerInfo = getBookingAndPassengerInfo.1
         
         ViewController?.strBookingType = "BookNow"
         
         if(isAdvanceBooking)
         {
         ViewController?.strBookingType = "BookLater"
         }
         //
         
         self.lblCurrentLocationText.isHidden = false
         self.viewDropOffLocation.isHidden = true
         self.constrainPickupBottonLine.constant = 10
         self.iconLine.isHidden = true
         self.viewBTNStartTrip.isHidden = true
         print("Line Number :=== 424 //self.viewMyJobs.isHidden = false")
         self.viewMyJobs.isHidden = false
         self.viewCancelTripPassInfoDirection.isHidden = true
         self.viewCompleteTripDirection.isHidden = true
         self.btnClosePassangerInfo.isHidden = true
         self.viewProfile.isHidden = true
         self.constainViewProfileBottom.constant = 15
         self.view.layoutIfNeeded()
         
         */
        
    }
    
    func completeTripInfo() {
        
        clearMap()
        self.stopTimer()
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//        Utilities.hideActivityIndicator()
        self.scheduledTimerWithTimeInterval()
        
        let alert = UIAlertController(title: appName, message: "Your trip has been completed".localized, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
            
            DispatchQueue.main.async {
                
                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
                
                //self.dismiss(animated: true, completion: nil)
                //  self.socket.off(SocketData.kBookingCompletedNotification)
                
                self.arrDataAfterCompletetionOfTrip = NSMutableArray(array: (self.aryCompleterTripData[0] as! NSDictionary).object(forKey: "Info") as! NSArray)
                
                self.viewTripActions.isHidden = true
                self.viewCarLists.isHidden = false
                //                self.viewShareRideView.isHidden = false
                self.ConstantViewCarListsHeight.constant = 150
                //                    self.constraintTopSpaceViewDriverInfo.constant = 170
                self.viewMainFinalRating.isHidden = true
                SingletonClass.sharedInstance.passengerTypeOther = false
                self.viewCarLists.isHidden = true
                self.ConstantViewCarListsHeight.constant = 150
                self.currentLocationAction()
                self.getPlaceFromLatLong()
                self.getRaringNotification()
                self.clearDataAfteCompleteTrip()
               
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TripInfoViewController") as! TripInfoViewController
                viewController.dictData = self.arrDataAfterCompletetionOfTrip[0] as! NSDictionary
                viewController.delegate = self
                self.btnCurrentLocation(self.btnCurrentLocation)
                
//                DispatchQueue.main.async{
//                    self.btnCurrentLocation(self.btnCurrentLocation)
//                }
                
            UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
                
//                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//                alertWindow.rootViewController = UIViewController()
//                alertWindow.windowLevel = UIWindowLevelAlert + 1;
//                alertWindow.makeKeyAndVisible()
//                alertWindow.rootViewController?.present(viewController, animated: true, completion: nil)
//
                //            let next = self.storyboard?.instantiateViewController(withIdentifier: "TripInfoViewController") as! TripInfoViewController
                //            next.dictData = self.arrDataAfterCompletetionOfTrip[0] as! NSDictionary
                //            next.delegate = self
                //            DispatchQueue.main.async
                //                {
                //                    //                    self.btnCurrentLocation(self.btnCurrentLocationIcon)
                //                    self.btnCurrentLocation(self.btnCurrentLocation)
                //            }
                //            Utilities.presentPopupOverScreen(next)
                
            }
           
            
        })
        
        alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
//        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
//        alertWindow.rootViewController = UIViewController()
//        alertWindow.windowLevel = UIWindowLevelAlert + 1;
//        alertWindow.makeKeyAndVisible()
//        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        
//        UtilityClass.showAlertWithCompletion("Your trip has been completed", message: "", vc: self, completionHandler: { (status) in
//
//            if (status == true)
//            {
//
//
//
////                self.performSegue(withIdentifier: "seguePresentTripDetails", sender: nil)
//
////                let drinkViewController = segue.destination as! TripDetailsViewController
////                drinkViewController.arrData = arrDataAfterCompletetionOfTrip as NSMutableArray
////                drinkViewController.delegate = self
//
//
//
//
//
////                UIApplication.shared.keyWindow?.rootViewController?.present(viewController!, animated: true, completion: nil)
//
//                //                if (SingletonClass.sharedInstance.passengerTypeOther) {
//                //                }
//                //                else {
//                //
//                //                    self.openRatingView()
//                //                }
//
//
//            }
//            else
//            {
//                print("Else Part")
//            }
//        })
      
    }
    
    func clearSetupMapForNewBooking() {
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        clearMap()
        self.currentLocationAction()
        self.viewTripActions.isHidden = true
        //        self.viewCarLists.isHidden = false
        //        self.ConstantViewCarListsHeight.constant = 150
        clearDataAfteCompleteTrip()
    }
    
    func clearDataAfteCompleteTrip() {
        
        self.MarkerCurrntLocation.isHidden = false
        selectedIndexPath = nil
        self.collectionViewCars.reloadData()
        //self.txtCurrentLocation.text = ""
        //self.txtDestinationLocation.text = ""
        self.lblUserFromAddress.text = ""
        self.lblUserToAddress.text = ""
        self.dropoffLat = 0
        self.doublePickupLng = 0
        
        //        SingletonClass.sharedInstance.strPassengerID = ""
        
        self.strModelId = ""
        self.strPickupLocation = ""
        self.strDropoffLocation = ""
        self.doublePickupLat = 0
        self.doublePickupLng = 0
        self.doubleDropOffLat = 0
        self.doubleDropOffLng = 0
        self.strModelId = ""
        self.strCarModelIDIfZero = ""
        self.strCarModelID = ""
        self.txtNote.text = ""
        self.txtFeedbackFinal.text = ""
        self.txtHavePromocode.text = ""
//        self.txtSelectPaymentOption.text = ""
        SingletonClass.sharedInstance.isTripContinue = false
        
        
        
    }
    
    func getRaringNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.openRatingView), name: Notification.Name("CallToRating"), object: nil)
    }
    
    @objc func openRatingView() {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
        next.strBookingType = self.strBookingType
        //        next.delegate = self
        //            self.presentingViewController?.modalPresentationStyle
        self.present(next, animated: true, completion: nil)
    }
    
    func socketMethodForCancelRequestTrip()
    {
        
        let myJSON = [SocketDataKeys.kBookingIdNow : SingletonClass.sharedInstance.bookingId] as [String : Any]
        socket.emit(SocketData.kCancelTripByPassenger , with: [myJSON])
        stopTimer()
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        self.viewCarLists.isHidden = true
//        self.viewShareRideView.isHidden = true
        
    }
    // ------------------------------------------------------------
    
    func onAcceptBookLaterBookingRequestNotification() {
        
        self.socket.on(SocketData.kAcceptAdvancedBookingRequestNotification, callback: { (data, ack) in
            print("onAcceptBookLaterBookingRequestNotification() is \(data)")
            
            //            self.playSound(fileName: "RequestConfirm", extensionType: "mp3")
            
            //            UtilityClass.showAlertWithCompletion("", message: "Your request has been Accepted.", vc: self, completionHandler: { ACTION in
            //
            //                self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
            //            })
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request has been Accepted.") { (index, title) in
                            //               self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
                        }
                        self.strBookingType = "BookLater"
                        self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                    }
                }
                else {
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Your request has been Accepted.") { (index, title) in
                        //               self.stopSound(fileName: "RequestConfirm", extensionType: "mp3")
                    }
                    self.strBookingType = "BookLater"
                    self.DriverInfoAndSetToMap(driverData: NSArray(array: data))
                }
            }
        })
    }
    
    func onRejectBookLaterBookingRequestNotification() {
        
        self.socket.on(SocketData.kRejectAdvancedBookingRequestNotification, callback: { (data, ack) in
            print("onRejectBookLaterBookingRequestNotification() is \(data)")
            
            //            self.playSound(fileName: "PickNGo", extensionType: "mp3")
            
            let alert = UIAlertController(title: nil, message: "Your request has been rejected.".localized, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { (ACTION) in
                //                self.stopSound(fileName: "PickNGo", extensionType: "mp3")
            })
            alert.addAction(OK)
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        })
    }
    
    func onPickupPassengerByDriverInBookLaterRequestNotification() {
        
        self.socket.on(SocketData.kAdvancedBookingPickupPassengerNotification, callback: { (data, ack) in
            print("onPickupPassengerByDriverInBookLaterRequestNotification() is \(data)")
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        self.strBookingType = "BookLater"
                        let alert = UIAlertController(title: nil, message: "Your trip has now started.".localized, preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                        alert.addAction(OK)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                        
                        self.btnCancelBooking.isHidden = true
                        self.btnCancelBooking.heightAnchor.constraint(equalToConstant: 0).isActive = true
                        self.btnCancelBooking.bottomAnchor.constraint(equalTo: self.viewTripActions.bottomAnchor, constant: 0).isActive = true
                        //  SingletonClass.sharedInstance.isTripContinue = true
                        self.methodAfterStartTrip(tripData: NSArray(array: data))
                        
                    }
                }
                else {
                    self.strBookingType = "BookLater"
                    let alert = UIAlertController(title: nil, message: "Your trip has now started.".localized, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                    alert.addAction(OK)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    self.btnCancelBooking.isHidden = true
                    self.btnCancelBooking.heightAnchor.constraint(equalToConstant: 0).isActive = true
                    self.btnCancelBooking.bottomAnchor.constraint(equalTo: self.viewTripActions.bottomAnchor, constant: 0).isActive = true

                    // SingletonClass.sharedInstance.isTripContinue = true
                    self.methodAfterStartTrip(tripData: NSArray(array: data))
                }
            }
            
        })
    }
    
    func onTripHoldingNotificationForPassenger() {
        
        self.socket.on(SocketData.kReceiveHoldingNotificationToPassenger, callback: { (data, ack) in
            print("onTripHoldingNotificationForPassenger() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
//
            
            if let SelectedLanguage = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if SelectedLanguage == "en" {
                    
                    if let resAry = NSArray(array: data) as? NSArray {
                        message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                        //                UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    }
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                    
                    alert.addAction(OK)
                    
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)


                }
                else if SelectedLanguage == "sw"
                {
                    if let resAry = NSArray(array: data) as? NSArray {
                        message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "swahili_message") as! String
                        //                UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
                    }
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                    
                    alert.addAction(OK)
                    
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)


                }
            }
            
            
        })
    }
    
    func onTripHoldingNotificationForPassengerLater() {
        
        self.socket.on(SocketData.kAdvancedBookingTripHoldNotification, callback: { (data, ack) in
            print("onTripHoldingNotificationForPassengerLater() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
            if let resAry = NSArray(array: data) as? NSArray {
                message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                //                UtilityClass.showAlert("", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String, vc: self)
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
            
            alert.addAction(OK)
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            
        })
    }
    
    func onReceiveDriverLocationToPassenger() {
        
        self.socket.on(SocketData.kReceiveDriverLocationToPassenger, callback: { (data, ack) in
            print("onReceiveDriverLocationToPassenger() is \(data)")
            
            SingletonClass.sharedInstance.driverLocation = (data as NSArray).object(at: 0) as! [String : AnyObject]
            
            var DoubleLat = Double()
            var DoubleLng = Double()
            
            if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [Double] {
                DoubleLat = lat[0]
                DoubleLng = lat[1]
            }
            else if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [String] {
                DoubleLat = Double(lat[0])!
                DoubleLng = Double(lat[1])!
            }
            
            var DriverCordinate = CLLocationCoordinate2D(latitude: DoubleLat , longitude: DoubleLng)
            
            
            //            var DriverCordinate = CLLocationCoordinate2D(latitude: Double("23.076701577176262")! , longitude: Double("72.51612203357585")!)
            
            DriverCordinate = CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude)
            
            if(self.destinationCordinate == nil)
            {
                self.destinationCordinate = CLLocationCoordinate2DMake(DriverCordinate.latitude, DriverCordinate.longitude)
            }
            
            if self.driverMarker == nil {
                
                self.driverMarker = GMSMarker(position: DriverCordinate) // self.originCoordinate
                self.driverMarker.icon = UIImage(named: "dummyCar")
                self.driverMarker.map = self.mapView
            }
            //            self.moveMent.ARCarMovement(marker: self.driverMarker, oldCoordinate: self.destinationCordinate, newCoordinate: DriverCordinate, mapView: self.mapView, bearing: Float(SingletonClass.sharedInstance.floatBearing))
            else {
                self.driverMarker.icon = UIImage.init(named: "dummyCar")
            }
            let newCordinate = DriverCordinate
            
            self.driverMarker.position = DriverCordinate// = GMSMarker(position: DriverCordinate) // self.originCoordinate
            self.driverMarker.map = self.mapView

            self.driverMarker.icon = UIImage(named: "dummyCar")
            
            self.destinationCordinate = DriverCordinate
            self.MarkerCurrntLocation.isHidden = true
            // ----------------------------------------------------------------------
            
//            CATransaction.begin()
//            CATransaction.setAnimationDuration(0.5)
//            CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
//            CATransaction.setCompletionBlock({() -> Void in
//                self.driverMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
//                
//                //New bearing value from backend after car movement is done
//            })
//            
////             UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
////                self.driverMarker.position = newCordinate
////                self.driverMarker.map = self.mapView
////
//////                self.updatePolyLineToMapFromDriverLocation()
////             })
//            
//            CATransaction.commit()
            // ----------------------------------------------------------------------
            
            
        })
        
        
    }
    
    var driverIDTimer : String!
    var passengerIDTimer : String!
    func sendPassengerIDAndDriverIDToGetLocation(driverID : String , passengerID: String) {
        
        
        driverIDTimer = driverID
        passengerIDTimer = passengerID
        if timerToGetDriverLocation == nil {
            timerToGetDriverLocation = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.getDriverLocation), userInfo: nil, repeats: true)
        }
        
    }
    
    func stopTimer() {
        if timerToGetDriverLocation != nil {
            timerToGetDriverLocation.invalidate()
            timerToGetDriverLocation = nil
        }
    }
    
    @objc func getDriverLocation()
    {
        let myJSON = ["PassengerId" : passengerIDTimer,  "DriverId" : driverIDTimer] as [String : Any]
        socket.emit(SocketData.kSendDriverLocationRequestByPassenger , with: [myJSON])
    }
    
    
    func postPickupAndDropLocationForEstimateFare()
    {
        let driverID = aryOfOnlineCarsIds.compactMap{ $0 }.joined(separator: ",")
        
        var myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,  "PickupLocation" : strPickupLocation ,"PickupLat" :  self.doublePickupLat , "PickupLong" :  self.doublePickupLng, "DropoffLocation" : strDropoffLocation,"DropoffLat" : self.doubleDropOffLat, "DropoffLon" : self.doubleDropOffLng,"Ids" : driverID, "ShareRiding": intShareRide ] as [String : Any]
        
        if(strDropoffLocation.count == 0)
        {
            myJSON = ["PassengerId" : SingletonClass.sharedInstance.strPassengerID,  "PickupLocation" : strPickupLocation ,"PickupLat" :  self.doublePickupLat , "PickupLong" :  self.doublePickupLng, "DropoffLocation" : strPickupLocation,"DropoffLat" : self.doubleDropOffLng, "DropoffLon" : self.doubleDropOffLng,"Ids" : driverID, "ShareRiding": intShareRide] as [String : Any]
        }
        socket.emit(SocketData.kSendRequestForGetEstimateFare , with: [myJSON])
    }
    
    func onBookingDetailsAfterCompletedTrip() {
        
        self.socket.on(SocketData.kAdvancedBookingDetails, callback: { (data, ack) in
            print("onBookingDetailsAfterCompletedTrip() is \(data)")
            
            SingletonClass.sharedInstance.isTripContinue = false
            
            self.aryCompleterTripData = data
            
            //            self.viewMainFinalRating.isHidden = false
            
            var bookingId = String()
            if let bookingData = data as? [[String:AnyObject]] {
                
                if let info = bookingData[0]["Info"] as? [[String:AnyObject]] {
                    
                    if let infoId = info[0]["Id"] as? String {
                        bookingId = infoId
                    }
                    else if let infoId = info[0]["Id"] as? Int {
                        bookingId = "\(infoId)"
                    }
                    
                    if SingletonClass.sharedInstance.bookingId != "" {
                        if SingletonClass.sharedInstance.bookingId == bookingId {
                            
                            if (SingletonClass.sharedInstance.passengerTypeOther) {
                                
                                SingletonClass.sharedInstance.passengerTypeOther = false
                                self.completeTripInfo()
                            }
                            else {
                                self.completeTripInfo()
                                //                let next = self.storyboard?.instantiateViewController(withIdentifier: "GiveRatingViewController") as! GiveRatingViewController
                                //                next.strBookingType = self.strBookingType
                                //                next.delegate = self
                                //                //            self.presentingViewController?.modalPresentationStyle
                                //                self.present(next, animated: true, completion: nil)
                            }
                        }
                    }
                    
                }
                
            }
        })
    }
    
    func CancelBookLaterTripAfterDriverAcceptRequest() {
        
        let myJSON = [SocketDataKeys.kBookingIdNow : SingletonClass.sharedInstance.bookingId] as [String : Any]
        socket.emit(SocketData.kAdvancedBookingCancelTripByPassenger , with: [myJSON])
        
        self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
        
        clearDataAfteCompleteTrip()
        
    }
    
    func onAdvanceTripInfoBeforeStartTrip() {
        
        self.socket.on(SocketData.kInformPassengerForAdvancedTrip, callback: { (data, ack) in
            print("onAdvanceTripInfoBeforeStartTrip() is \(data)")
            
            var message = String()
            message = "Trip on Hold"
            
            if let resAry = NSArray(array: data) as? NSArray {
                message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                
            }
            
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
            
            alert.addAction(OK)
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        })
        
    }
    
    func onReceiveNotificationWhenDriverAcceptRequest() {
        
        self.socket.on(SocketData.kAcceptAdvancedBookingRequestNotify, callback: { (data, ack) in
            print("onReceiveNotificationWhenDriverAcceptRequest is \(data)")
            
            var bookingId = String()
            
            if let bookingInfoData = (data as! [[String:AnyObject]])[0]["BookingInfo"] as? [[String:AnyObject]] {
                if let bookingInfo = bookingInfoData[0]["Id"] as? Int {
                    bookingId = "\(bookingInfo)"
                }
                else if let bookingInfo = bookingInfoData[0]["Id"] as? String {
                    bookingId = bookingInfo
                }
                
                if SingletonClass.sharedInstance.bookingId != "" {
                    
                    if SingletonClass.sharedInstance.bookingId == bookingId {
                        var message = String()
                        message = "Trip on Hold"
                        
                        if let resAry = NSArray(array: data) as? NSArray {
                            message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                        }
                        
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                        alert.addAction(OK)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    var message = String()
                    message = "Trip on Hold"
                    
                    if let resAry = NSArray(array: data) as? NSArray {
                        message = (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String
                    }
                    
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                    alert.addAction(OK)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            
        })
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Auto Suggession on Google Map
    //-------------------------------------------------------------
    var BoolCurrentLocation = Bool()
    
    @IBAction func txtDestinationLocation(_ sender: UITextField) {
        self.openGMSLocationPicker(isCurrentLocation: false)
    }
    
    @IBAction func txtCurrentLocation(_ sender: UITextField) {
        self.openGMSLocationPicker(isCurrentLocation: true)
    }
    
    @IBAction func btnEnterDestinationLocation(_ sender: UIButton) {
        self.openGMSLocationPicker(isCurrentLocation: false)
    }
    
    func openGMSLocationPicker(isCurrentLocation : Bool) {
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.autocompleteBounds = bounds
        BoolCurrentLocation = isCurrentLocation
        present(acController, animated: true, completion: nil)
    }
    
    func setupBothCurrentAndDestinationMarkerAndPolylineOnMap() {
        
        if  lblUserFromAddress.text != "" && lblUserToAddress.text != "" {
            
            MarkerCurrntLocation.isHidden = true
            
            var PickupLat = doublePickupLat
            var PickupLng = doublePickupLng
            
            if(SingletonClass.sharedInstance.isTripContinue)
            {
                PickupLat = doubleUpdateNewLat
                PickupLng = doubleUpdateNewLng
            }
            
            let DropOffLat = doubleDropOffLat
            let DropOffLon = doubleDropOffLng
            
            let dummyLatitude = Double(PickupLat) - Double(DropOffLat)
            let dummyLongitude = Double(PickupLng) - Double(DropOffLon)
            
            let waypointLatitude = Double(PickupLat) - dummyLatitude
            let waypointSetLongitude = Double(PickupLng) - dummyLongitude
            
            let originalLoc: String = "\(PickupLat),\(PickupLng)"
            let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
            
            
            let bounds = GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: PickupLat, longitude: PickupLng), coordinate: CLLocationCoordinate2D(latitude: DropOffLat, longitude: DropOffLon))
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(100))
            
            self.mapView.animate(with: update)
            
            self.mapView.moveCamera(update)
            
            setDirectionLineOnMapForSourceAndDestinationShow(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
            
        }
    }
    
    @IBAction func btnClearPickupLocation(_ sender: UIButton) {
        //        txtCurrentLocation.text = ""
        clearMap()
        clearCurrentLocation()
    }
    
    @IBAction func btnClearDropOffLocation(_ sender: UIButton) {
        //        txtDestinationLocation.text = ""
        clearMap()
        clearDestinationLocation()
    }
    
    func clearCurrentLocation() {
        MarkerCurrntLocation.isHidden = false
        lblUserFromAddress.text = ""
        strPickupLocation = ""
        doublePickupLat = 0
        doublePickupLng = 0
        self.currentLocationMarker.map = nil
        self.destinationLocationMarker.map = nil
        self.strLocationType = self.currentLocationMarkerText
        self.routePolyline.map = nil
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
//        self.viewShareRideView.isHidden = true
    }
    
    func clearDestinationLocation() {
        MarkerCurrntLocation.isHidden = false
        lblUserToAddress.text = ""
        strDropoffLocation = ""
        doubleDropOffLat = 0
        doubleDropOffLng = 0
        self.destinationLocationMarker.map = nil
        self.currentLocationMarker.map = nil
        self.strLocationType = self.destinationLocationMarkerText
        self.routePolyline.map = nil
        
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        self.ConstantViewCarListsHeight.constant = 0
        self.viewCarLists.isHidden = true
        //        self.viewShareRideView.isHidden = true
    }
    
    //-------------------------------------------------------------
    // MARK: - Custom Methods
    //-------------------------------------------------------------
    
    
    let aryDummyLineData = [[23.073178, 72.514223], [23.073104, 72.514438], [23.073045, 72.514604], [23.073052, 72.514700], [23.072985, 72.514826],
                            [23.073000, 72.514885], [23.072985, 72.514944], [23.072931, 72.514949], [23.072896, 72.514960], [23.072875, 72.514959],
                            [23.072791, 72.514941], [23.072722, 72.514920], [23.072554, 72.514807], [23.072416, 72.514716], [23.071898, 72.514432],
                            [23.071641, 72.514282], [23.071365, 72.514110], [23.071329, 72.514090], [23.071299, 72.514085], [23.071262, 72.514176],
                            [23.071195, 72.514350], [23.071121, 72.514508]]
    
    var dummyOriginCordinate = CLLocationCoordinate2D()
    var dummyDestinationCordinate = CLLocationCoordinate2D()
    
    var dummyOriginCordinateMarker: GMSMarker!
    var dummyDestinationCordinateMarker: GMSMarker!
    
    func getDummyDataLinedata() {
        
        for index in 0..<aryDummyLineData.count {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.setDummyLine(index: index)
            }
        }
    }
    
    func setDummyLine(index: Int) {

        let dt = aryDummyLineData[index]
        
        let PickupLat = "\(dt[0])"
        let PickupLng = "\(dt[1])"
       
        let DropOffLat = "\(aryDummyLineData.last![0])"
        let DropOffLon = "\(aryDummyLineData.last![1])"
        
        
        let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)!
        let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
        
        let waypointLatitude = Double(PickupLat)! - dummyLatitude
        let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"

//        changePolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
        DispatchQueue.global(qos: .background).async {
            self.getDirectionsChangedPolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        }
    }
   
    func updatePolyLineToMapFromDriverLocation() {
        
        var DoubleLat = Double()
        var DoubleLng = Double()
        
        if !SingletonClass.sharedInstance.driverLocation.isEmpty {
        
            if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [Double] {
                DoubleLat = lat[0]
                DoubleLng = lat[1]
            }
            else if let lat = SingletonClass.sharedInstance.driverLocation["Location"]! as? [String] {
                DoubleLat = Double(lat[0])!
                DoubleLng = Double(lat[1])!
            }
        
//            DoubleLat = defaultLocation.coordinate.latitude
//            DoubleLng = defaultLocation.coordinate.longitude
        
            if strPickUpLatitude != "" {
        
                let PickupLat = "\(DoubleLat)" // strPickUpLatitude // "\(DoubleLat)" // "\(pickUpLat)"
                let PickupLng = "\(DoubleLng)" // strPickUpLongitude // "\(DoubleLng)"  // pickupLng
                
                //        let DropOffLat = driverInfo.object(forKey: "PickupLat") as! String
                //        let DropOffLon = driverInfo.object(forKey: "PickupLng") as! String
                
                let DropOffLat = strPickUpLatitude // "23.008183" // strPickUpLatitude // "\(DoubleLat)" // dropOffLat
                let DropOffLon = strPickUpLongitude // "72.513819" // strPickUpLongitude // "\(DoubleLng)" // dropOfLng
                
                let dummyLatitude = Double(PickupLat)! - Double(DropOffLat)! // 23.008183, 72.513819
                let dummyLongitude = Double(PickupLng)! - Double(DropOffLon)!
                
                let waypointLatitude = Double(PickupLat)! - dummyLatitude
                let waypointSetLongitude = Double(PickupLng)! - dummyLongitude
                
                let originalLoc: String = "\(PickupLat),\(PickupLng)"
                let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        
                DispatchQueue.global(qos: .background).async {
                    self.getDirectionsChangedPolyLine(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
                }

        
            }
        }
//
    }
    
    //-------------------------------------------------------------
    // MARK: - Map Draw Line
    //-------------------------------------------------------------
    
    func setLineData() {
        
        let singletonData = SingletonClass.sharedInstance.dictIsFromPrevious
        
        self.lblUserFromAddress.text = singletonData.object(forKey: "PickupLocation") as? String
        self.lblUserToAddress.text = singletonData.object(forKey: "DropoffLocation") as? String
        
        let DropOffLat = singletonData.object(forKey: "DropOffLat") as! Double
        let DropOffLon = singletonData.object(forKey: "DropOffLon") as! Double
        
        let PickupLat = singletonData.object(forKey: "PickupLat") as! Double
        let PickupLng = singletonData.object(forKey: "PickupLng")as! Double
        
        let dummyLatitude: Double = Double(PickupLat) - Double(DropOffLat)
        let dummyLongitude: Double = Double(PickupLng) - Double(DropOffLon)
        
        let waypointLatitude = PickupLat - dummyLatitude
        let waypointSetLongitude = PickupLng - dummyLongitude
        
        let originalLoc: String = "\(PickupLat),\(PickupLng)"
        let destiantionLoc: String = "\(DropOffLat),\(DropOffLon)"
        
        self.getDirectionsSeconMethod(origin: originalLoc, destination: destiantionLoc, waypoints: ["\(waypointLatitude),\(waypointSetLongitude)"], travelMode: nil, completionHandler: nil)
        
    }
    
    func clearMap() {
        
        self.mapView.clear()
        self.driverMarker = nil
        self.mapView.delegate = self
        
        self.destinationLocationMarker.map = nil
        
        //        self.mapView.stopRendering()
        //        self.mapView = nil
    }
    
    // ------------------------------------------------------------
    func getDirectionsSeconMethod(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        clearMap()
        MarkerCurrntLocation.isHidden = true
        UtilityClass.showACProgressHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
//                    if let routeWaypoints = waypoints {
//                        directionsURLString += "&waypoints=optimize:true"
//
//                        for waypoint in routeWaypoints {
//                            directionsURLString += "|" + waypoint
//                        }
//                    }
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    
                    // print("directionsURLString: \(directionsURLString)")
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                self.locationManager.startUpdatingLocation()
                                
                                let originAddress = legs[0]["start_address"] as! String
                                let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                //                                if(SingletonClass.sharedInstance.isTripContinue)
                                //                                {
                                if self.driverMarker == nil {
                                    
                                    self.driverMarker = GMSMarker(position: self.originCoordinate) // self.originCoordinate
                                    self.driverMarker.map = self.mapView
//                                    var vehicleID = Int()
//                                    //                                    var vehicleID = Int()
//                                    if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
//                                        
//                                        if vID == 0 {
//                                            vehicleID = 7
//                                        }
//                                        else {
//                                            vehicleID = vID
//                                        }
//                                    }
//                                    else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
//                                    {
//                                        
//                                        if sID == "" {
//                                            vehicleID = 7
//                                        }
//                                        else {
//                                            vehicleID = Int(sID)!
//                                        }
//                                    }
//                                    
                                    self.driverMarker.icon = UIImage(named: "dummyCar")
                                    
                                    self.driverMarker.title = originAddress
                                }
                                
                                let destinationMarker = GMSMarker(position: self.destinationCoordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                destinationMarker.map = self.mapView
                                destinationMarker.icon = UIImage.init(named: "iconMapPin")//GMSMarker.markerImage(with: UIColor.red)
                                destinationMarker.title = destinationAddress
                                
                                
                                var aryDistance = [String]()
                                var finalDistance = Double()
                                
                                
                                for i in 0..<legs.count
                                {
                                    let legsData = legs[i]
                                    let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                    let distance = distanceKey["text"] as! String
                                    //                                    print(distance)
                                    
                                    let stringDistance = distance.components(separatedBy: " ")
                                    //                                    print(stringDistance)
                                    
                                    if stringDistance[1] == "m"
                                    {
                                        finalDistance += Double(stringDistance[0])! / 1000
                                    }
                                    else
                                    {
                                        finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                    }
                                    
                                    aryDistance.append(distance)
                                }
                                
                                if finalDistance == 0
                                {
                                    
                                }
                                else
                                {
                                    self.sumOfFinalDistance = finalDistance
                                }
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                let routePolyline = GMSPolyline(path: path)
                                routePolyline.map = self.mapView
                                routePolyline.strokeColor = themeBlackColor
                                routePolyline.strokeWidth = 5.0
                                UtilityClass.hideACProgressHUD()
                                
                                //                                UtilityClass.showAlert("", message: "Line Drawn", vc: self)
                                
                              //  print("Line Drawn")
                                
                            }
                            else {
                                print("status")
                                
//                                self.getDirectionsSeconMethod(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                            }
                        }
                        catch
                        {
                            print("catch")
                            UtilityClass.hideACProgressHUD()
                            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                            }
                            // completionHandler(status: "", success: false)
                        }
                    })
                }
                else
                {
                    print("Destination is nil.")
                    UtilityClass.hideACProgressHUD()
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Destination, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print("Origin is nil")
                UtilityClass.hideACProgressHUD()
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Origin, please restart app") { (index, title) in
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
        }
    }
    
    var demoPolyline = GMSPolyline()
//    var demoPolylineOLD = GMSPolyline()
    
    func getDirectionsChangedPolyLine(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
//        clearMap()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
//                    if let routeWaypoints = waypoints {
//                        directionsURLString += "&waypoints=optimize:true"
//
//                        for waypoint in routeWaypoints {
//                            directionsURLString += "|" + waypoint
//                        }
//                    }
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            if status == "OK" {
                                
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                self.locationManager.startUpdatingLocation()
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                
                                
                                
//                                self.dummyOriginCordinateMarker = self.dummyDestinationCordinateMarker
//
//                                self.dummyDestinationCordinateMarker = nil
                                
//                                if self.dummyDestinationCordinateMarker == nil {
//                                    self.dummyDestinationCordinateMarker = GMSMarker(position: self.originCoordinate)
//                                }
//
//                                self.dummyDestinationCordinateMarker.map = self.mapView
//                                self.dummyDestinationCordinateMarker.icon = GMSMarker.markerImage(with: UIColor.green)
//                                self.dummyOriginCordinateMarker = self.dummyDestinationCordinateMarker
//
//                                self.dummyDestinationCordinateMarker.map = nil
//                                self.dummyDestinationCordinateMarker.map = self.mapView
////
//
//
//                                UIView.animate(withDuration: 5, delay: 0, options: .curveLinear, animations: {
//
//                                    if self.dummyOriginCordinateMarker == nil {
//                                        self.dummyOriginCordinateMarker = GMSMarker(position: self.originCoordinate)
//                                        self.dummyOriginCordinateMarker.map = self.mapView
//                                        self.dummyOriginCordinateMarker.icon = GMSMarker.markerImage(with: UIColor.green)
////                                        self.dummyDestinationCordinateMarker = self.dummyOriginCordinateMarker
////
////                                    self.dummyOriginCordinateMarker.map = nil
////                                    self.dummyOriginCordinateMarker.map = self.mapView
//
//                                    }
//                                }, completion: nil)
//
//
                                
//                                    self.demoPolylineOLD = self.demoPolyline
//                                    self.demoPolylineOLD.strokeColor = themeYellowColor
//                                    self.demoPolylineOLD.strokeWidth = 3.0
//                                    self.demoPolylineOLD.map = self.mapView
//                                    self.demoPolyline.map = nil
//
//
//                                self.demoPolyline = GMSPolyline(path: path)
//                                self.demoPolyline.map = self.mapView
//                                self.demoPolyline.strokeColor = themeYellowColor
//                                self.demoPolyline.strokeWidth = 3.0
//                                self.demoPolylineOLD.map = nil
                                
//                                if self.driverMarker == nil {
//
//                                    self.driverMarker = GMSMarker(position: self.defaultLocation.coordinate) // self.originCoordinate
//                                    self.driverMarker.map = self.mapView
//                                    self.driverMarker.icon = UIImage(named: "dummyCar")
//
//                                }
                                
                                DispatchQueue.main.async {
                                    
                                    self.demoPolylineOLD = self.demoPolyline
                                    self.demoPolylineOLD.strokeColor = themeYellowColor
                                    self.demoPolylineOLD.strokeWidth = 3.0
                                    self.demoPolylineOLD.map = self.mapView
                                    self.demoPolyline.map = nil
                                    
                                    self.demoPolyline = GMSPolyline(path: path)
                                    self.demoPolyline.map = self.mapView
                                    self.demoPolyline.strokeColor = themeYellowColor
                                    self.demoPolyline.strokeWidth = 3.0
                                    self.demoPolylineOLD.map = nil
                                    
                                }
                                
                                
                                
//                                if GMSGeometryIsLocationOnPath(self.destinationCoordinate, path, true) {
//                                    print("GMSGeometryIsLocationOnPath")
//                                } else {
//                                    print("Else")
//                                }
                                
                              
//                                UIView.animate(withDuration: 3.0, delay: 0, options: .curveLinear, animations: {
//                                    self.demoPolyline = GMSPolyline(path: path)
//                                    self.demoPolyline.map = self.mapView
//                                    self.demoPolyline.strokeColor = themeYellowColor
//                                    self.demoPolyline.strokeWidth = 3.0
//                                    self.demoPolylineOLD.map = nil
//                                }, completion: { (status) in
//
//                                })
                                
                                    
                                    print("Line Drawn")
                                
                                
                                UtilityClass.hideACProgressHUD()
                            } else {
                                UtilityClass.hideACProgressHUD()
//                                self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                            }
                        } catch {
                            UtilityClass.hideACProgressHUD()
//                            self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                        }
                    })
                } else {
                    UtilityClass.hideACProgressHUD()
//                    self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
                }
            } else {
                UtilityClass.hideACProgressHUD()
//                self.getDirectionsChangedPolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: travelMode, completionHandler: completionHandler)
            }
        }
    }
    
    func changePolyLine(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
//                if let routeWaypoints = waypoints {
//                    directionsURLString += "&waypoints=optimize:true"
//
//                    for waypoint in routeWaypoints {
//                        directionsURLString += "|" + waypoint
//                    }
//                }
//
                directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let directionsURL = NSURL(string: directionsURLString)
                DispatchQueue.main.async( execute: { () -> Void in
                    let directionsData = NSData(contentsOf: directionsURL! as URL)
                    do{
                        let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                        
                        let status = dictionary["status"] as! String
                        
                        if status == "OK" {
                          
                            self.locationManager.startUpdatingLocation()
                            
                            self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                            self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                            
                            let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                            
                            let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                            self.dummyOriginCordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                            self.dummyDestinationCordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                            
                            self.locationManager.startUpdatingLocation()
                            
                             if self.dummyOriginCordinateMarker == nil {
                                self.dummyOriginCordinateMarker = GMSMarker(position: self.dummyOriginCordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                self.dummyOriginCordinateMarker.map = self.mapView
                                self.dummyOriginCordinateMarker.icon = UIImage.init(named: "iconMapPin")//GMSMarker.markerImage(with: UIColor.green)
                                //                            destinationMarker.title = destinationAddres
                                
//                                let route = self.overviewPolyline["points"] as! String
//                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
//                                self.routePolyline = GMSPolyline(path: path)
//                                self.routePolyline.map = self.mapView
//                                self.routePolyline.strokeColor = UIColor.blue // themeYellowColor
//                                self.routePolyline.strokeWidth = 3.0
//                                self.demoPolylineOLD.map = nil
                            }
                            
                            if self.dummyDestinationCordinateMarker == nil {
                                self.dummyDestinationCordinateMarker = GMSMarker(position: self.dummyDestinationCordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                self.dummyDestinationCordinateMarker.map = self.mapView
                                self.dummyDestinationCordinateMarker.icon = UIImage.init(named: "iconMapPin")//GMSMarker.markerImage(with: UIColor.blue)
                            }
                          
//                            if self.routePolyline.map == nil {
//                                self.demoPolylineOLD = self.routePolyline
//                                self.demoPolylineOLD.map = self.mapView
//                                self.demoPolylineOLD.strokeColor = themeYellowColor
//                                self.demoPolylineOLD.strokeWidth = 5.0
//                               self.routePolyline.map = nil

                            
 
//                                let route = self.overviewPolyline["points"] as! String
//                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
//                                self.routePolyline = GMSPolyline(path: path)
//                                self.routePolyline.map = self.mapView
//                                self.routePolyline.strokeColor = UIColor.blue // themeYellowColor
//                                self.routePolyline.strokeWidth = 3.0
//                                self.demoPolylineOLD.map = nil


                            // ----------------------------------------------------------------------
//                            self.demoPolylineOLD = self.routePolyline
//                            self.demoPolylineOLD.map = self.mapView
//
//                            self.demoPolylineOLD.strokeColor = UIColor.green
//                            self.demoPolylineOLD.strokeWidth = 3.0
//                            self.routePolyline.map = nil
                            
                            let route = self.overviewPolyline["points"] as! String
                            let path: GMSPath = GMSPath(fromEncodedPath: route)!
                            
                            self.routePolyline = GMSPolyline(path: path)
                            self.routePolyline.map = self.mapView
                            self.routePolyline.strokeColor = UIColor.blue
                            self.routePolyline.strokeWidth = 3.0
                            self.demoPolylineOLD.map = nil
                            // ----------------------------------------------------------------------
                            
                            
                            print("Line Drawn")
                            
                        }
                        else {
                            print("status")
                            
//                            self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                            print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                        }
                    }
                    catch {
                        print("catch")
                        
                        
                        UtilityClass.hideACProgressHUD()
                        
                        UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
//                            self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                        }
                        // completionHandler(status: "", success: false)
                    }
                })
            }
            else {
                print("Destination is nil.")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Destination, please restart app") { (index, title) in
//                    self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                }
                //completionHandler(status: "Destination is nil.", success: false)
            }
        }
        else {
            print("Origin is nil")
            
            UtilityClass.hideACProgressHUD()
            
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location Origin, please restart app") { (index, title) in
//                self.changePolyLine(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
            }
            //completionHandler(status: "Origin is nil", success: false)
        }
    }
    
    func getDirectionsAcceptRequest(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        
        clearMap()
        MarkerCurrntLocation.isHidden = true
        UtilityClass.showACProgressHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
//                    if let routeWaypoints = waypoints {
//                        directionsURLString += "&waypoints=optimize:true"
//
//                        for waypoint in routeWaypoints {
//                            directionsURLString += "|" + waypoint
//                        }
//                    }
                    
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    
                    
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    print("directionsURLString: \(directionsURLString)")
                    // .addingPercentEscapes(using: String.Encoding.utf8)!
                    let directionsURL = NSURL(string: directionsURLString)
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                                
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                self.locationManager.startUpdatingLocation()
                                
                                let originAddress = legs[0]["start_address"] as! String
                                let destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                if(SingletonClass.sharedInstance.isTripContinue)
                                {
                                    if self.driverMarker == nil {
                                        
                                        self.driverMarker = GMSMarker(position: self.destinationCoordinate) // self.originCoordinate
                                        self.driverMarker.map = self.mapView
//                                        var vehicleID = Int()
//                                        //                                    var vehicleID = Int()
//                                        if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
//
//                                            if vID == 0 {
//                                                vehicleID = 7
//                                            }
//                                            else {
//                                                vehicleID = vID
//                                            }
//                                        }
//                                        else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
//                                        {
//
//                                            if sID == "" {
//                                                vehicleID = 7
//                                            }
//                                            else {
//                                                vehicleID = Int(sID)!
//                                            }
//                                        }
//
                                        self.driverMarker.icon = UIImage(named: "dummyCar")
                                        
                                        self.driverMarker.title = originAddress
                                    }
                                    
                                }
                                
                                let destinationMarker = GMSMarker(position: self.originCoordinate)// self.destinationCoordinate  // self.destinationCoordinate
                                destinationMarker.map = self.mapView
                                destinationMarker.icon = UIImage.init(named: "iconMapPin")//GMSMarker.markerImage(with: UIColor.red)
                                destinationMarker.title = destinationAddress
                                
                                
                                var aryDistance = [String]()
                                var finalDistance = Double()
                                
                                
                                for i in 0..<legs.count
                                {
                                    let legsData = legs[i]
                                    let distanceKey = legsData["distance"] as! Dictionary<String, AnyObject>
                                    let distance = distanceKey["text"] as! String
                                    //                                    print(distance)
                                    
                                    let stringDistance = distance.components(separatedBy: " ")
                                    //                                    print(stringDistance)
                                    
                                    if stringDistance[1] == "m"
                                    {
                                        finalDistance += Double(stringDistance[0])! / 1000
                                    }
                                    else
                                    {
                                        finalDistance += Double(stringDistance[0].replacingOccurrences(of: ",", with: ""))!
                                    }
                                    
                                    aryDistance.append(distance)
                                }
                                
                                if finalDistance == 0 {
                                }
                                else {
                                    self.sumOfFinalDistance = finalDistance
                                }
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                let routePolyline = GMSPolyline(path: path)
                                routePolyline.map = self.mapView
                                routePolyline.strokeColor = themeBlackColor
                                routePolyline.strokeWidth = 5.0
                                UtilityClass.hideACProgressHUD()
                                print("Line Drawn")
                                
                            }
                            else {
                                print("status")
                                
//                                self.getDirectionsAcceptRequest(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                            }
                        }
                        catch
                        {
                            print("catch")
                            UtilityClass.hideACProgressHUD()
                            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                            }
                            // completionHandler(status: "", success: false)
                        }
                    })
                }
                else {
                    print("Destination is nil.")
                    
                    UtilityClass.hideACProgressHUD()
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get Destination location, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else
            {
                print("Origin is nil")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get  Origin location, please restart app") { (index, title) in
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
        }
    }
    
    func setDirectionLineOnMapForSourceAndDestinationShow(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status:   String, _ success: Bool) -> Void)?)
    {
        //        clearMap()
        //        UtilityClass.showACProgressHUD()
        //
        //        self.routePolyline.map = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            if let originLocation = origin {
                if let destinationLocation = destination {
                    var directionsURLString = self.baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation + "&key=" + googlApiKey
//                    if let routeWaypoints = waypoints {
//                        directionsURLString += "&waypoints=optimize:true"
//
//                        for waypoint in routeWaypoints {
//                            directionsURLString += "|" + waypoint
//                        }
//                    }
                    
                    directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    
                    let directionsURL = NSURL(string: directionsURLString)
                    
                    print ("directionsURLString: \(directionsURLString)")
                    DispatchQueue.main.async( execute: { () -> Void in
                        let directionsData = NSData(contentsOf: directionsURL! as URL)
                        do{
                            let dictionary: Dictionary<String, AnyObject> = try JSONSerialization.jsonObject(with: directionsData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                            
                            let status = dictionary["status"] as! String
                            
                            if status == "OK" {
                                self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                                self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, AnyObject>
                                
                                let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                                let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                                self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                
                                let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                                self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                
                                self.locationManager.startUpdatingLocation()
                                
                                //                                if SingletonClass.sharedInstance.isTripContinue {
                                
                                
                                // Set currentLocationMarker
                                self.currentLocationMarker = GMSMarker(position: self.originCoordinate) // destinationCoordinate
                                self.currentLocationMarker.map = self.mapView
                                self.currentLocationMarker.snippet = self.currentLocationMarkerText
                                self.currentLocationMarker.icon = UIImage(named: "iconMapPin")
                                //                                self.currentLocationMarker.isDraggable = true
                                
                                // Set destinationLocationMarker
                                self.destinationLocationMarker = GMSMarker(position: self.destinationCoordinate) // originCoordinate
                                self.destinationLocationMarker.map = self.mapView
                                self.destinationLocationMarker.snippet = self.destinationLocationMarkerText
                                self.destinationLocationMarker.icon = UIImage(named: "iconMapPin")
                                
                                //                                     }
                                
                                let route = self.overviewPolyline["points"] as! String
                                let path: GMSPath = GMSPath(fromEncodedPath: route)!
                                self.routePolyline = GMSPolyline(path: path)
                                self.routePolyline.map = self.mapView
                                self.routePolyline.strokeColor = themeBlackColor
                                self.routePolyline.strokeWidth = 5.0
                                
                                
                                UtilityClass.hideACProgressHUD()
                                
                                print("Line Drawn")
                                
                            }
                            else {
                                print("status")
                                //completionHandler(status: status, success: false)
                                
//                                self.setDirectionLineOnMapForSourceAndDestinationShow(origin: origin, destination: destination, waypoints: waypoints, travelMode: nil, completionHandler: nil)
                                print("OVER_QUERY_LIMIT Line number : \(#line) function name : \(#function)")
                            }
                        }
                        catch {
                            print("catch")
                            
                            
                            UtilityClass.hideACProgressHUD()
                            
                            UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get location data, please restart app") { (index, title) in
                            }
                            // completionHandler(status: "", success: false)
                        }
                    })
                }
                else {
                    print("Destination is nil.")
                    
                    UtilityClass.hideACProgressHUD()
                    
                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get Destination location, please restart app") { (index, title) in
                    }
                    //completionHandler(status: "Destination is nil.", success: false)
                }
            }
            else {
                print("Origin is nil")
                
                UtilityClass.hideACProgressHUD()
                
                UtilityClass.setCustomAlert(title: "\(appName)", message: "Not able to get  Origin location, please restart app") { (index, title) in
                }
                //completionHandler(status: "Origin is nil", success: false)
            }
        }
    }
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Current Booking Methods
    //-------------------------------------------------------------
    
    var dictCurrentBookingInfoData = NSDictionary()
    var dictCurrentDriverInfoData = NSDictionary()
    var aryCurrentBookingData = NSMutableArray()
    var checkBookingType = String()
    
    var bookingIDNow = String()
    var advanceBookingID = String()
    var passengerId = String()
    
    var strBookingType = String()
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods Running TripTrack
    //-------------------------------------------------------------
    
    @objc func webserviceOfRunningTripTrack() {
        
        
        webserviceForTrackRunningTrip(SingletonClass.sharedInstance.bookingId as AnyObject) { (result, status) in
            
            if (status) {
                // print(result)
                
                self.clearMap()
                
                let resultData = (result as! NSDictionary)
                
                //                SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as! String
                //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                self.aryCurrentBookingData.removeAllObjects()
                self.aryCurrentBookingData.add(resultData)
                self.aryRequestAcceptedData = self.aryCurrentBookingData
                
                let bookingType = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                if bookingType != "" {
                    
                    self.MarkerCurrntLocation.isHidden = true
                    
                    if bookingType == "BookNow" {
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                        
                    }
                    else if bookingType == "BookLater" {
                        
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted" {
                            
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling" {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let OK = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
                alert.addAction(OK)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    // ----------------------------------------------------------------------
    
    // ----------------------------------------------------------------------
    // Book Now Accept Request
    // ----------------------------------------------------------------------
    func bookingTypeIsBookNowAndAccepted() {
        
        if let vehicleModelId = (((aryCurrentBookingData.object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSArray)?.object(at: 0) as? NSDictionary)?.object(forKey: "VehicleModel") as? String {
            
            for i in 0..<self.arrTotalNumberOfCars.count {
                let indexOfCar = self.arrTotalNumberOfCars.object(at: i) as! NSDictionary
                if vehicleModelId == indexOfCar.object(forKey: "Id") as! String {
                    strSelectedCarMarkerIcon = "dummyCar"//markertIconName(carType: indexOfCar.object(forKey: "Name") as! String)
                }
            }
        }
        
        //        SingletonClass.sharedInstance.isTripContinue = true
        self.DriverInfoAndSetToMap(driverData: NSArray(array: aryCurrentBookingData))
        
    }
    
    func bookingTypeIsBookNowAndTraveling() {
        
        //        clearMap()
        
        if let vehicleModelId = (((aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "CarInfo") as! NSArray).object(at: 0) as! NSDictionary).object(forKey: "VehicleModel") as? String {
            
            for i in 0..<self.arrTotalNumberOfCars.count {
                
                let indexOfCar = self.arrTotalNumberOfCars.object(at: i) as! NSDictionary
                if vehicleModelId == indexOfCar.object(forKey: "Id") as! String {
                    strSelectedCarMarkerIcon = "dummyCar"//markertIconName(carType: indexOfCar.object(forKey: "Name") as! String)
                }
            }
        }
        
        self.methodAfterStartTrip(tripData: NSArray(array: aryCurrentBookingData))
    }
    
    func markertIconName(carType: String) -> String {
        
        switch carType {
//        case "First Class":
//            return "iconFirstClass"
//        case "Business Class":
//            return "iconBusinessClass"
//        case "Economy":
//            return "iconEconomy"
//        case "Taxi":
//            return "iconTaxi"
            
//        case "LUX-VAN":
//            return "iconLuxVan"
//        case "Disability":
//            return "iconDisability"
        default:
            return "dummyCar"
        }
        
    }
    
    //    func markerCarIconName(modelId: Int) -> String {
    //
    //        var CarModel = String()
    //
    //        switch modelId {
    //        case 1:
    //            CarModel = "imgBusinessClass"
    //            return CarModel
    //        case 2:
    //            CarModel = "imgMIni"
    //            return CarModel
    //        case 3:
    //            CarModel = "imgVan"
    //            return CarModel
    //        case 4:
    //            CarModel = "imgNano"
    //            return CarModel
    //        case 5:
    //            CarModel = "imgTukTuk"
    //            return CarModel
    //        case 6:
    //            CarModel = "imgBreakdown"
    //            return CarModel
    //        default:
    //            CarModel = "dummyCar"
    //            return CarModel
    //        }
    //
    //    }
    
    func markerCarIconName(modelId: Int) -> String {
        
        var CarModel = String()
        
        switch modelId {
        case 1:
            CarModel = "imgBusinessClass"
            return CarModel
        case 2:
            CarModel = "imgMIni"
            return CarModel
        case 3:
            CarModel = "imgVan"
            return CarModel
        case 4:
            CarModel = "imgNano"
            return CarModel
        case 5:
            CarModel = "imgTukTuk"
            return CarModel
        case 6:
            CarModel = "imgBreakdown"
            return CarModel
        default:
            CarModel = "imgTaxi"
            return CarModel
        }
        
    }
    
    func sortCarListFirstTime() {
        
        let sortedArray = (aryTempOnlineCars as NSArray).sortedArray(using: [NSSortDescriptor(key: "Sort", ascending: true)]) as! [[String:AnyObject]]
        arrNumberOfOnlineCars = NSMutableArray(array: sortedArray)
        self.collectionViewCars.reloadData()
    }
    
    //-------------------------------------------------------------
    // MARK: - ARCar Movement Delegate Method
    //-------------------------------------------------------------
    func ARCarMovementMoved(_ Marker: GMSMarker) {
        driverMarker = Marker
        driverMarker.map = mapView
    }
    var destinationCordinate: CLLocationCoordinate2D!
    
}

//MARK:- CollectionView Delegate and Datasource methods
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        if self.arrNumberOfOnlineCars.count == 0 {
//            return 5
      //  }
        return self.arrNumberOfOnlineCars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! AvailablesCarsListCollectionViewCell
        
        if selectedIndexPath == indexPath
        {
            cell.containerView.backgroundColor = themeYellowColor
        }
        else
        {
            cell.containerView.backgroundColor = themeGrayBGColor
        }
        
        if let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as? [String : AnyObject])
        {
            
            cell.lblCategoryType.text = dictOnlineCarData["Name"] as? String ?? ""
            let price = dictOnlineCarData["estimate_fare_range"] as? String ?? ""
            let time = dictOnlineCarData["duration"]  as? String ?? ""
            cell.lblRate.text = "\(currencySign)\(price)/\(time)"
            
            if let imageURL = dictOnlineCarData["Image"] as? String
            {
                cell.imageViewCar.sd_setIndicatorStyle(.gray)
                cell.imageViewCar.sd_setShowActivityIndicatorView(true)
                
                cell.imageViewCar.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
                    cell.imageViewCar.sd_setShowActivityIndicatorView(false)
                })
            }else
            {
               cell.imageViewCar = nil
            }
            

        }
        
        

//        else if (self.arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
//        {
//            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! [String : AnyObject])
//            let imageURL = dictOnlineCarData["Image"] as! String
//
//            cell.imgCars.sd_setIndicatorStyle(.gray)
//            cell.imgCars.sd_setShowActivityIndicatorView(true)
//
//            cell.imgCars.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
//                cell.imgCars.sd_setShowActivityIndicatorView(false)
//            })
//
//            cell.lblMinutes.text = "0 min"
//            cell.lblCarType.text = dictOnlineCarData["Name"] as? String
//
//            if self.aryEstimateFareData.count != 0 {
//
//                var EstimateFare:String = ""
//
//                cell.lblPrices.text = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "estimate_fare_range") as? String
//
//                let minute = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "duration") as! Int
//                cell.lblMinutes.text = "\(minute) min"
//                //                    }
//
//                let strAvilCAR = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "available_driver") as! Int
//                cell.lblAvailableCars.text = "Avail \(strAvilCAR)"
//            }
//
//        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        MarkerCurrntLocation.isHidden = true
        
        if (arrNumberOfOnlineCars.count != 0 && indexPath.row < self.arrNumberOfOnlineCars.count)
        {
            
            let dictOnlineCarData = (arrNumberOfOnlineCars.object(at: indexPath.row) as! NSDictionary)
            strSpecialRequestFareCharge = dictOnlineCarData.object(forKey: "SpecialExtraCharge") as? String ?? ""
          
            if dictOnlineCarData.object(forKey: "carCount") as! Int != 0
            {
                self.markerOnlineCars.map = nil
                self.strSelectedCarTotalFare = "\((self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "total") as! Int)"
                for i in 0..<self.aryMarkerOnlineCars.count {
                    
                    self.aryMarkerOnlineCars[i].map = nil
                }
                
                self.aryMarkerOnlineCars.removeAll()
                
                let available = dictOnlineCarData.object(forKey: "carCount") as! Int
                let checkAvailabla = String(available)
                
                
                var lati = dictOnlineCarData.object(forKey: "Lat") as! Double
                var longi = dictOnlineCarData.object(forKey: "Lng") as! Double
                
                
                let locationsArray = (dictOnlineCarData.object(forKey: "locations") as! [[String:AnyObject]])
                
                for i in 0..<locationsArray.count
                {
                    if( (locationsArray[i]["CarType"] as! String) == (dictOnlineCarData.object(forKey: "Id") as! String))
                    {
                        lati = (locationsArray[i]["Location"] as! [AnyObject])[0] as! Double
                        longi = (locationsArray[i]["Location"] as! [AnyObject])[1] as! Double
                        let position = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                        self.markerOnlineCars = GMSMarker(position: position)
                        //                        self.markerOnlineCars.tracksViewChanges = false
                        //                        self.strSelectedCarMarkerIcon = self.markertIcon(index: indexPath.row)
                        self.strSelectedCarMarkerIcon = "dummyCar"//self.setCarImage(modelId: dictOnlineCarData.object(forKey: "Id") as! String)
                        //                        self.markerOnlineCars.icon = UIImage(named: self.markertIcon(index: indexPath.row)) // iconCurrentLocation
                        
                        self.aryMarkerOnlineCars.append(self.markerOnlineCars)
                        
                        //                        self.markerOnlineCars.map = nil
                        //                    self.markerOnlineCars.map = self.mapView
                        
                    }
                }
                
                // Show Nearest Driver from Passenger
                if self.aryMarkerOnlineCars.count != 0 {
                    if self.aryMarkerOnlineCars.first != nil {
                        if let nearestDriver = self.aryMarkerOnlineCars.first {
                            
                            let camera = GMSCameraPosition.camera(withLatitude: nearestDriver.position.latitude, longitude: nearestDriver.position.longitude, zoom: 17)
                            self.mapView.camera = camera
                        }
                    }
                }
                
                for i in 0..<self.aryMarkerOnlineCars.count {
                    
                    self.aryMarkerOnlineCars[i].position = self.aryMarkerOnlineCars[i].position
                    self.aryMarkerOnlineCars[i].icon = UIImage(named: self.setCarImage(modelId: dictOnlineCarData.object(forKey: "Id") as! String))
                    self.aryMarkerOnlineCars[i].map = self.mapView
                }
                
                let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                let carModelIDConverString: String = carModelID!
                
                let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                
                strCarModelClass = strCarName
                strCarModelID = carModelIDConverString
                
                selectedIndexPath = indexPath
                
               // let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
               // cell.viewOfImage.layer.borderColor = themeYellowColor.cgColor
                
                let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
                strNavigateCarModel = imageURL
                strCarModelIDIfZero = ""
                if checkAvailabla != "0" {
                    strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                }
                else {
                    strModelId = "0"
                }
            }
            else
            {
                for i in 0..<self.aryMarkerOnlineCars.count {
                    self.aryMarkerOnlineCars[i].map = nil
                }
                
                self.aryMarkerOnlineCars.removeAll()
                
                let carModelID = dictOnlineCarData.object(forKey: "Id") as? String
                let carModelIDConverString: String = carModelID!
                
                let strCarName: String = dictOnlineCarData.object(forKey: "Name") as! String
                
                strCarModelClass = strCarName
                strCarModelID = carModelIDConverString
                
                //let cell = collectionView.cellForItem(at: indexPath) as! CarsCollectionViewCell
                //cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
                
                selectedIndexPath = nil
                
                let imageURL = dictOnlineCarData.object(forKey: "Image") as! String
                
                strNavigateCarModel = imageURL
                //                strCarModelID = ""
                strCarModelIDIfZero = carModelIDConverString
                
                let available = dictOnlineCarData.object(forKey: "carCount") as! Int
                let checkAvailabla = String(available)
                
                if checkAvailabla != "0"
                {
                    strModelId = dictOnlineCarData.object(forKey: "Id") as! String
                }
                else
                {
                    strModelId = ""
                }
                
            }
            collectionViewCars.reloadData()
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
     {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CarsCollectionViewCell
        cell.viewOfImage.layer.borderColor = themeGrayColor.cgColor
        collectionView.deselectItem(at: indexPath, animated: true)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let CellWidth = collectionView.frame.width / 3
        //return CGSize(width: 200 , height: collectionView.frame.size.height)
        return CGSize(width: CellWidth - 10, height: collectionView.frame.size.height);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if (self.aryEstimateFareData.count) != 0 {
            if self.aryEstimateFareData.object(at: indexPath.row) as? NSDictionary != nil {
                
                if let ride = (self.aryEstimateFareData.object(at: indexPath.row) as! NSDictionary).object(forKey: "share_ride") as? String {
                    
                    if ride == "1" {
                        return true
                    }
                    else if ride == "0" {
                        return false
                    }
                }
            }
        }
        return true
    }
}

//MARK:-  Location Manager Delegate
extension HomeViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //        print("Location: \(location)")
        
        defaultLocation = location
        SingletonClass.sharedInstance.currentLatitude = "\(location.coordinate.latitude)"
        SingletonClass.sharedInstance.currentLongitude = "\(location.coordinate.longitude)"
        
        if(SingletonClass.sharedInstance.isFirstTimeDidupdateLocation)
        {
            SingletonClass.sharedInstance.isFirstTimeDidupdateLocation = false
        }
        
        if SingletonClass.sharedInstance.isTripContinue {
            let currentCordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            if(destinationCordinate == nil)
            {
                destinationCordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            }
            
            if driverMarker == nil {
                driverMarker = GMSMarker(position: destinationCordinate)
                
                var vehicleID = Int()
                //                                    var vehicleID = Int()
                if SingletonClass.sharedInstance.dictCarInfo.count != 0 {
                    if let vID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? Int {
                        
                        if vID == 0 {
                            vehicleID = 7
                        }
                        else {
                            vehicleID = vID
                        }
                    }
                    else if let sID = SingletonClass.sharedInstance.dictCarInfo["VehicleModel"] as? String
                    {
                        
                        if sID == "" {
                            vehicleID = 7
                        }
                        else {
                            vehicleID = Int(sID)!
                        }
                    }
                    self.driverMarker.icon = UIImage(named: "dummyCar")
                    
                }
                else {
                    driverMarker.icon = UIImage(named: "dummyCar")
                }
                
                
                driverMarker.map = mapView
            }
            
            //            self.moveMent.ARCarMovement(marker: driverMarker, oldCoordinate: destinationCordinate, newCoordinate: currentCordinate, mapView: mapView, bearing: Float(SingletonClass.sharedInstance.floatBearing))
            destinationCordinate = currentCordinate
            self.MarkerCurrntLocation.isHidden = true
        }
        
        
        if mapView.isHidden
        {
            mapView.isHidden = false
            self.getPlaceFromLatLong()
            self.socketMethods()
            
            mapView.delegate = self
            
            let position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
            
            MarkerCurrntLocation.isHidden = false
            
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude, zoom: 17)
            mapView.animate(to: camera)
            
            
        }

        let latitude: CLLocationDegrees = (location.coordinate.latitude)
        let longitude: CLLocationDegrees = (location.coordinate.longitude)
        
        let locations = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        CLGeocoder().reverseGeocodeLocation(locations, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                return
            }else if let _ = placemarks?.first?.country,
                let city = (placemarks?.first?.addressDictionary as! [String : AnyObject])["City"] {
                
                SingletonClass.sharedInstance.strCurrentCity = city as! String
            }
            else {
            }
        })
        
//        updatePolyLineToMapFromDriverLocation()
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
//            mapView.isHidden = true
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
//            mapView.isHidden = false
            locationManager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
//            mapView.isHidden = true // false
            locationManager.startUpdatingLocation()
            
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}

//MARK:- GMSAutoCompleteViewController Delegate
extension HomeViewController : GMSAutocompleteViewControllerDelegate
{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        self.MarkerCurrntLocation.isHidden = false
        self.btnDoneForLocationSelected.isHidden = false
        self.viewBookNowLater.isHidden = true
        let selectedLocation = "\(place.name ?? ""), \(place.formattedAddress ?? "")"

        if BoolCurrentLocation
        {
            self.lblCurrentLocationForDefaultView.text = selectedLocation
            self.lblUserFromAddress.text = selectedLocation
            self.strLocationType = currentLocationMarkerText
            self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            strPickupLocation = selectedLocation
            doublePickupLat = place.coordinate.latitude
            doublePickupLng = place.coordinate.longitude
            currentLocationMarker.map = nil
                        
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude, zoom: 17)
            self.mapView.camera = camera
            mapView.animate(to: camera)
            
        }
        else
        {
            self.lblUserFromAddress.text = strPickupLocation
            self.lblUserToAddress.text = selectedLocation
            self.defaultModeView.isHidden = true
            self.readyToBookRideView.isHidden = false
            self.collectionViewCars.reloadData()

            strLocationType = destinationLocationMarkerText
            self.strLocationType = destinationLocationMarkerText
            self.ConstantViewCarListsHeight.constant = 0
            self.viewCarLists.isHidden = true
            self.lblUserToAddress.text = selectedLocation
            strDropoffLocation = selectedLocation
            doubleDropOffLat = place.coordinate.latitude
            doubleDropOffLng = place.coordinate.longitude
            destinationLocationMarker.map = nil
            
            let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,longitude: place.coordinate.longitude, zoom: 17)
            self.mapView.camera = camera
            mapView.animate(to: camera)
        }
        
        if lblUserFromAddress.text?.count != 0 && lblUserToAddress.text?.count != 0 && aryOfOnlineCarsIds.count != 0 {
            postPickupAndDropLocationForEstimateFare()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        //print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - PickerView Methods
extension HomeViewController : UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerViewForNoOfPassenger {
            return 2
        }
        return cardData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == pickerViewForNoOfPassenger {
            return 120
        }
        return 60
    }
    
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //
    //    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if pickerView == pickerViewForNoOfPassenger {
            
            let myView = UIView(frame: CGRect(x:0, y:0, width: pickerViewForNoOfPassenger.frame.size.width, height: pickerViewForNoOfPassenger.frame.size.height))
            
            let myImageView = UIImageView(frame: CGRect(x:myView.center.x - 50, y:myView.center.y - 50, width:100, height:100))
            var rowString = String()
            switch row {
                
            case 0:
                myImageView.image = UIImage(named: "circle.png")
                rowString = "1"
            case 1:
                myImageView.image = UIImage(named: "circle.png")
                rowString = "2"
            default:
                print("something wrong")
            }
            
            let myLabel = UILabel(frame: CGRect(x:myImageView.center.x-10, y:myImageView.center.y-25, width:50, height:50 ))
            myLabel.font = UIFont.systemFont(ofSize: 30)
            myLabel.text = rowString
            
            
            myView.addSubview(myImageView)
            myView.addSubview(myLabel)
            
            return myView
        }
        
        let data = cardData[row]
        
        let myView = UIView(frame: CGRect(x:0, y:0, width: pickerView.bounds.width - 30, height: 60))
        
        let myImageView = UIImageView(frame: CGRect(x:0, y:0, width:50, height:50))
        
        var rowString = String()
        
        
        switch row {
            
        case 0:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 1:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 2:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 3:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 4:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 5:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 6:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 7:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 8:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 9:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        case 10:
            rowString = data["CardNum2"] as! String
            myImageView.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
        default:
            rowString = "Error: too many rows"
            myImageView.image = nil
        }
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        //        myLabel.font = UIFont(name:some, font, size: 18)
        myLabel.text = rowString
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerViewForNoOfPassenger {
            
            if row == 0 {
                intNumberOfPassengerOnShareRiding = 1
                
            } else if row == 1 {
                intNumberOfPassengerOnShareRiding = 2
            }
            txtNumberOfPassengers.text = "\(intNumberOfPassengerOnShareRiding)"
            
        }
        else {
            
            let data = cardData[row]
            
            imgPaymentType.image = UIImage(named: setCardIcon(str: data["Type"] as! String))
            txtSelectPaymentOption.text = data["CardNum2"] as? String
            
            let type = data["CardNum"] as! String
            
            if type  == "wallet" {
                paymentType = "wallet"
            }
            else if type == "cash" {
                paymentType = "cash"
            }
            else {
                paymentType = "card"
            }
            
            if paymentType == "card" {
                CardID = data["Id"] as! String
            }
            
        }
    }
}

//MARK:- Complete Trip Delegate

extension HomeViewController : CompleterTripInfoDelegate
{
    func didRatingCompleted()
    {
        openRatingView()
        //        self.completeTripInfo()
    }
}

//MARK:- Webservices Method List

extension HomeViewController {
    
    // MARK: - Find Cards List Available

    func webserviceOfCardList() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status) {
                //        print(result)
                
                if let res = result as? [String:AnyObject] {
                    if let cards = res["cards"] as? [[String:AnyObject]] {
                        self.aryCardsListForBookNow = cards
                    }
                }
                
                var dict = [String:AnyObject]()
                dict["CardNum"] = "cash" as AnyObject
                dict["CardNum2"] = "cash" as AnyObject
                dict["Type"] = "iconCashBlack" as AnyObject
                
                var dict2 = [String:AnyObject]()
                dict2["CardNum"] = "wallet" as AnyObject
                dict2["CardNum2"] = "wallet" as AnyObject
                dict2["Type"] = "iconWalletBlack" as AnyObject
                
                
                self.aryCardsListForBookNow.append(dict)
                self.aryCardsListForBookNow.append(dict2)
                
                SingletonClass.sharedInstance.CardsVCHaveAryData = (result as! NSDictionary).object(forKey: "cards") as! [[String:AnyObject]]
                
                self.pickerView.reloadAllComponents()
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CardListReload"), object: nil)
                
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
                
                
            }
            else {
                //    print(result)
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
    
    
    // MARK: - Add Address to Favourite

    func webserviceOfAddAddressToFavourite(type: String) {
        //        PassengerId,Type,Address,Lat,Lng
        
        var param = [String:AnyObject]()
        param["PassengerId"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        param["Type"] = type as AnyObject
        param["Address"] = lblUserToAddress.text as AnyObject
        param["Lat"] = doubleDropOffLat as AnyObject  // SingletonClass.sharedInstance.currentLatitude as AnyObject
        param["Lng"] = doubleDropOffLng as AnyObject  // SingletonClass.sharedInstance.currentLongitude as AnyObject
        
        webserviceForAddAddress(param as AnyObject) { (result, status) in
            
            if (status) {
                //  print(result)
                
                if let res = result as? String {
                    
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let res = result as? NSDictionary {
                    
                    let alert = UIAlertController(title: nil, message: res.object(forKey: "message") as? String, preferredStyle: .alert)
                    let OK = UIAlertAction(title: "OK".localized, style: .default, handler: { ACTION in
                        
                        UIView.transition(with: self.viewForMainFavourite, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                            self.viewForMainFavourite.isHidden = true
                        }) { _ in }
                    })
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            else {
                //     print(result)
            }
        }
    }
    
    // MARK: - Get Current Booking Status

    func webserviceOfCurrentBooking() {
        
        if let Token = UserDefaults.standard.object(forKey: "Token") as? String {
            SingletonClass.sharedInstance.deviceToken = Token
            print("SingletonClass.sharedInstance.deviceToken : \(SingletonClass.sharedInstance.deviceToken)")
        }
        
        let param = SingletonClass.sharedInstance.strPassengerID + "/" + SingletonClass.sharedInstance.deviceToken
        
        webserviceForCurrentTrip(param as AnyObject) { (result, status) in
            
            if (status)
            {
                // print(result)
                self.clearMap()
                let resultData = (result as! NSDictionary)
                
                SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as! String
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                
                self.aryCurrentBookingData.add(resultData)
                self.aryRequestAcceptedData = self.aryCurrentBookingData
                
                let bookingType = (self.aryCurrentBookingData.object(at: 0) as! NSDictionary).object(forKey: "BookingType") as! String
                
                if bookingType != ""
                {
                    self.MarkerCurrntLocation.isHidden = true
                    
                    if bookingType == "BookNow"
                    {
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted"
                        {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling"
                        {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                        
                    }
                    else if bookingType == "BookLater"
                    {
                        self.dictCurrentBookingInfoData = ((resultData).object(forKey: "BookingInfo") as! NSArray).object(at: 0) as! NSDictionary
                        let statusOfRequest = self.dictCurrentBookingInfoData.object(forKey: "Status") as! String
                        
                        self.strBookingType = bookingType
                        
                        if statusOfRequest == "accepted"
                        {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            self.bookingTypeIsBookNowAndAccepted()
                            
                        }
                        else if statusOfRequest == "traveling"
                        {
                            self.bookingIDNow = self.dictCurrentBookingInfoData.object(forKey: "Id") as! String
                            self.passengerId = SingletonClass.sharedInstance.strPassengerID
                            SingletonClass.sharedInstance.bookingId = self.bookingIDNow
                            
                            SingletonClass.sharedInstance.isTripContinue = true
                            self.bookingTypeIsBookNowAndTraveling()
                        }
                    }
                    
                    NotificationCenter.default.post(name: NotificationForAddNewBooingOnSideMenu, object: nil)
                }
            }
            else
            {
                if let resultData = result as? NSDictionary
                {
                    SingletonClass.sharedInstance.passengerRating = resultData.object(forKey: "rating") as? String ?? ""
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rating"), object: nil)
                }
                self.setHideAndShowTopViewWhenRequestAcceptedAndTripStarted(status: false)
            }
        }
    }
    
    //MARK:- Booking Requests
    func webserviceCallForBookingCar(){
   //PassengerId,ModelId,PickupLocation,DropoffLocation,PickupLat,PickupLng,DropOffLat,DropOffLon
        //,PromoCode,Notes,PaymentType,CardId(If paymentType is card)
        
        let dictParams = NSMutableDictionary()
        dictParams.setObject(SingletonClass.sharedInstance.strPassengerID, forKey: "PassengerId" as NSCopying)
        dictParams.setObject(strModelId, forKey: SubmitBookingRequest.kModelId as NSCopying)
        if(strModelId == "")
        {
            dictParams.setObject(strCarModelIDIfZero, forKey: SubmitBookingRequest.kModelId as NSCopying)
            
        }
        dictParams.setObject(strPickupLocation, forKey: SubmitBookingRequest.kPickupLocation as NSCopying)
        dictParams.setObject(strDropoffLocation, forKey: SubmitBookingRequest.kDropoffLocation as NSCopying)
        
        dictParams.setObject(doublePickupLat, forKey: SubmitBookingRequest.kPickupLat as NSCopying)
        dictParams.setObject(doublePickupLng, forKey: SubmitBookingRequest.kPickupLng as NSCopying)
        
        dictParams.setObject(doubleDropOffLat, forKey: SubmitBookingRequest.kDropOffLat as NSCopying)
        dictParams.setObject(doubleDropOffLng, forKey: SubmitBookingRequest.kDropOffLon as NSCopying)
        
        dictParams.setObject(txtNote.text!, forKey: SubmitBookingRequest.kNotes as NSCopying)
        dictParams.setObject(strSpecialRequest, forKey: SubmitBookingRequest.kSpecial as NSCopying)
        dictParams.setObject(self.strSelectedCarTotalFare, forKey: "EstimateFare" as NSCopying)
      
        if paymentType == ""
        {
            
        }
        else
        {
            dictParams.setObject(paymentType, forKey: SubmitBookingRequest.kPaymentType as NSCopying)
        }
        
        if txtHavePromocode.text == "" {
            
        }
        else
        {
            dictParams.setObject(txtHavePromocode.text!, forKey: SubmitBookingRequest.kPromoCode as NSCopying)
        }
        
        if CardID == ""
        {
            
        }
        else
        {
            dictParams.setObject(CardID, forKey: SubmitBookingRequest.kCardId as NSCopying)
        }
        
        if intShareRide == 1
        {
            dictParams.setObject(intShareRide, forKey: SubmitBookingRequest.kShareRide as NSCopying)
            dictParams.setObject(intNumberOfPassengerOnShareRiding, forKey: SubmitBookingRequest.kNoOfPassenger as NSCopying)
            
        }
        
        self.view.bringSubview(toFront: self.viewMainActivityIndicator)
        self.viewMainActivityIndicator.isHidden = false
        webserviceForTaxiRequest(dictParams) { (result, status) in
            
            //  print(result)

            if (status)
            {
                
                SingletonClass.sharedInstance.bookedDetails = (result as! NSDictionary)
                
                if let bookingId = ((result as! NSDictionary).object(forKey: "details") as! NSDictionary).object(forKey: "BookingId") as? Int {
                    SingletonClass.sharedInstance.bookingId = "\(bookingId)"
                }
                
                self.strBookingType = "BookNow"
                self.viewBookNow.isHidden = true
                self.readyToBookRideView.isHidden = true
                self.viewActivity.startAnimating()
            }
            else
            {
                self.viewBookNow.isHidden = true
                self.viewMainActivityIndicator.isHidden = true
                
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary {
                    if((resDict.object(forKey: "message") as? NSArray) != nil)
                    {
                        UtilityClass.setCustomAlert(title: "Error", message: (resDict.object(forKey: "message") as! NSArray).object(at: 0) as! String) { (index, title) in
                        }
                    }
                    else
                    {
                        UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                        }
                    }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
}
