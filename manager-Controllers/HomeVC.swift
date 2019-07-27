//
//  HomeVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import OneSignal

class HomeVC: UITableViewController {

    @IBOutlet weak var ADDPERSONVIEW: UIView!
    @IBOutlet weak var TASKSVIEW: UIView!
    @IBOutlet weak var REVIEWVIEW: UIView!
    @IBOutlet weak var LOGOUTVIEW: UIView!
    @IBOutlet weak var SectionView: UIView!
    @IBOutlet weak var VACATIONVIEW: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserID()
        ADDPERSONVIEW.layer.cornerRadius = 10
        ADDPERSONVIEW.addShadow()
        TASKSVIEW.layer.cornerRadius = 10
        TASKSVIEW.addShadow()
        REVIEWVIEW.layer.cornerRadius = 10
        REVIEWVIEW.addShadow()
        LOGOUTVIEW.layer.cornerRadius = 10
        LOGOUTVIEW.addShadow()
        SectionView.layer.cornerRadius = 10
        SectionView.addShadow()
        VACATIONVIEW.layer.cornerRadius = 10
        VACATIONVIEW.addShadow()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.viewControllers.removeSubrange(Range(0...0))
       

        
    }
    
    func getuserID(){
        let status:OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userID = status.subscriptionStatus.userId
        print("THIS IS USER IDDDDDD\(userID?.description)")
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
    
  
    @IBAction func SECTIONSBUTTON(_ sender: Any) {
        
        let SECTION = storyboard?.instantiateViewController(withIdentifier: "SectionsVC") as! SectionsVC
        self.present(SECTION, animated: true, completion: nil)
    }
    

    @IBAction func ADDPERSONBUTTON(_ sender: Any) {
        
        let PERSONVC = storyboard?.instantiateViewController(withIdentifier: "EployeeVC") as! EmployeVC
        self.present(PERSONVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func TASKSBUTTON(_ sender: Any) {
        let TASKVC = storyboard?.instantiateViewController(withIdentifier: "TaskVC") as! TaskVC
        self.present(TASKVC, animated: true, completion: nil)
        
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
 
    @IBAction func REVIEWBUTTON(_ sender: Any) {
        let RVC = storyboard?.instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
        self.present(RVC, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func VACATIONSBUTTON(_ sender: Any) {
        let VVC = storyboard?.instantiateViewController(withIdentifier: "VacationsVC") as! VacationsVC
        self.present(VVC, animated: true, completion: nil)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // animation 1
        
         let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 0)
         cell.layer.transform = rotationTransform
         cell.alpha = 0.5
         
         UIView.animate(withDuration: 1.0) {
         cell.layer.transform = CATransform3DIdentity
         cell.alpha = 1.0
         }
        
    }

    
    
    

}
