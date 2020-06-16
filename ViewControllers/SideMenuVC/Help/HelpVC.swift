//
//  HelpVC.swift
//  Flicha User
//
//  Created by EWW074 on 16/06/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class HelpVC: BaseViewController {

    @IBOutlet weak var tblview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.addCustomNavigationBar(title: "Help")
    }

}

extension HelpVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpTableViewCell", for: indexPath) as! HelpTableViewCell
        
        cell.containerView.layer.cornerRadius = cell.containerView.frame.height / 2
        cell.containerView.borderWidth = 0.5
        cell.containerView.borderColor = .lightGray
        cell.containerView.shadowColor = .black
        cell.containerView.shadowOffset = .zero
        cell.containerView.shadowOpacity = 0.3
        cell.containerView.shadowRadius = 3
        
//        cell.lbl_Question.text = somearr[indexpath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
}
