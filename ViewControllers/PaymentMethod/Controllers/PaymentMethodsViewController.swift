//
//  PaymentMethodsViewController.swift
//  Flicha User
//
//  Created by Mehul Panchal on 13/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class PaymentMethodsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddCard: ThemeButton!
    
    private var arrayCardList : [[String:AnyObject]]?
    private let CellID = "SavedCardDetailsTableViewCell"
    private let HeaderID = "UniversalHeaderView"

    private var selectedCardIndexPath : IndexPath?
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView()
    {
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle("Done".localized, for: .normal)
        rightButton.addTarget(self, action: #selector(self.handleSaveAsDefaulCard), for: .touchUpInside)
        
        self.addCustomNavigationBarWithRightButton(title: kPaymentMethodsPageTitle, rightBarButton: rightButton)
        self.btnAddCard.setTitle(kAddCard, for: .normal)
        
        self.tableView.register(UINib(nibName: "SavedCardDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: CellID)
        self.tableView.register(UINib(nibName: "UniversalHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier:HeaderID)
        
        //self.tableView.estimatedRowHeight = 80
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 80
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllCards()
    }
    
    @objc func handleSaveAsDefaulCard(){
        
    }
    
    @IBAction func btnAddCardClickAction(_ sender: Any){
        let next = PaymentMethodStoryBoard.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}

extension PaymentMethodsViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 0
        {
            return 1
        }else
        {
            return self.arrayCardList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! SavedCardDetailsTableViewCell
        
        if indexPath.section == 0
        {
            if self.selectedCardIndexPath == nil
            {
                cell.btnSelectedMethod.isHidden = false
            }else
            {
                cell.btnSelectedMethod.isHidden = true
            }

            cell.lblTitle.text = "Cash Payment"
            cell.lblDescriptions.text = "Deafult method"
            cell.ImgViewIcon.image = UIImage(named: "cash")
            
        }else
        {
            cell.btnSelectedMethod.isHidden = true

            if let cardDetails = self.arrayCardList?[indexPath.row]
            {
                cell.lblTitle.text = cardDetails["CardNum2"] as? String ?? ""
                cell.lblDescriptions.text = "Expires \(cardDetails["Expiry"] as? String ?? "")"
                cell.ImgViewIcon?.image = UIImage(named: UtilityClass.getCardImageNameFrom(type: cardDetails["Type"] as? String ?? ""))
                
                if self.selectedCardIndexPath == indexPath
                {
                    cell.containerView.borderColor = UIColor.red
                    cell.containerView.borderWidth = 1
                }else
                {
                    cell.containerView.borderColor = UIColor.clear
                    cell.containerView.borderWidth = 0
                }
            }
        }

        return cell
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderID) as! UniversalHeaderView
        if section == 0
        {
            view.lblTitle.applyCustomTheme(title: "CURRENT METHOD", textColor: themeLightGreyColor, fontStyle: UIFont.semiBold(ofSize: 12))

        }else
        {
            view.lblTitle.applyCustomTheme(title: "Choose desired vehicle type. We offer cars suitable for most every day needs.".localized, textColor: themeBlackColor, fontStyle: UIFont.regular(ofSize: 12))
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.selectedCardIndexPath == indexPath || indexPath.section == 0
        {
            self.selectedCardIndexPath = nil
        }else
        {
            self.selectedCardIndexPath = indexPath
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
}

// MARK: - Webservice Methods

extension PaymentMethodsViewController
{
    func getAllCards() {
        
        webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
            
            if (status)
            {
                if let cardList = (result as? NSDictionary)?.object(forKey: "cards") as? [[String:AnyObject]], cardList.count > 0
                {
                    self.arrayCardList = cardList
                    SingletonClass.sharedInstance.CardsVCHaveAryData = cardList
                    SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false
                    self.tableView.reloadData()
                }
            }
            else
            {
                if let res = result as? String
                {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary
                {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray
                {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
    func removeCardFromWallet(cardId : String) {
        
        let params = "\(SingletonClass.sharedInstance.strPassengerID)/\(cardId)"
        webserviceForRemoveCard(params as AnyObject) { (result, status) in
            
            if (status)
            {
                if let cardList = (result as? NSDictionary)?.object(forKey: "cards") as? [[String:AnyObject]]
                {
                    self.arrayCardList = cardList
                    SingletonClass.sharedInstance.CardsVCHaveAryData = cardList
                    SingletonClass.sharedInstance.isCardsVCFirstTimeLoad = false
                    self.tableView.reloadData()
                    
                    UtilityClass.setCustomAlert(title: "Removed", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
            else
            {
                if let res = result as? String
                {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
                    }
                }
                else if let resDict = result as? NSDictionary
                {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
                    }
                }
                else if let resAry = result as? NSArray
                {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                    }
                }
            }
        }
    }
    
}

    
