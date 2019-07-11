//
//  SplashVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginWithToken()
     
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear


    }
    

    
    
    
    
    
    
    //    THIS WILL HANDLE THE VALIDATION OF THE USER....
    
    func LoginWithToken(){
        let data = KeychainWrapper.standard.string(forKey: "token")
        let typeAccount = KeychainWrapper.standard.string(forKey: "type")
        print(data)
        if let token = data{
            if token != "" {
                if let type = typeAccount {
                    if type == "1"{
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
                            
                            let HOMEVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            self.navigationController?.pushViewController(HOMEVC, animated: true)
                        }
                    }else{
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
                            
                            let HOMEVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            self.navigationController?.pushViewController(HOMEVC, animated: true)
                        }
                    }
                }
                
            }
            
        }else{
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
                let LoginC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(LoginC, animated: true)
            }
            
        }
        
    }
    
    
    
    
    
    
    
}










