//
//  EditTaskVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SearchTextField

class EditTaskVC: UIViewController {
    @IBOutlet weak var TASKNAMELABEL: UILabel!
    @IBOutlet weak var EMPLOYENAMETXT: SearchTextField!
    @IBOutlet weak var TASKDATETXT: UITextField!
    @IBOutlet weak var EDITBUTTON: LoadingButton!
    @IBOutlet weak var EDITTASKBUTTON: UIButton!
    @IBOutlet weak var DEADLINE: UITextField!
    
    //    VIEWS
    @IBOutlet weak var TASKNAMEVIEW: UIView!
    @IBOutlet weak var EMPLOYENAMEVIEW: UIView!
    @IBOutlet weak var TASKDATEVIEW: UIView!
    var TASKDETAIL : All?
    var TASKID :String!
    var EMID:String!
    var header:HTTPHeaders = [:]
    var token:HTTPHeaders!
    let datePicker = UIDatePicker()
    var prameters:Parameters = ["name":"","employee_id": "0","task_id" : "0","_id" : ""]
    var parameters : Parameters!

    override func viewDidLoad() {
        super.viewDidLoad()
        EDITTASKBUTTON.layer.cornerRadius = 5
        showDatePicker()
        Startdatepicker()
        TASKNAMELABEL.text = TASKDETAIL?.name
        TASKID = TASKDETAIL?.id
        EMID = TASKDETAIL?.employeeID.id
        TASKNAMEVIEW.layer.cornerRadius = 10
        EMPLOYENAMEVIEW.layer.cornerRadius = 10
        TASKDATEVIEW.layer.cornerRadius = 10
//        token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        token = ["Content-Type":"application/x-www-form-urlencoded","token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        print(TASKID)
        print(EMID)
        EMPLOYENAMETXT.textAlignment = .left
        EMPLOYENAMETXT.tag = 0
        EMPLOYENAMETXT.delegate = self
//        ---------------------------
        EMPLOYENAMETXT.getSug(vc: self, url: get.root.ID_AND_NAMES!, parameters: nil, header: self.token) { (names) in
            self.EMPLOYENAMETXT.itemSelectionHandler(sugs: names, completionHandler: { (id) in
                self.EMPLOYENAMETXT.tag = 1
                self.parameters=["employee_id":id]
                 self.EMID = id
            })
        }
        
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
 
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EDITBUTTONPRESSED(_ sender: LoadingButton) {
        sender.showLoading()
        UPDATETASKS()
        
    }
    
    
//    DEADLINE-PICKERVIEW
    func Startdatepicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        //ToolBar
        let toolbar2 = UIToolbar();
        toolbar2.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(Enddatepicker));
        toolbar2.setItems([doneButton], animated: false)
        DEADLINE.inputAccessoryView = toolbar2
        DEADLINE.inputView = datePicker
    }
    @objc func Enddatepicker(){
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "E, MMM d, yyyy h:mm a"
        DEADLINE.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    
//    START-DATE-PICKERVIEW
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        toolbar.setItems([doneButton], animated: false)
        TASKDATETXT.inputAccessoryView = toolbar
        TASKDATETXT.inputView = datePicker
    }
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "E, MMM d, yyyy h:mm a"
        TASKDATETXT.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    func UPDATETASKS(){
        guard let date = TASKDATETXT.text else {return}
        guard let DEADLINE = DEADLINE.text else {return}
        guard let taskid = TASKID else {return}
        self.parameters["task_start"] = date
        self.parameters["deadline"] = DEADLINE
        self.parameters["task_id"] = taskid
        print(parameters)
        LoginUser(vc: self, Loading: EDITBUTTON, url: get.root.TASK_UPDATE!, httpMethod:.post, parameters:self.parameters , headers: self.token) { (rest:Swift.Result<Errorresponse,Error>?) in
            if let data = rest {
                switch data {
                case .success(let ok) :
                    self.EDITBUTTON.hideLoading()
                    self.alert(title: "Updating successfull", messsage: "\(ok.msg ?? "")")
                case .failure(let error):
                    print(error.localizedDescription)
                    self.EDITBUTTON.hideLoading()
                }
            }else{
                print("there is some error while updating the tasks")
            }
        }
    }

}


extension EditTaskVC : UITextFieldDelegate{
    
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
        if textField == EMPLOYENAMETXT {
            EMPLOYENAMETXT.startVisibleWithoutInteraction = true
        }else{
            EMPLOYENAMETXT.startVisibleWithoutInteraction = false
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

