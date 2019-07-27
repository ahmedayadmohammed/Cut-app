//
//  EMVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/18/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import OneSignal

class EMVC: UITableViewController {

    @IBOutlet weak var PROFILEVIEW: UIView!
    @IBOutlet weak var TASKSVIEW: UIView!
    @IBOutlet weak var VACATIONVIEW: UIView!
    @IBOutlet weak var LOGOUTVIEW: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserID()
        PROFILEVIEW.layer.cornerRadius = 10
        PROFILEVIEW.addShadow()
        TASKSVIEW.layer.cornerRadius = 10
        TASKSVIEW.addShadow()
        VACATIONVIEW.layer.cornerRadius = 10
        VACATIONVIEW.addShadow()
        LOGOUTVIEW.layer.cornerRadius = 10
        LOGOUTVIEW.addShadow()
        self.navigationController?.viewControllers.removeSubrange(Range(0...0))
}
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    func getuserID(){
        let status:OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userID = status.subscriptionStatus.userId
        print("THIS IS USER IDDDDDD\(userID?.description)")
    }
    
    
    @IBAction func LOGOUTBUTTON(_ sender: Any) {
        let alertController = UIAlertController(title: "Log out", message: "Are you sure want to log out", preferredStyle: .alert)
        
        let withdrawAction = UIAlertAction(title: "Logout", style: .default) { (aciton) in
            
            KeychainWrapper.standard.removeObject(forKey: "token")
            KeychainWrapper.standard.removeObject(forKey: "type")

            print("successfully signed out")
            let LoginC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(LoginC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("canceled")
        }
        
        alertController.addAction(withdrawAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func TASKSBUTTON(_ sender: Any) {
        let TASKS = storyboard?.instantiateViewController(withIdentifier: "EmpTASK") as! EmpTASK
        self.present(TASKS, animated: true, completion: nil)
    }
    
    @IBAction func VACATIONBUTTON(_ sender: Any) {
        let VAC = storyboard?.instantiateViewController(withIdentifier: "EMvacationVC") as! EMvacationVC
        self.present(VAC, animated: true, completion: nil)
    }
    
    
    @IBAction func PROFILE_BUTTON(_ sender: Any) {
        
        let PRO = storyboard?.instantiateViewController(withIdentifier: "EmProfileVC") as! EmProfileVC
        self.present(PRO, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
}
