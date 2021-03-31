//
//  ConstantData.swift
//  TickTok User
//
//  Created by Excellent Webworld on 28/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Foundation

let themeYellowColor: UIColor =  UIColor.init(red: 249/255, green: 189/255, blue: 60/255, alpha: 1.0)
let themeBlueColor: UIColor =  UIColor.init(red: 34/255, green: 44/255, blue: 68/255, alpha: 1.0)
let themeBlueLightColor: UIColor =  UIColor.init(red: 50/255, green: 58/255, blue: 81/255, alpha: 1.0)

//let themeYellowColor: UIColor =  UIColor.init(hex: "ef4036")
let themeBlackColor: UIColor =  UIColor.init(hex: "231f20")
let themeRedColor: UIColor = UIColor.init(hex: "EF4036")
//    UIColor.init(red: 255/255, green: 163/255, blue: 0, alpha: 1.0)
let themeGrayColor: UIColor = UIColor.init(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
//let ThemeYellowColor : UIColor = UIColor.init(hex: "ffa300")
let themeGrayBGColor : UIColor = UIColor.init(hex: "DDDDDD")
let themeGrayTextColor : UIColor = UIColor.init(hex: "7A7A7C")
let themeLightGreyColor: UIColor =  UIColor.init(red: 134/255, green: 144/255, blue: 161/255, alpha: 1.0)


let currencySign = "DA"
let appName = "Flicha"
let helpLineNumber = "+255777115054"//"0772506506"
let googleAnalyticsTrackId = "UA-122360832-1"

let AppRegularFont:String = "ProximaNova-Regular"
let AppBoldFont:String = "ProximaNova-Bold"
let AppSemiboldFont:String = "ProximaNova-Semibold"
let dictanceType : String = " "
let windowHeight: CGFloat = CGFloat(UIScreen.main.bounds.size.height)
let screenHeightDeveloper : Double = 568
let screenWidthDeveloper : Double = Double(UIScreen.main.bounds.size.width)
let appDel = (UIApplication.shared.delegate as! AppDelegate)

struct WebserviceURLs {
    
    static let kBaseURL                                 = "https://flicha.com/web/Passenger_Api/"
    static let kDriverRegister                          = "Register"
    static let kDriverLogin                             = "Login"
    static let kChangePassword                          = "ChangePassword"
    static let kSocialLogin                             = "SocialLogin"
    static let kUpdateProfile                           = "UpdateProfile"
    static let kForgotPassword                          = "ForgotPassword"
    static let kGetCarList                              = "GetCarClass"
    static let kMakeBookingRequest                      = "SubmitBookingRequest"
    static let kAdvancedBooking                         = "AdvancedBooking"
    static let kDriver                                  = "Driver"
    static let kBookingHistory                          = "BookingHistory"
    
    static let kPastBooking                             = "PastBooking"
    static let kCanceledBooking                         = "CancelledBooking"
    static let kGetEstimateFare                         = "GetEstimateFare"
    static let kImageBaseURL                            = "https://flicha.com/web/"
    static let kFeedbackList                            = "FeedbackList/"
    static let kCardsList                               = "Cards/"
    static let kPackageBookingHistory                   = "PackageBookingHistory"
    static let kBookPackage                             = "BookPackage"
    static let kCurrentBooking                          = "CurrentBooking/"
    static let kAddNewCard                              = "AddNewCard"
    static let kAddMoney                                = "AddMoney"
    static let kTransactionHistory                      = "TransactionHistory/"
    static let kSendMoney                               = "SendMoney"
    static let kQRCodeDetails                           = "QRCodeDetails"
    static let kRemoveCard                              = "RemoveCard/"
    static let kTickpay                                 = "Tickpay"
    static let kAddAddress                              = "AddAddress"
    static let kGetAddress                              = "GetAddress/"
    static let kRemoveAddress                           = "RemoveAddress/"
    static let kVarifyUser                              = "VarifyUser"
    static let kTickpayInvoice                          = "TickpayInvoice"
    static let kGetTickpayRate                          = "GetTickpayRate"
    static let kInit                                    = "Init/"
    
    static let kReviewRating                            = "ReviewRating"
    static let kGetTickpayApprovalStatus                = "GetTickpayApprovalStatus/"
    static let kTransferToBank                          = "TransferToBank"
    static let kUpdateBankAccountDetails                = "UpdateBankAccountDetails"
    static let kOtpForRegister                          = "OtpForRegister"
    static let kGetPackages                             = "Packages"
    static let kMissBokkingRequest                      = "BookingMissRequest"
    static let kTrackRunningTrip                        = "TrackRunningTrip/"
    static let kUpdateNotificationSetting               = "UpdateNotificationSetting"
    static let kNotificationList                        = "NotificationList/"
    static let kCancelTripByPassenger                   = "CancelTripByPassenger"
   
    static let kUpcomingBooking_get                     = "UpcomingBooking/"
    static let kOngoingBooking_get                      = "OngoingBooking/"
    static let kPastBooking_get                         = "PastBooking/"
    static let kCancelledBooking_get                    = "CancelTripByPassenger/"
    
    static let kAppleLogin                              = "AppleLogin"
    
    static let kFAQList                                 = "FaqList"
    
}



struct SocketData {
    
    static let kBaseURL                                     = "https://flicha.com:8080"
    static let kNearByDriverList                            = "NearByDriverListIOS"
    static let kUpdatePassengerLatLong                      = "UpdatePassengerLatLong"
    static let kAcceptBookingRequestNotification            = "AcceptBookingRequestNotification"
    static let kRejectBookingRequestNotification            = "RejectBookingRequestNotification"
    static let kPickupPassengerNotification                 = "PickupPassengerNotification"
    static let kBookingCompletedNotification                = "BookingDetails"
    static let kCancelTripByPassenger                       = "CancelTripByPassenger"
    static let kCancelTripByDriverNotficication             = "PassengerCancelTripNotification"
    static let kSendDriverLocationRequestByPassenger        = "DriverLocation"
    static let kReceiveDriverLocationToPassenger            = "GetDriverLocation"
    static let kReceiveHoldingNotificationToPassenger       = "TripHoldNotification"
    static let kSendRequestForGetEstimateFare               = "EstimateFare"
    static let kReceiveGetEstimateFare                      = "GetEstimateFare"
    
    static let kAcceptAdvancedBookingRequestNotification    = "AcceptAdvancedBookingRequestNotification"
    static let kRejectAdvancedBookingRequestNotification    = "RejectAdvancedBookingRequestNotification"
    static let kAdvancedBookingPickupPassengerNotification  = "AdvancedBookingPickupPassengerNotification"
    static let kAdvancedBookingTripHoldNotification         = "AdvancedBookingTripHoldNotification"
    static let kAdvancedBookingDetails                      = "AdvancedBookingDetails"
    static let kAdvancedBookingCancelTripByPassenger        = "AdvancedBookingCancelTripByPassenger"
    
    static let kInformPassengerForAdvancedTrip              = "InformPassengerForAdvancedTrip"
    static let kAcceptAdvancedBookingRequestNotify          = "AcceptAdvancedBookingRequestNotify"
    
    static let kAskForTipsToPassenger                       = "AskForTipsToPassenger"
    static let kAskForTipsToPassengerForBookLater           = "AskForTipsToPassengerForBookLater"

    static let kReceiveTips                                 = "ReceiveTips"
    static let kReceiveTipsForBookLater                     = "ReceiveTipsForBookLater"
}

struct SocketDataKeys {
    
    static let kBookingIdNow    = "BookingId"
}



struct SubmitBookingRequest {

    static let kModelId                 = "ModelId"
    static let kPickupLocation          = "PickupLocation"
    static let kDropoffLocation         = "DropoffLocation"
    static let kPickupLat               = "PickupLat"
    static let kPickupLng               = "PickupLng"
    static let kDropOffLat              = "DropOffLat"
    static let kDropOffLon              = "DropOffLon"
    
    static let kPromoCode               = "PromoCode"
    static let kNotes                   = "Notes"
    static let kPaymentType             = "PaymentType"
    static let kCardId                  = "CardId"
    static let kSpecial                 = "Special"
    
    static let kShareRide               = "ShareRide"
    static let kNoOfPassenger           = "NoOfPassenger"
}


struct PassengerDataKeys {
    static let kPassengerID = "PassengerId"
}

struct setAllDevices {
    static let allDevicesStatusBarHeight = 20
    static let allDevicesNavigationBarHeight = 44
    static let allDevicesNavigationBarTop = 20
}

struct setiPhoneX {
    static let iPhoneXStatusBarHeight = 44
    static let iPhoneXNavigationBarHeight = 40
    static let iPhoneXNavigationBarTop = 44
}

let NotificationKeyFroAllDriver =  NSNotification.Name("NotificationKeyFroAllDriver")
let NotificationBookNow = NSNotification.Name("NotificationBookNow")
let NotificationBookLater = NSNotification.Name("NotificationBookLater")

let NotificationTrackRunningTrip = NSNotification.Name("NotificationTrackRunningTrip")
let NotificationForBookingNewTrip = NSNotification.Name("NotificationForBookingNewTrip")
let NotificationForAddNewBooingOnSideMenu = NSNotification.Name("NotificationForAddNewBooingOnSideMenu")

let OpenEditProfile = NSNotification.Name("OpenEditProfile")
let OpenMyBooking = NSNotification.Name("OpenMyBooking")
let OpenPaymentOption = NSNotification.Name("OpenPaymentOption")
let OpenWallet = NSNotification.Name("OpenWallet")
let OpenMyReceipt = NSNotification.Name("OpenMyReceipt")
let OpenFavourite = NSNotification.Name("OpenFavourite")
let OpenInviteFriend = NSNotification.Name("OpenInviteFriend")
let OpenSetting = NSNotification.Name("OpenSetting")
let OpenSupport = NSNotification.Name("OpenSupport")
let OpenHome = NSNotification.Name("OpenHome")
let OpenHelp = NSNotification.Name("OpenHelp")
let OpenNotification = NSNotification.Name("OpenNotification")

let UpdateProPic = NSNotification.Name("UpdateProPic")
