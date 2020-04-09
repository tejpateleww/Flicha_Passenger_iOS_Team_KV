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
//        perform(#selector(GoFurther), with: nil, afterDelay: 0.5)
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(GoFurther), object: nil)
        
//        self.perform(#selector(self.GoFurther), with: nil, afterDelay: 1.0)
        self.GoFurther()
//        self.webserviceOfAppSetting()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func GoFurther(){
        if(SingletonClass.sharedInstance.isUserLoggedIN)
        {
            appDel.GoToHome()
        }
        else {
            appDel.GoToLogin()
        }
    }
    
        func webserviceOfAppSetting() {
    //        version : 1.0.0 , (app_type : AndroidPassenger , AndroidDriver , IOSPassenger , IOSDriver)

            let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
            let version = nsObject as! String
            
            print("Vewsion : \(version)")
            
            var param = String()
            param = version + "/" + "IOSPassenger"
            webserviceForAppSetting(param as AnyObject) { (result, status) in
                
                if (status) {
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
                        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { ACTION in
                            
                            if(SingletonClass.sharedInstance.isUserLoggedIN)
                            {
                                appDel.GoToHome()
    //                            self.webserviceForAllDrivers()
//                                self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                            }
                            else {
                                appDel.GoToLogin()
                            }
                        })
                        alert.addAction(UPDATE)
                        alert.addAction(Cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        
                        if(SingletonClass.sharedInstance.isUserLoggedIN) {
                            appDel.GoToHome()
//                            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                        }
                        else {
                            appDel.GoToLogin()
                        }
                    }
                }
                else {
                    print(result)

                    if let update = (result as! NSDictionary).object(forKey: "update") as? Bool {
                        
                        if (update) {

                            UtilityClass.showAlertWithCompletion("", message: (result as! NSDictionary).object(forKey: "message") as! String, vc: self, completionHandler: { ACTION in
                                
                                guard let url = URL(string: "itms-apps://itunes.apple.com/app/id1445179460") else {
                                    return //be safe
                                }
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            })
                        }
                        else {
                            
                            if(SingletonClass.sharedInstance.isUserLoggedIN) {
                                                        appDel.GoToHome()
                            //                            self.performSegue(withIdentifier: "segueToHomeVC", sender: nil)
                            }
                            else {
                                    appDel.GoToLogin()
                            }
                            
                            /*
                             UtilityClass.setCustomAlert(title: "Error", message: (result as! NSDictionary).object(forKey: "message") as! String) { (index, title) in
                                if (index == 0)
                                {
                                    UIApplication.shared.open((NSURL(string: "itms-apps://itunes.apple.com/app/id1445179460")! as URL), options: [:], completionHandler: { (status) in
                                        
                                    })
                                }
                            }
                            */

                        }
                        
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
}
