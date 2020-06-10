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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        getAllCards()
    }
    
    @objc func handleSaveAsDefaulCard()
    {
        if let indexPath = selectedCardIndexPath
        {
            if let currentSelectedCard = self.arrayCardList?[indexPath.row] as NSDictionary?
            {
                if currentSelectedCard.object(forKey: "Id") as? String == "-1"
                {
                    SingletonClass.removeCurrentPaymentDetails()
                }else
                {
                    SingletonClass.setCurrentPaymentDetails(details: currentSelectedCard)
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddCardClickAction(_ sender: Any){
        let next = PaymentMethodStoryBoard.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}

extension PaymentMethodsViewController : AddCadsDelegate
{
    func didAddCard(cards: NSArray)
    {
        SingletonClass.sharedInstance.CardsVCHaveAryData.removeAll()
        self.getAllCards()
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
        cell.btnSelectedMethod.isHidden = false

        if indexPath.section == 0
        {
            if let cardDetails = SingletonClass.getCurrentPaymentDetails(), cardDetails.count > 0
            {
                cell.lblTitle.text = cardDetails["CardNum2"] as? String ?? ""
                cell.lblDescriptions.text = "Expires \(cardDetails["Expiry"] as? String ?? "")"
                cell.ImgViewIcon?.image = UIImage(named: UtilityClass.getCardImageNameFrom(type: cardDetails["Type"] as? String ?? ""))
                
            }else
            {
                cell.lblTitle.text = "Cash Payment".localized
                cell.lblDescriptions.text = "Deafult method".localized
                cell.ImgViewIcon.image = UIImage(named: "cash")
            }
            
        }else
        {
            cell.btnSelectedMethod.isHidden = true
            
            if let cardDetails = self.arrayCardList?[indexPath.row]
            {
                cell.lblTitle.text = cardDetails["CardNum2"] as? String ?? ""
                
                if let expiryDate = cardDetails["Expiry"] as? String
                {
                    cell.lblDescriptions.text = "Expires \(expiryDate)"
                }else
                {
                    cell.lblDescriptions.text = "Deafult method".localized
                }
                
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
            if self.arrayCardList?.count ?? 0 > 0
            {
                view.lblTitle.applyCustomTheme(title: "Choose desired vehicle type. We offer cars suitable for most every day needs.".localized, textColor: themeBlackColor, fontStyle: UIFont.regular(ofSize: 12))
            }else
            {
                view.lblTitle.text = ""
            }
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         
        if indexPath.section == 0
        {
            if SingletonClass.getCurrentPaymentDetails()?.count ?? 0 == 0
            {
                return false

            }else
            {
                return true
            }
        }else if let paymentMethodDetail = self.arrayCardList?[indexPath.row] as NSDictionary?, paymentMethodDetail.object(forKey: "Id") as? String == "-1"
        {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let alert = UIAlertController(title: "Remove".localized, message: "Are you sure you want to delete this card?".localized, preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "Yes".localized, style: .default, handler: { ACTION in
            
            if indexPath.section == 0
            {
                if let paymentMethodDetail = SingletonClass.getCurrentPaymentDetails() as NSDictionary?, let cardID = paymentMethodDetail.object(forKey: "Id") as? String
                {
                    self.removeCardFromWallet(cardId: cardID, isCurrentMethod: true)
                }
                
            }else
            {
                if let paymentMethodDetail = self.arrayCardList?[indexPath.row] as NSDictionary?, let cardID = paymentMethodDetail.object(forKey: "Id") as? String
                {
                   self.removeCardFromWallet(cardId: cardID)
                }
            }
        })
        
        let Cancel = UIAlertAction(title: "No".localized, style: .destructive, handler: nil)
        alert.addAction(OK)
        alert.addAction(Cancel)
        alert.modalPresentationStyle  = .overCurrentContext
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
}

// MARK: - Webservice Methods

extension PaymentMethodsViewController
{
    func getAllCards() {
        
        if let cardList = SingletonClass.sharedInstance.CardsVCHaveAryData as [[String : AnyObject]]? , cardList.count > 0
        {
            self.filterData(arrayCardList: cardList)
            
        }else
        {
            webserviceForCardList(SingletonClass.sharedInstance.strPassengerID as AnyObject) { (result, status) in
                
                if (status)
                {
                    if let cardList = (result as? NSDictionary)?.object(forKey: "cards") as? [[String:AnyObject]]
                    {
                        SingletonClass.sharedInstance.CardsVCHaveAryData = cardList
                        self.filterData(arrayCardList: cardList)
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
    
    func filterData(arrayCardList : [[String : AnyObject]]) {
     
        if let dicCardDetails = SingletonClass.getCurrentPaymentDetails(), dicCardDetails.count > 0
        {
            if let resultsFilter = arrayCardList.filter({ $0["Id"] as? String != dicCardDetails.object(forKey: "Id") as? String}) as [[String:AnyObject]]?
            {
                self.arrayCardList = resultsFilter
                let cashPayment = NSMutableDictionary()
                cashPayment.setValue("Cash Payment", forKey: "CardNum2")
                cashPayment.setValue("cash", forKey: "Type")
                cashPayment.setValue("-1", forKey: "Id")
                self.arrayCardList?.insert(cashPayment as! [String : AnyObject], at: 0)
                self.tableView.reloadData()
            }
            
        }else
        {
            self.arrayCardList = arrayCardList
            self.tableView.reloadData()
        }
    }
    
    
    func removeCardFromWallet(cardId : String, isCurrentMethod : Bool = false)
    {
        let params = "\(SingletonClass.sharedInstance.strPassengerID)/\(cardId)"
        webserviceForRemoveCard(params as AnyObject) { (result, status) in
            
            if (status)
            {
                if let cardList = (result as? NSDictionary)?.object(forKey: "cards") as? [[String:AnyObject]]
                {
                    if isCurrentMethod
                    {
                        SingletonClass.removeCurrentPaymentDetails()
                    }
                    SingletonClass.sharedInstance.CardsVCHaveAryData = cardList
                    self.filterData(arrayCardList: cardList)
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

    
