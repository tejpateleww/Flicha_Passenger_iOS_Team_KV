//
//  OnGoingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

class CompletedRidesVC: UIViewController {

    // MARK: - Outlets
   @IBOutlet weak var tableView: UITableView!
    private var isDataLoading:Bool = false
    private var pageNo:Int = 0
    private var didEndReached:Bool = false
    private let CellID = "RideDetailsTableViewCell"
    var aryCompletedRidesData : NSArray?

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = themeYellowColor
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "RideDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: CellID)
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataOfTableView), name: NSNotification.Name(rawValue: NotificationCenterName.keyForCompletedRides), object: nil)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        (self.parent as? MyBookingViewController)?.getRideBookingHistory()
    }
   
    @objc func reloadDataOfTableView() {
        refreshControl.endRefreshing()
        self.aryCompletedRidesData = SingletonClass.sharedInstance.aryCompletedRides
        self.tableView.reloadData()
    }
    
}


// MARK: - Table View Methods
extension CompletedRidesVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryCompletedRidesData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! RideDetailsTableViewCell
        
        if let rideDetails = self.aryCompletedRidesData?[indexPath.row] as? [String : Any]
        {
            if let pickUpDateAndTime = rideDetails["PickupDateTime"] as? String
            {
                let datePickUp = pickUpDateAndTime.convertStringToDate(dateFormat: "yyyy-MM-dd HH:mm")
                cell.lblTime.text = datePickUp.relativeDateFormat()
            }
           
            cell.lblCategoryType.text = rideDetails["Model"] as? String ?? ""
            cell.lblPriceValue.text = (rideDetails["TripFare"] as? String)?.toCurrencyFormat() ?? ""
            cell.lblAddress.text = rideDetails["DropoffLocation"] as? String ?? ""
        }
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
        }
    }
       
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == ((self.aryCompletedRidesData?.count ?? 0) - 5) {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo = self.pageNo + 1
                //webserviceOfPastbookingpagination(index: self.pageNo)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}
