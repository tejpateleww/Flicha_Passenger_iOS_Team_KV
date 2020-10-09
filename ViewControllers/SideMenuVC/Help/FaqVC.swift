//
//  FaqVC.swift
//  Flicha User
//
//  Created by EWW074 on 16/06/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class FaqVC: BaseViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var faqArray : [FaqModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

         wscall()
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.addCustomNavigationBar(title: "Help".localized)
        // Do any additional setup after loading the view.
    }
    
    func wscall() {
           let  paramer: [String: Any] = [:]
           
           WebserviceForFAQList(paramer as AnyObject) { (result, status) in
               print(result)
               
               let data = (result as! [String:Any])["data"] as! [[String : Any]]
               
               data.forEach { (dict) in
                   let newModal = FaqModel(dict: dict)
                   self.faqArray.append(newModal)
               }
               
               print(self.faqArray)
               self.tblView.reloadData()
               
           }
       }

}

extension FaqVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTableViewCell", for: indexPath) as! FaqTableViewCell
        
        let currentRowDict = faqArray[indexPath.row]
        cell.lbl_Question.text = currentRowDict.que
        cell.lbl_Answer.text = currentRowDict.ans
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


struct FaqModel {
    
    var id : String = ""
    var userType : String = ""
    var que : String = ""
    var ans : String = ""
    
    init(dict : [String : Any]) {
        
        self.id = dict["Id"] as! String
        self.userType = dict["UserType"] as! String
        self.que = dict["Question"] as! String
        self.ans = dict["Answer"] as! String
    }
}
