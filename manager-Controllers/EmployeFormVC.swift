//
//  EmployeFormVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SearchTextField
import Photos

class EmployeFormVC: UIViewController,UINavigationControllerDelegate {
    @IBOutlet weak var EMPLOYEIMAGE: UIImageView!
    @IBOutlet weak var USERNAMETXT: UITextField!
    @IBOutlet weak var PHONENUMBERTXT: UITextField!
    @IBOutlet weak var EMAILTXT: UITextField!
    @IBOutlet weak var LOCATIONTXT: UITextField!
    @IBOutlet weak var POSTIONTXT: SearchTextField!
    @IBOutlet weak var LEVELTXT: UITextField!
    @IBOutlet weak var PASSWORD: UITextField!
    @IBOutlet weak var PASSWORDVIEW: UIView!
    @IBOutlet weak var LEVELVIEW: UIView!
    @IBOutlet weak var ADDBUTTONPROFILE: UIButton!
    //    VIEWES
    @IBOutlet weak var USERNAMEVIEW: UIView!
    @IBOutlet weak var PHONEVIEW: UIView!
    @IBOutlet weak var EMAILVIEW: UIView!
    @IBOutlet weak var LOCATIONVIEW: UIView!
    @IBOutlet weak var POSTIONVIEW: UIView!
    //    VARIABLES
    var token:[String:String]?
    var imagepicker:UIImagePickerController!
    lazy var advicePicker  = UIPickerView()
    let multiformdata=MultipartFormData()
    lazy var LEVEL = ["","1","2","3"]
    var parameter:[String:String]!


    override func viewDidLoad() {
        super.viewDidLoad()
        SHOWLEVELPICKER()
        createToolBar()
        USERNAMEVIEW.layer.cornerRadius = 10
        PASSWORDVIEW.layer.cornerRadius = 10
        LEVELVIEW.layer.cornerRadius = 10
        PHONEVIEW.layer.cornerRadius = 10
        EMAILVIEW.layer.cornerRadius = 10
        POSTIONVIEW.layer.cornerRadius = 10
        LOCATIONVIEW.layer.cornerRadius = 10
//        ADDBUTTON.layer.cornerRadius = 10
        EMPLOYEIMAGE.addShadow()
        imagepicker=UIImagePickerController()
        imagepicker.delegate=self
        token = ["Content-Type":"application/x-www-form-urlencoded","token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        POSTIONTXT.textAlignment = .left
        POSTIONTXT.tag = 0
        POSTIONTXT.delegate = self
        checkPermission()
        // ---------------------------------- SEACH SUGGESTIONS -----------------------------------------
        POSTIONTXT.getSug(vc: self, url: get.root.POSITION!, parameters: nil, header:self.token) { (name) in
            print(name)
            self.POSTIONTXT.itemSelectionHandler(sugs: name, completionHandler: { (id) in
                self.POSTIONTXT.tag = 1
                self.parameter = ["position":id]
            })
        }
        //  ------------------------------------ KEYBOARD HEIGHT FROM THE SCREEN -------------------------
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //        ----------------------------------------------------------------------------------------
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        roundedimage()
    }
    
    
    func roundedimage(){
        EMPLOYEIMAGE.layer.borderWidth = 1
        EMPLOYEIMAGE.layer.masksToBounds = false
        EMPLOYEIMAGE.layer.borderColor = UIColor.black.cgColor
        EMPLOYEIMAGE.layer.cornerRadius = EMPLOYEIMAGE.frame.size.height/2
        EMPLOYEIMAGE.clipsToBounds = true
    }
    

    

//    check for photo library privacy to have an access to the photo library by user
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
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
                self.view.frame.origin.y = -keyboardHeight + 100
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }
  

    @IBAction func ADDBUTTONPRESSED(_ sender: Any) {
        guard let image  = EMPLOYEIMAGE.image else {return}
        guard let name  = USERNAMETXT.text else {return}
        guard let phone = PHONENUMBERTXT.text else {return}
        guard let email = EMAILTXT.text else {return}
        guard let location = LOCATIONTXT.text else {return}
        guard let position = POSTIONTXT.text else {return}
        guard let level = LEVELTXT.text else {return}
        guard let password = PASSWORD.text else {return}
        if (image != UIImage(named: "") && name != "" && phone != "" && email != "" && location != "" && position != "" && level != ""
            && password != ""){
            self.UPLOADPHOTO()

        } else {
            self.alert(title: "Empty fields", messsage: "Please fill the fields")
        }
        
    }

    @IBAction func ADDIMAGEBUTTON(_ sender: Any) {
        present(imagepicker, animated: true, completion: nil)
        
    }
    
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func SHOWLEVELPICKER(){
        
        advicePicker.delegate = self
        LEVELTXT.inputView = advicePicker
    }
    
    func createToolBar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EmployeFormVC.dismissKeyboard))
        toolbar.setItems([donebutton], animated: true)
        toolbar.isUserInteractionEnabled = true
        LEVELTXT.inputAccessoryView = toolbar
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    func UPLOADPHOTO() {
        guard let name = USERNAMETXT.text else {return}
        guard let email = EMAILTXT.text else {return}
        guard let location = LOCATIONTXT.text else {return}
        guard let image = EMPLOYEIMAGE.image else {return}
        guard let level = LEVELTXT.text else {return}
        guard let phone = PHONENUMBERTXT.text else {return}
        guard let passwod = PASSWORD.text else {return}
        self.parameter["name"] = name
        self.parameter["email"] = email
        self.parameter["location"] = location
        self.parameter["level"] = level
        self.parameter["phone"] = phone
        self.parameter["password"] = passwod
////        upload image to api
        let token = KeychainWrapper.standard.string(forKey: "token") ?? ""
        UploadImageController.shared.imageUploadRequest(imageView: image, param: self.parameter, token: token)
    }
}
extension EmployeFormVC : UIPickerViewDelegate ,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LEVEL.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        LEVELTXT.text = LEVEL[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return LEVEL[row]
    }
    
}
extension EmployeFormVC : UITextFieldDelegate{
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
        if textField == POSTIONTXT {
            POSTIONTXT.startVisibleWithoutInteraction = true
        }else{
            POSTIONTXT.startVisibleWithoutInteraction = false
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

extension EmployeFormVC: UIImagePickerControllerDelegate{
    //    IMAGE PICKER FUNCTIONS
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            EMPLOYEIMAGE.image = image
            imagepicker.dismiss(animated: true , completion: nil)
        }
    }
}

