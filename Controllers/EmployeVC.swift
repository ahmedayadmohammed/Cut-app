//
//  EmployeVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class EmployeVC: UIViewController {

    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var ADDVIEW: UIView!
    @IBOutlet weak var MYACTIVITY: UIActivityIndicatorView!
    var token:HTTPHeaders?
    var ALLEMPLOYEE = [AllEmployee]()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
        ADDVIEW.layer.cornerRadius = 10
        token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        GETEMPLOYEE()
        MYACTIVITY.isHidden = false
        MYACTIVITY.startAnimating()
        TABLEVIEW.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        GETEMPLOYEE()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        GETEMPLOYEE()
    }
    

    
    @IBAction func ADDEMPLOYEBUTTON(_ sender: Any) {
        let FORMVC = storyboard?.instantiateViewController(withIdentifier: "EmployeFormVC") as! EmployeFormVC
        self.present(FORMVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func ADDBUTTONPRESSED(_ sender: Any) {
        
        
    }
 
    
    func GETEMPLOYEE(){
        
        httpRequest(vc: self, url: get.root.GET_EMPLOYEE!, httpMethod: .get, parameters: nil, headers: self.token) { (rest:Swift.Result<EmployeeINFO,Error>?) in
            if let output = rest{
                switch output {
                case .success(let ok):
                    if ok.allEmployee.count >= 1 {
                        self.ALLEMPLOYEE = ok.allEmployee
                        self.TABLEVIEW.reloadData()
                        self.MYACTIVITY.isHidden = true
                    } else{
                        self.alert(title: "NO data", messsage: "There is no emplpoyee")
                        self.MYACTIVITY.isHidden = true
                    }
               
                 print("FETCHING SUCCESS")
                case .failure(let error):
                    print("there is some error ahmed in the employee\(error.localizedDescription)")
                    self.MYACTIVITY.isHidden = true

                default:
                    print("THERE IS ANOTHER ERROR WHILE FETCHING THE EMPLOYEE")
                    self.MYACTIVITY.isHidden = true

                }
            }
        }
        
        
    }
    
    
    

}

extension EmployeVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ALLEMPLOYEE.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ADDPERSONCELL = tableView.dequeueReusableCell(withIdentifier: "person") as! ADDPERSONCELL
        cell.PERSONENAME.text = ALLEMPLOYEE[indexPath.row].name
//        cell.POSTION.text = ALLEMPLOYEE[indexPath.row].position
//        cell.LOCATIONLABEL.text = ALLEMPLOYEE[indexPath.row].location
//        cell.EMAIL.text = ALLEMPLOYEE[indexPath.row].email
//        cell.PHONE.text = ALLEMPLOYEE[indexPath.row].phone.description
//        cell.PERSONEIMAGE.sd_setImage(with: URL(string: "https://cleaner-task.herokuapp.com/api/v1/\(ALLEMPLOYEE[indexPath.row].image)")!)
        print("https://cleaner-task.herokuapp.com/\(ALLEMPLOYEE[indexPath.row].image)")


        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            DispatchQueue.main.async {
                self.showDeleteWarning(for: indexPath)
            }
            
            success(true)
        })
        
        modifyAction.image = UIImage(named: "trash")
        modifyAction.backgroundColor = #colorLiteral(red: 0.9104704261, green: 0.04083971679, blue: 0.144176811, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }


    }
    
    
    func showDeleteWarning(for indexPath: IndexPath) {
        //Create the alert controller and actions
        let alert = UIAlertController(title: "حذف موظف", message: "سوف تقوم بحذف موظف هل أنت متأكد؟", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                
                let id = self.ALLEMPLOYEE[indexPath.row].id
                let parameters:Parameters = ["employee_id":id]
                httpRequest(vc:self, url: get.root.DELETE_EMPLOYEE!, httpMethod: .post, parameters:parameters, headers: self.token
                    , completion: { (rest:Swift.Result<Errorresponse,Error>?) in
                        if let output = rest {
                            switch output{
                            case .success(let ok):
                                print(ok.msg)
                                self.alert(title: "Message", messsage: ok.msg?.description ?? "")
                                DispatchQueue.main.async {
                                    self.GETEMPLOYEE()
                                }
                            case .failure(let error):
                                print("error \(error)")
                            default:
                                print("some error")
                            }
                            
                            
                        }else{
                            self.alert(title: "delelted", messsage:"\(Errorresponse.init(msg:"message deleted"))")
                            self.TABLEVIEW.deleteRows(at: [indexPath], with: .automatic)
                        }
                })
            }
            
        }
        
        
        
        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        //Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
