//
//  UpdateVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/18/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire

class UpdateVC: UIViewController {

//    OUTLETS
    @IBOutlet weak var NUMBEROFHOURS: UITextField!
    @IBOutlet weak var UPDATEBUTTON: LoadingButton!
    @IBOutlet weak var NUMBERVIEW: UIView!
    
//    VARIABLES
    var myvacation:Vication!
    var VID :String!
    var token:HTTPHeaders?
    var param:Parameters = ["vication_id":"0","numberOfHour":""]
    override func viewDidLoad() {
        super.viewDidLoad()
        VID = myvacation.id
        token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        UPDATEBUTTON.bindToKeyboard()
        UPDATEBUTTON.layer.cornerRadius = 0
    }
    

    
//    THIS WILL UPDATE THE VACATION BY NUMBER OF THE HOURS
    func UPDATEVACATION(){
        guard let hours = NUMBEROFHOURS.text else {return}
        self.param["numberOfHour"] = hours
        self.param["vication_id"] = VID
        httpRequest(vc: self, url:get.root.UPDATE_VACATION!, httpMethod: .post, parameters: self.param, headers: self.token) { (rest:Swift.Result<Errorresponse,Error>?) in
            if let output = rest {
                switch output {
                case.success(let ok):
                    self.UPDATEBUTTON.hideLoading()
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.alert(title: "Message", messsage: ok.msg ?? "")
                case.failure(let error):
                    self.UPDATEBUTTON.hideLoading()
                self.alert(title: "Message", messsage: "Sorry\(error.localizedDescription)")
                default:
                    print("there is some error while updating the vacations")
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
//    UPDATING VACATION BUTTON
    
    
    @IBAction func UPDATINGBUTTON(_ sender: LoadingButton) {
        guard let hours = NUMBEROFHOURS.text else {return}
        if hours != "" {
            sender.showLoading()
            UPDATEVACATION()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            self.alert(title: "Empty Fields", messsage: "Please write the number of hours")
        }
    }
    
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    

}
