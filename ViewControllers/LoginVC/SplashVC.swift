//
//  SplashVC.swift
//  Flicha User
//
//  Created by EWW082 on 01/04/20.
//  Copyright © 2020 Excellent Webworld. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.GoFurther()
        self.webserviceOfAppSetting()
    }
    
    @objc func GoFurther()
    {
        if(SingletonClass.sharedInstance.isUserLoggedIN)
        {
            appDel.GoToHome()
        }
        else
        {
            appDel.GoToLogin()
        }
    }
    
    func webserviceOfAppSetting()
    {
        //        version : 1.0.0 , (app_type : AndroidPassenger , AndroidDriver , IOSPassenger , IOSDriver)
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
        print("Vewsion : \(version)")
        var param = String()
        param = version + "/" + "IOSPassenger"
        
        webserviceForAppSetting(param as AnyObject) { (result, status) in
            
            if (status)
            {
                print("result is : \(result)")
                SingletonClass.sharedInstance.arrCarLists = NSMutableArray(array: (result as! NSDictionary).object(forKey: "car_class") as! NSArray)
                
                //                self.viewMain.isHidden = false
                
                if ((result as! NSDictionary).object(forKey: "update") as? Bool) != nil {
                    
                    let alert = UIAlertController(title: nil, message: (result as! NSDictionary).object(forKey: "message") as? String, preferredStyle: .alert)
                    let UPDATE = UIAlertAction(title: "UPDATE", style: .default, handler: { ACTION in
                        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id1445179460") else {
                            return //be safe
                        }
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                        
                    })
                    let Cancel = UIAlertAction(title: "Cancel".localized, style: .default, handler: { ACTION in
                        self.GoFurther()
                    })
                    alert.addAction(UPDATE)
                    alert.addAction(Cancel)
                    alert.modalPresentationStyle  = .overCurrentContext
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    self.GoFurther()
                }
            }
            else
            {
                self.GoFurther()
            }
            /*
             if let res = result as? String {
             UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in
             }
             }
             else if let resDict = result as? NSDictionary {
             
             UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in
             }
             }
             else if let resAry = result as? NSArray {
             
             UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
             }
             }
             */
        }
    }
    
}
