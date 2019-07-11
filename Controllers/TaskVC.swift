//
//  TaskVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire

class TaskVC: UIViewController {
    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var MYACTIVITY: UIActivityIndicatorView!
    var token:HTTPHeaders?
    var TASKS = [All]()
    override func viewDidLoad() {
        super.viewDidLoad()
        TABLEVIEW.reloadData()
        MYACTIVITY.isHidden=false
        MYACTIVITY.startAnimating()
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
//        token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
          token = ["Content-Type":"application/x-www-form-urlencoded","token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        GETALLTASK()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GETALLTASK()
        TABLEVIEW.reloadData()
    }

    @IBAction func ADDBUTTONPRESSED(_ sender: Any) {
        weak var ADDTASKVC=storyboard?.instantiateViewController(withIdentifier: "AddTaskVC") as? AddTaskVC
        self.present(ADDTASKVC!, animated: true, completion: nil)
        
        
    }
    
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func GETALLTASK(){
        httpRequest(vc: self, url: get.root.GET_ALL_TASK!, httpMethod: .get, parameters: nil, headers: self.token) { (rest:Swift.Result<Gettasks,Error>?) in
            if let output = rest {
                switch output {
                case .success(let ok):
                    self.TASKS = ok.all
                    
                    if ok.all.count > 0{
                    ok.all[0].employeeID.id
                    } else{
                       print("no data")
                    }
                    self.MYACTIVITY.isHidden = true
                    self.MYACTIVITY.stopAnimating()
                    self.TABLEVIEW.reloadData()
                case .failure(let error) :
                    print("t\(error)")
                default:
                    print("i don't know but there some error in the fetching")
                }
            }
        }
    }

}


extension TaskVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TASKS.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TASKCELL = tableView.dequeueReusableCell(withIdentifier: "task") as! TASKCELL
        cell.TASKNAME.text = TASKS[indexPath.row].name
        cell.EMPLOYEENAME.text = TASKS[indexPath.row].employeeID.name
    return cell
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
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            DispatchQueue.main.async {
                self.showDeleteWarning(for: indexPath)
            }
            
            success(true)
        })
        
        modifyAction.image = UIImage(named: "trash")
        modifyAction.backgroundColor = #colorLiteral(red: 0, green: 0.7390694022, blue: 0.57028687, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func showDeleteWarning(for indexPath: IndexPath) {
        //Create the alert controller and actions
        let alert = UIAlertController(title: "حذف مهمة", message: "سوف تقوم بحذف المهمة هل انت متأكد ؟", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {

                let id = self.TASKS[indexPath.row].id
                let parameters:Parameters = ["task_id":id]
                httpRequest(vc:self, url: get.root.DELETE_TASK!, httpMethod: .post, parameters:parameters, headers: self.token
                    , completion: { (rest:Swift.Result<Errorresponse,Error>?) in
                        if let output = rest {
                            switch output{
                            case .success(let ok):
                                print(ok.msg)
                                self.alert(title: "Message", messsage: ok.msg?.description ?? "")
                                DispatchQueue.main.async {
                                    self.GETALLTASK()
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "edit", sender: TASKS[indexPath.row])

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dis=segue.destination as? EditTaskVC {
            if let iph=sender as? All{
                dis.TASKDETAIL=iph
            }
        }
    }

    
    
    
    
    
    
    
}
