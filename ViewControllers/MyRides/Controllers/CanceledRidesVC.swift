//
//  PastBookingVC.swift
//  TickTok User
//
//  Created by Excellent Webworld on 09/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class CanceledRidesVC: UIViewController
{
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    private var isDataLoading:Bool = false
    private var pageNo:Int = 1
    private var didEndReached:Bool = false
    var aryCanceledRidesHistory : NSMutableArray?
    private let CellID = "RideDetailsTableViewCell"

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = themeYellowColor
        return refreshControl
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "RideDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: CellID)
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        refreshControl.endRefreshing()
        self.pageNo = 1
        self.didEndReached = false
        self.aryCanceledRidesHistory?.removeAllObjects()
        self.tableView.reloadData()
        self.getCanceledRidesList(pageIndex: pageNo)
    }

    @objc func reloadTableView()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

//    @IBAction func btnCellPaymentReceiptClicked(_ sender: UIButton)
//    {
//        let btnTag = sender.tag
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "PesapalWebViewViewController") as! PesapalWebViewViewController
//        next.delegate = self as? delegatePesapalWebView
//        let currentData = (aryCanceledRidesHistory?.object(at: btnTag) as! NSDictionary)
//
//        let url = currentData.object(forKey: "payment_url") as! String //"https://www.tantaxitanzania.com/pesapal/add_money/\(SingletonClass.sharedInstance.strPassengerID)/\("\(Amount)")/passenger"
//        next.strUrl = url
//        //            self.present(next, animated: true, completion: nil)
//
//        let navController = UINavigationController.init(rootViewController: next)
//        UIApplication.shared.keyWindow?.rootViewController?.present(navController, animated: true, completion: nil)
//    }
    
}

// MARK: - Table View Methods

extension CanceledRidesVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryCanceledRidesHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! RideDetailsTableViewCell
        
        if let rideDetails = self.aryCanceledRidesHistory?[indexPath.row] as? [String : Any]
        {
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
        }
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
        }
    }
       
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.aryCanceledRidesHistory?.count ?? 0 > 0 && indexPath.row == ((self.aryCanceledRidesHistory?.count ?? 0) - 1) && self.didEndReached == false
        {
            if !isDataLoading
            {
                isDataLoading = true
                getCanceledRidesList(pageIndex: self.pageNo + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

// MARK: - Webservice Methods

extension CanceledRidesVC
{
    func getCanceledRidesList(pageIndex : Int)
    {
        webserviceForPastBookingRides("\(SingletonClass.sharedInstance.strPassengerID)/\(pageIndex)" as AnyObject) { (result, status) in
            
            if (status)
            {
                self.pageNo = pageIndex
                
                if let dictData = result as? [String:AnyObject]
                {
                    if let aryHistory = dictData["history"] as? [[String:AnyObject]], aryHistory.count > 0
                    {
                        //  Canceled
                        //if let resultsPastRides = aryHistory.filter({ ($0["HistoryType"]?.lowercased == "Past".lowercased()) && ($0["Status"]?.lowercased == "canceled".lowercased())}) as [[String:AnyObject]]?
                        //{
                        
                        if self.aryCanceledRidesHistory == nil || self.aryCanceledRidesHistory?.count == 0
                        {
                            self.aryCanceledRidesHistory = NSMutableArray.init(array: aryHistory, copyItems: true)
                            self.tableView.reloadData()
                            
                        }else
                        {
                            self.aryCanceledRidesHistory?.addObjects(from: aryHistory)
                            self.tableView.reloadData()
                        }
                        
                        self.isDataLoading = false
                        
                    }else
                    {
                        self.didEndReached = true
                    }
                }
            }
            else
            {
                
                
            }
            
        }
        
    }
    
    
    //    func webserviceOfPastbookingpagination(index: Int)
    //    {
    //        let driverId = SingletonClass.sharedInstance.strPassengerID //+ "/" + "\(index)"
    //
    //        webserviceForPastBookingList(driverId as AnyObject, PageNumber: index as AnyObject) { (result, status) in
    //            if (status)
    //            {
    //                DispatchQueue.main.async {
    //
    //                    var tempPastData = NSArray()
    //
    //                    if let dictData = result as? [String:AnyObject]
    //                    {
    //                        if let aryHistory = dictData["history"] as? [[String:AnyObject]]
    //                        {
    //                            tempPastData = aryHistory as NSArray
    //                        }
    //                    }
    //
    //                    for i in 0..<tempPastData.count {
    //
    //                        let dataOfAry = (tempPastData.object(at: i) as! NSDictionary)
    //
    //                        let strHistoryType = dataOfAry.object(forKey: "HistoryType") as? String
    //
    //                        if strHistoryType == "Past" {
    //                            self.aryCanceledRidesHistory?.add(dataOfAry)
    //                        }
    //                    }
    //
    //                    if(self.aryCanceledRidesHistory?.count == 0) {
    //                        //                        self.labelNoData.text = "No data found."
    //                        //                        self.tableView.isHidden = true
    //                    }
    //                    else {
    //                        //                        self.labelNoData.removeFromSuperview()
    //                        self.tableView.isHidden = false
    //                    }
    //
    //                    //                    self.getPostJobs()
    //                    self.refreshControl.endRefreshing()
    //                    self.tableView.reloadData()
    //
    //                    UtilityClass.hideACProgressHUD()
    //                }
    //            }
    //            else
    //            {
    //                //                UtilityClass.showAlertOfAPIResponse(param: result, vc: self)
    //            }
    //
    //        }
    //    }
    
}
