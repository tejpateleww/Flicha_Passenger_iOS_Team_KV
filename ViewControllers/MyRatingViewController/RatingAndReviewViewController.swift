//
//  RatingAndReviewViewController.swift
//  Flicha User
//
//  Created by EWW071 on 05/05/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class RatingAndReviewViewController: BaseViewController {
    
    @IBOutlet weak var btnDriverPhoto: UIButton!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var driverReviewStarView: UIView!
    @IBOutlet weak var lblCarModel: UILabel!
    @IBOutlet weak var btnRideType: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var textViewCommentBox: UITextView!
    @IBOutlet weak var giveRating: FloatRatingView!
    
    var delegateRating: delegateRateGiven?
    var strBookingID = String()
    var strBookingType = String()
    var ratingToDriver = Float()
    var dictData = NSDictionary()
    var rideDetails = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setDetails()
    }
    
    func setupView() {
        self.addCustomNavigationBar(title: "Ratings & Review")
        
        self.giveRating.delegate = self
        
        self.lblTitle.text = "HOW IS YOUR TRIP?"
        self.lblTitle.font = UIFont.regular(ofSize: 17)
        
        self.lblDescriptions.text = "Your Feedback will help us improve driving experience better."
        self.lblDescriptions.font = UIFont.regular(ofSize: 15)
        self.lblDescriptions.textColor = themeGrayTextColor
        
        self.btnDriverPhoto.contentMode = .scaleAspectFit
        self.btnRideType.titleLabel?.font =  UIFont.regular(ofSize: 12)
        
        self.btnRideType.backgroundColor = themeRedColor
        self.textViewCommentBox.backgroundColor = UIColor.groupTableViewBackground
        self.textViewCommentBox.borderColor = UIColor.lightGray
        self.textViewCommentBox.borderWidth = 1
        
        self.btnSubmit.setTitle("Submit Review", for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        self.textViewCommentBox.layer.cornerRadius = 4
        self.textViewCommentBox.layer.masksToBounds = true
    }
    
    func setDetails() {
        
        if let driverInfo = ((self.rideDetails.object(at: 0) as? NSDictionary)?.object(forKey: "DriverInfo") as? NSArray)?.object(at: 0) as? NSDictionary
        {
            self.lblDriverName.text = driverInfo.object(forKey: "Fullname") as? String ?? ""
            
            if let driverImageName = driverInfo.object(forKey: "Image") as? String
            {
                self.btnDriverPhoto.sd_setImage(with: URL(string:  WebserviceURLs.kImageBaseURL + driverImageName), for: .normal, completed: nil)
            }
        }
        
        if let carInfo = ((self.rideDetails.object(at: 0) as? NSDictionary)?.object(forKey: "CarInfo") as? NSArray)?.object(at: 0) as? NSDictionary
        {
            let vehicleNumber = carInfo.object(forKey: "VehicleRegistrationNo") as? String ?? ""
            let vehicleModel = carInfo.object(forKey: "VehicleModelName") as? String ?? ""
            self.lblCarModel.text = "\(vehicleNumber) - \(vehicleModel)"
        }
        
        if let modelInfo = ((self.rideDetails.object(at: 0) as? NSDictionary)?.object(forKey: "ModelInfo") as? NSArray)?.object(at: 0) as? NSDictionary
        {
            let modelType = modelInfo.object(forKey: "Name") as? String ?? ""
            self.btnRideType.setTitle(modelType, for: .normal)
        }
    }
    
    @IBAction func btnSubmitClickAction(_ sender: Any) {
        self.webserviceOfRating()
    }
}

// MARK: - Ratings View Delegate

extension RatingAndReviewViewController : FloatRatingViewDelegate
{
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        giveRating.rating = rating
        ratingToDriver = giveRating.rating
    }
}

// MARK: - Webservice Methods

extension RatingAndReviewViewController {
    
    func webserviceOfRating()
    {
        var param = [String:AnyObject]()
        param["BookingId"] = SingletonClass.sharedInstance.bookingId as AnyObject
        param["Rating"] = ratingToDriver as AnyObject
        param["Comment"] = textViewCommentBox.text as AnyObject
        param["BookingType"] = strBookingType as AnyObject
        
        webserviceForRatingAndComment(param as AnyObject) { (result, status) in
            
            if (status)
            {
                print(result)
                self.textViewCommentBox.text = ""
                self.ratingToDriver = 0
                self.btnSubmit.isUserInteractionEnabled = true
                self.dismiss(animated: true, completion: nil)
                self.ratingToDriver = 0
                self.dismiss(animated: true, completion: nil)
                UtilityClass.showAlert(appName, message: "Thanks for feedback".localized, vc: (UIApplication.shared.keyWindow?.rootViewController)!)
                self.btnSubmit.isUserInteractionEnabled = true
            }
            else
            {
                print(result)
                self.btnSubmit.isUserInteractionEnabled = true
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
            
            self.btnSubmit.isUserInteractionEnabled = true
            SingletonClass.sharedInstance.bookingId = ""
        }
    }
    
}
