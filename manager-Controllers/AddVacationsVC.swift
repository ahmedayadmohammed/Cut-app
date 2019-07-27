//
//  AddVacationsVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/18/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import SearchTextField

class AddVacationsVC: UIViewController {

//    OUTLETS
    
    @IBOutlet weak var VACATIONNAME: UITextField!
    @IBOutlet weak var NUBMEROFHOURS: UITextField!
    @IBOutlet weak var ADDBUTTON: LoadingButton!
    @IBOutlet weak var VACATIONLIMIT: SearchTextField!
    //    VIEWS
    
    @IBOutlet weak var VACATIONNAMEVIEW: UIView!
    @IBOutlet weak var NUMBERVIEW: UIView!
    @IBOutlet weak var VACATIONLIMITVIEW: UIView!
    
//    VARIABLES
    var token:HTTPHeaders?
    var paramter:Parameters = ["name":"","numberOfHour":"","set_time":"0"]
    override func viewDidLoad() {
        super.viewDidLoad()
        VACATIONNAMEVIEW.layer.cornerRadius = 10
        NUMBERVIEW.layer.cornerRadius = 10
        VACATIONLIMITVIEW.layer.cornerRadius = 10
        ADDBUTTON.layer.cornerRadius = 10
        token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        VACATIONLIMIT.delegate = self
        VACATIONLIMIT.tag = 0
        EMsuggestions()

    }

    
//    getset-functions
    func EMsuggestions(){
        VACATIONLIMIT.getSug(vc: self, url: get.root.VACATIONS_GET_SET!, parameters: nil, header:self.token) {  [weak self](names) in
            self?.VACATIONLIMIT.itemSelectionHandler(sugs: names, completionHandler: { (id) in
                self?.VACATIONLIMIT.tag = 1
                self?.paramter["set_time"] = id
                print("this is vacationid \(id)")
            })
        }
    }
    
    
    
    func ADDVACATIONS(){
        guard let name =  VACATIONNAME.text else {return}
        guard let hours = NUBMEROFHOURS.text else {return}
        self.paramter["name"] = name
        self.paramter["numberOfHour"] = hours
       
        httpRequest(vc: self, url: get.root.ADD_VACATION!, httpMethod: .post, parameters: self.paramter, headers: self.token) { (rest:Swift.Result<Errorresponse,Error>?) in
            if let output = rest {
                switch output{
                case.success(let ok):
                    self.ADDBUTTON.hideLoading()
                    self.alert(title: "Added successfully", messsage: "\(ok.msg)")
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
                        self.dismiss(animated: true, completion: nil)
                    }
                case.failure(let error):
                    self.alert(title:"Error", messsage: "\(error.localizedDescription)")
                    self.ADDBUTTON.hideLoading()

                default:
                 print("there is some error while adding the vacations")
                }
            }
        }
    }
    
    
    
    
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func ADDINGBUTTON(_ sender: LoadingButton) {
        
        guard let name  = VACATIONNAME.text else {return}
        guard let hours  = NUBMEROFHOURS.text else {return}
        if name != "" && hours != "" && VACATIONLIMIT.text != "" {
            sender.showLoading()
            self.ADDVACATIONS()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
                self.dismiss(animated: true, completion: nil)
            }
        }
        else{
            self.alert(title: "Empty fields", messsage: "Please fill the empty fields")
//            sender.hideLoading()
        }
        
    }
    
    

}







extension AddVacationsVC : UITextFieldDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.clearButtonMode = .never
        textField.becomeFirstResponder()
        textField.text?.removeAll()
        textField.tag = 0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == VACATIONLIMIT {
            VACATIONLIMIT.startVisibleWithoutInteraction = true
        }else{
            VACATIONLIMIT.startVisibleWithoutInteraction = false
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.clearButtonMode == .always {
            return false
        }else{
            return true
        }
    }
    
}
