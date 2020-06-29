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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.addCustomNavigationBar(title: "Help")
        // Do any additional setup after loading the view.
    }

}

extension FaqVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqTableViewCell", for: indexPath) as! FaqTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
