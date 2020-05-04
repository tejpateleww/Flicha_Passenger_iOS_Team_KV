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
    private var isCardSelected : IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView()
    {
        self.addCustomNavigationBar(title: kPaymentMethodsPageTitle)
        self.btnAddCard.setTitle(kAddCard, for: .normal)
        self.tableView.register(UINib(nibName: "SavedCardDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: CellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addCustomNavigationBar(title: kPaymentMethodsPageTitle)
        getAllCards()
    }
    
    @IBAction func btnAddCardClickAction(_ sender: Any)
    {
        let next = PaymentMethodStoryBoard.instantiateViewController(withIdentifier: "WalletAddCardsViewController") as! WalletAddCardsViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}

extension PaymentMethodsViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
            
        }else
        {
            return self.arrayCardList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! SavedCardDetailsTableViewCell
        
        if indexPath.section == 0
        {
            cell.btnSelectedMethod.isHidden = false
            cell.lblTitle.text = "Cash Payment"
            cell.lblDescriptions.text = "Deafult method"
            cell.ImgViewIcon.image = UIImage(named: "cash")
            
        }else
        {
            cell.btnSelectedMethod.isHidden = true

            if let cardDetails = self.arrayCardList?[indexPath.row]
            {
                cell.lblTitle.text = cardDetails["CardNum2"] as? String ?? ""
                cell.lblDescriptions.text = cardDetails["Expiry"] as? String ?? ""
                cell.imageView?.image = UIImage(named: UtilityClass.getCardImageNameFrom(type: cardDetails["Type"] as? String ?? ""))
            }
            
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.white
        let labelView: UILabel = UILabel.init(frame: CGRect.init(x: 16, y: 8, width: headerView.frame.size.width - 32, height: 0))
        labelView.numberOfLines = 0
        
        if section == 0
        {
            labelView.text = "Current Payment"

        }else
        {
            labelView.text = "Choose desired vehicle type. We offer cars suitable for most every day needs."
        }
        headerView.addSubview(labelView)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //self.isCardSelected = indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        50
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

    
