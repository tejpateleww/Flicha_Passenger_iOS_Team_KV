//
//  MyBookingViewController.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView
import SideMenuController

enum Enum_MyBookingSegmentTabs : Int {
    case Upcoming = 0
    case Completed = 1
    case Canceled = 2
}

class MyBookingViewController: BaseViewController {

    // MARK: - Outlets
  
    @IBOutlet weak var lbltitile: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnUpComming: UIButton!
    @IBOutlet weak var btnCanceled: UIButton!
    @IBOutlet weak var seperatorLineView: UIView!
    @IBOutlet weak var scrollObject: UIScrollView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var sepeatorLineXPositionConstant: NSLayoutConstraint!
    @IBOutlet weak var segmentView: UIView!
    
    var isFromPushNotification = Bool()
    var bookingType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupView()
    }
    
    func setupView()
    {
        self.addCustomNavigationBar(title: kMyRidePageTitle)

        lbltitile.text = kMyRidePageTitle
        
        btnUpComming.setTitle(kSegmentUpcomingTitle, for: .normal)
        btnComplete.setTitle(kSegmentCompletedTitle, for: .normal)
        btnCanceled.setTitle(kSegmentCanceledTitle, for: .normal)
        
        scrollObject.isUserInteractionEnabled = true
        scrollObject.delegate = self
        scrollObject.layoutIfNeeded()
        scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        seperatorLineView.backgroundColor = themeYellowColor
        
        self.btnUpComming.titleLabel?.font = UIFont.regular(ofSize: 10)
        self.btnComplete.titleLabel?.font = UIFont.regular(ofSize: 10)
        self.btnCanceled.titleLabel?.font = UIFont.regular(ofSize: 10)
        self.btnUpComming.setTitleColor(themeGrayTextColor, for: .normal)
        self.btnUpComming.setTitleColor(themeYellowColor, for: .selected)
        self.btnComplete.setTitleColor(themeGrayTextColor, for: .normal)
        self.btnComplete.setTitleColor(themeYellowColor, for: .selected)
        self.btnCanceled.setTitleColor(themeGrayTextColor, for: .normal)
        self.btnCanceled.setTitleColor(themeYellowColor, for: .selected)
        
        if (isFromPushNotification)
        {
            if bookingType == "accept"
            {
                self.handleSelectedSegment(tabIndex: .Upcoming)
            }
            else if bookingType == "reject"
            {
                self.handleSelectedSegment(tabIndex: .Canceled)
            }
        }
        else
        {
            self.handleSelectedSegment(tabIndex: .Upcoming)
        }
    }
    
    //-------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------
    
    @IBAction func segmentButtonClickAction(_ sender: Any) {
        
        if let buttonTag = (sender as? UIButton)?.tag
        {
            if let segmentTab = Enum_MyBookingSegmentTabs(rawValue: buttonTag)
            {
                self.handleSelectedSegment(tabIndex: segmentTab)
            }
        }
    }
    
    func handleSelectedSegment(tabIndex : Enum_MyBookingSegmentTabs) {
        
        if tabIndex == .Upcoming
        {
            self.btnUpComming.isSelected = true
            self.btnComplete.isSelected = false
            self.btnCanceled.isSelected = false
            scrollObject.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.getRideBookingHistory(bookingType: tabIndex)
            
        }else if tabIndex == .Completed
        {
            self.btnUpComming.isSelected = false
            self.btnComplete.isSelected = true
            self.btnCanceled.isSelected = false
            scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated: true)
            self.getRideBookingHistory(bookingType: tabIndex)

        }else if tabIndex == .Canceled
        {
            self.btnUpComming.isSelected = false
            self.btnComplete.isSelected = false
            self.btnCanceled.isSelected = true
            scrollObject.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
            self.getRideBookingHistory(bookingType: tabIndex)
        }
        
        let currentXPosition = (scrollObject.frame.size.width / (scrollObject.contentSize.width/scrollObject.contentOffset.x))
        self.sepeatorLineXPositionConstant.constant = currentXPosition
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        if isModal()
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
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
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func isModal() -> Bool
    {
        if (presentingViewController != nil)
        {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if (tabBarController?.presentingViewController is UITabBarController) {
            return true
        }
        return false
    }
}

// MARK: - Scroll Methods

extension MyBookingViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let currentXPosition = (scrollView.frame.size.width / (scrollView.contentSize.width/scrollView.contentOffset.x))
        self.sepeatorLineXPositionConstant.constant = currentXPosition
        self.view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
       
        if let segmentTab = Enum_MyBookingSegmentTabs(rawValue: Int(currentPage))
        {
            self.handleSelectedSegment(tabIndex: segmentTab)
        }
    }
    
}

// MARK: - Webservice Methods

extension MyBookingViewController
{
    func getRideBookingHistory(bookingType : Enum_MyBookingSegmentTabs)
    {
        if bookingType == .Upcoming
        {
            if let upcomingRidesVC = self.childViewControllers[0] as? UpCommingRidesVC
            {
                if upcomingRidesVC.aryUpcomingRidesData == nil || upcomingRidesVC.aryUpcomingRidesData?.count == 0
                {
                    upcomingRidesVC.getUpcomingRidesList()
                }
            }
            
        }else if bookingType == .Completed
        {
            if let completedRidesVC = self.childViewControllers[1] as? CompletedRidesVC
            {
                if completedRidesVC.aryCompletedRidesData == nil || completedRidesVC.aryCompletedRidesData?.count == 0
                {
                    completedRidesVC.getCompletedRidesList()
                }
            }
            
        }else
        {
            if let cancelVC = self.childViewControllers[2] as? CanceledRidesVC
            {
                if cancelVC.aryCanceledRidesHistory == nil || cancelVC.aryCanceledRidesHistory?.count == 0
                {
                    cancelVC.getCanceledRidesList(pageIndex: 1)
                }
            }
        }
    }

}

