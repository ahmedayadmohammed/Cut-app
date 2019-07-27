//
//  AddSections.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/10/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class AddSections: UIViewController {

    @IBOutlet weak var SECTIONVIEW: UIView!
    @IBOutlet weak var SECTIONTXT: UITextField!
    @IBOutlet weak var ADDBUTTON: UIButton!
    
//    variables
    var token:HTTPHeaders?
    var parameter:Parameters = ["name":""]
    var myPOSITION = [Name]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         SECTIONVIEW.layer.cornerRadius = 10
         SECTIONVIEW.addShadow()
         ADDBUTTON.bindToKeyboard()
//         ADDBUTTON.layer.cornerRadius = 0
        token = ["Content-Type":"application/x-www-form-urlencoded","token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
    }
    
    @IBAction func ADDBUTTON(_ sender: Any) {
        if SECTIONTXT.text != ""{
            addsection()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (nil) in
                self.dismiss(animated: true, completion: nil)
            })

        } else {
            self.alert(title: "Empty Section name", messsage: "Please write the name of section")
        }
    }
    
    
    
    
//    THIS FUNCTION WILL ADD A SECTION TO THE TABLE-VIEW
    
    func addsection(){
        guard let name = SECTIONTXT.text else {return}
        self.parameter["name"] = name
        httpRequest(vc: self, url: get.root.ADD_SECTIONS!, httpMethod: .post, parameters: parameter, headers: self.token) {[weak self] (rest:Swift.Result<Errorresponse,Error>?) in
            if let output = rest{
                switch output{
                case .success(let ok):
                    self?.alert(title: "Message", messsage: ok.msg ?? "")
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {[weak self] (nil) in
                        self?.dismiss(animated: true, completion: nil)
                    })
                case.failure(let error):
                    print(error.localizedDescription)
                    self?.alert(title:"Error", messsage: "\(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    


}
