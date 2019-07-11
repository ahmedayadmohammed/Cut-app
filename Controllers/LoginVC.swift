//
//  ViewController.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import Lottie
class LoginVC: UIViewController {

    
    @IBOutlet weak var EMAILTXT: UITextField!
    @IBOutlet weak var PASSWORDTXT: UITextField!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var LOGINBUTTON: LoadingButton!
    
    
    
    
//    VARIABLES
    lazy var animationView = AnimationView(name: "196-material-wave-loading")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        LOGINBUTTON.layer.cornerRadius = 10
        LOGINBUTTON.addShadow()
        EmailView.layer.cornerRadius = 10
        PasswordView.layer.cornerRadius = 10
        PasswordView.addShadow()
        EmailView.addShadow()
        self.navigationController?.viewControllers.removeSubrange(Range(0...0))
        self.navigationController?.isToolbarHidden = true

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
      
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func keyboardWillChange(notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
                self.view.frame.origin.y = -keyboardHeight + 70
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }

    func animation(){
        
        animationView.animationSpeed = 1
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        animationView.center = self.view.center
        //self.view.addSubview(animationView)
        self.view.insertSubview(animationView, at: 2)
        animationView.play()
    }

    @IBAction func LOGINBUTTON(_ sender: LoadingButton) {
        if EMAILTXT.text == "" && PASSWORDTXT.text == "" {
            self.alert(title: "Empty fields", messsage:"Please write your Email and Password")
        }else if PASSWORDTXT.text == "" {
            self.alert(title: "Errro", messsage: "Please write your Password")
        } else if EMAILTXT.text == "" {
            self.alert(title: "Error", messsage: "Please write your Email")
        } else {
            sender.showLoading()
            LOGINMETHODE()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    
    
    
//    LOGIN FUNCTIONALITY WITH EMAIL AND THE PASSWORD FOR THE USER ...
    func LOGINMETHODE(){
        guard let email = EMAILTXT.text else {return}
        guard let password = PASSWORDTXT.text else {return}
        if email != "" && password != "" {
            let parameters:Parameters = ["name":email,"password":password]
            LoginUser(vc: self, Loading: LOGINBUTTON, url:get.root.LOGIN!, httpMethod: .post, parameters:parameters, headers:nil) { (rest:Swift.Result<Loginresponse,Error>?) in
                if let data = rest {
                    switch data{
                    case .success(let ok) :
                        self.LOGINBUTTON.hideLoading()
                            KeychainWrapper.standard.set(ok.token!, forKey: "token")
                            KeychainWrapper.standard.set(ok.type!, forKey: "type")
                        let HOMEVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(HOMEVC, animated: true)
                        
                    case .failure(let error) :
                        self.LOGINBUTTON.hideLoading()
                        self.alert(title: "خطأ", messsage: "\(error.localizedDescription)", buttonTitle: "OK", completion: {
                        self.LOGINBUTTON.hideLoading()
                        })
                        
                    default:
                        print("ANOTHER ERROR OCCURED WHILE LOGIN THE USER")
                         self.LOGINBUTTON.hideLoading()
                    }
                }
            }
        }
    }


}
