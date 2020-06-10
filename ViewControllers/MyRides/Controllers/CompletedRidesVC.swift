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
    @IBOutlet weak var lblNoDataFound: UILabel!
    
    private var isDataLoading:Bool = false
    private var pageNo:Int = 0
    private var didEndReached:Bool = false
    private let CellID = "RideDetailsTableViewCell"
    var aryCompletedRidesData : [[String:Any]] = []
    
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
        self.lblNoDataFound.isHidden = true
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "RideDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: CellID)
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        self.pageNo = 1
        self.didEndReached = false
        self.aryCompletedRidesData.removeAll()
        self.tableView.reloadData()
        self.getCompletedRidesList(pageIndex: pageNo)
        
    }
    
    @objc func reloadDataOfTableView() {
        refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
}

// MARK: - Table View Methods
extension CompletedRidesVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryCompletedRidesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! RideDetailsTableViewCell
        
        let rideDetails = self.aryCompletedRidesData[indexPath.row]
        if let pickUpDateAndTime = rideDetails["PickupDateTime"] as? String
        {
            let datePickUp = pickUpDateAndTime.convertStringToDate(dateFormat: "yyyy-MM-dd HH:mm")
            cell.lblTime.text = datePickUp.relativeDateFormat()
        }
        
        if let mapURL = rideDetails["MapUrl"] as? String, let encodedStr = mapURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            cell.imageViewRideRoute.sd_setImage(with: URL.init(string: encodedStr), completed: nil)
        }
        
        cell.lblCategoryType.text = rideDetails["Model"] as? String ?? ""
        cell.lblPriceValue.text = (rideDetails["TripFare"] as? String)?.currencyInputFormatting() ?? ""
        cell.lblAddress.text = rideDetails["DropoffLocation"] as? String ?? ""
        
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
        
        if indexPath.row == (self.aryCompletedRidesData.count - 5) {
            if !isDataLoading{
                isDataLoading = true
                self.getCompletedRidesList(pageIndex: self.pageNo + 1)
                //webserviceOfPastbookingpagination(index: self.pageNo)
            }
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

extension CompletedRidesVC {
    
    func getCompletedRidesList(pageIndex : Int)
    {
        webserviceForPastBookingList("\(SingletonClass.sharedInstance.strPassengerID)", PageNumber: "\(pageIndex)") { (result, status) in
            if (status) {
                self.pageNo = pageIndex
                
                if let dictData = result as? [String:Any]
                {
                    if let aryHistory = dictData["history"] as? [[String:AnyObject]], aryHistory.count > 0
                    {
                        //  Canceled
                        //if let resultsPastRides = aryHistory.filter({ ($0["HistoryType"]?.lowercased == "Past".lowercased()) && ($0["Status"]?.lowercased == "canceled".lowercased())}) as [[String:AnyObject]]?
                        //{
//                         let arrResults = aryHistory.filter({ ($0["Status"] as? String) == "completed" })
                        
                        if self.aryCompletedRidesData.count == 0
                        {
                            self.aryCompletedRidesData =  aryHistory
                            self.tableView.reloadData()
                            
                        }else
                        {
                            self.aryCompletedRidesData.append(contentsOf: aryHistory)
                            self.tableView.reloadData()
                        }
                        
                        self.isDataLoading = false
                        
                    }else
                    {
                        self.didEndReached = true
                    }
                    
                    self.lblNoDataFound.isHidden = self.aryCompletedRidesData.count > 0
                }
            }
        }
    }
}
