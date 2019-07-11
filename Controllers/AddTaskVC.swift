//
//  AddTaskVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SearchTextField

class AddTaskVC: UIViewController {
    
    @IBOutlet weak var ADDTASKTXT: UITextField!
    @IBOutlet weak var ADDBUTTON: LoadingButton!
    @IBOutlet weak var EMPLOYENAME: SearchTextField!
    @IBOutlet weak var TASKDATE: UITextField!
    @IBOutlet weak var ENDDATE: UITextField!
    //    VIEWES
    
    @IBOutlet weak var TASKNAMEVIEW: UIView!
    @IBOutlet weak var EMPLOYENAMEVIEW: UIView!
    @IBOutlet weak var TASKDATEVIEW: UIView!
   
    let datePicker = UIDatePicker()
    var token:HTTPHeaders?
//    var prameters:Parameters!
    var prameters:Parameters = ["name":"","employee_id": "0","task_start":"","deadline":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Startdatepicker()
        TASKNAMEVIEW.layer.cornerRadius = 10
        EMPLOYENAMEVIEW.layer.cornerRadius = 10
        TASKDATEVIEW.layer.cornerRadius = 10
        ADDBUTTON.layer.cornerRadius = 10
        
//        token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        token = ["Content-Type":"application/x-www-form-urlencoded","token":KeychainWrapper.standard.string(forKey: "token") ?? ""]

        EMPLOYENAME.textAlignment = .left
        EMPLOYENAME.tag = 0
        EMPLOYENAME.delegate = self
        showDatePicker()
        
                EMPLOYENAME.getSug(vc: self, url: get.root.ID_AND_NAMES!, parameters: nil, header:self.token) { (names) in
            self.EMPLOYENAME.itemSelectionHandler(sugs: names, completionHandler: { (id) in
                self.EMPLOYENAME.tag = 1
                self.prameters["employee_id"] = id
                print("this is employee id \(id)")
            })
        }
        
        
        
        
        
        
        //        -------------------
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
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
                self.view.frame.origin.y = -keyboardHeight + 200
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }
    
//    END-DATE-PICKER
    func Startdatepicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        //ToolBar
        let toolbar2 = UIToolbar();
        toolbar2.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(Enddatepicker));
        toolbar2.setItems([doneButton], animated: false)
        ENDDATE.inputAccessoryView = toolbar2
        ENDDATE.inputView = datePicker
    }
    @objc func Enddatepicker(){
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy"
        ENDDATE.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    

    
    
    
//    START-DATE-PICKER
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        toolbar.setItems([doneButton], animated: false)
        TASKDATE.inputAccessoryView = toolbar
        TASKDATE.inputView = datePicker
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy"
        TASKDATE.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func ADDBUTTONPRESSED(_ sender: LoadingButton) {
        guard let taskname = ADDTASKTXT.text else {return}
        guard let taskdate = TASKDATE.text else {return}
        if taskname != "" && taskdate != "" {
            sender.showLoading()
            ADDTASK()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (nil) in
                self.dismiss(animated: true, completion: nil)
            }
            }else{
            self.alert(title: "error", messsage: "please fill the fields")
        }
        
        }
    
    func ADDTASK(){
        
        guard let name = ADDTASKTXT.text else {return}
        guard let start = TASKDATE.text else {return}
        guard let endtime = ENDDATE.text else {return}
        
        self.prameters["name"] = name
        self.prameters["task_start"] = start
        self.prameters["deadline"] = endtime
        
        LoginUser(vc: self, Loading: ADDBUTTON, url: get.root.ADD_TASK!, httpMethod: .post, parameters: self.prameters, headers: self.token) { (rest:Swift.Result<Errorresponse,Error>?) in
            if let output = rest{
                switch output{
                case .success(let ok):
                    self.ADDBUTTON.hideLoading()
                    self.dismiss(animated: true, completion: nil)
                    print(ok.msg)
                self.alert(title: "Task added", messsage: "\(ok.msg?.description)")
                case .failure(let error):
                    self.ADDBUTTON.hideLoading()
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
    }

    
    }
    

    

extension AddTaskVC : UITextFieldDelegate{
    
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
        if textField == EMPLOYENAME {
            EMPLOYENAME.startVisibleWithoutInteraction = true
        }else{
            EMPLOYENAME.startVisibleWithoutInteraction = false
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
