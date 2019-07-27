//
//  EmpTASK.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/20/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import BonsaiController
import OneSignal

class EmpTASK: UIViewController {
    
    @IBOutlet weak var MYACTIVITY: UIActivityIndicatorView!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    //    variables
    var token:HTTPHeaders!
    var MYTASKS = [EmpTask]()
     var parameter:Parameters=["task_id":"0","employee_id":"0","take_vication":"0"]
    override func viewDidLoad() {
        super.viewDidLoad()
        token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        self.TABLEVIEW.delegate = self
        self.TABLEVIEW.dataSource = self
        MYACTIVITY.startAnimating()
        MYACTIVITY.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        GETTASKS()
    }

    
    
//    this function will fetch all the tasks of the employee
    func GETTASKS(){
        httpRequest(vc: self, url: get.root.GET_PERSONAL_EMPLOYEE_TASK!, httpMethod: .get, parameters: nil, headers: self.token) { (rest:Swift.Result<Getemp,Error>?) in
            if let output  = rest {
                self.MYTASKS.removeAll()
                switch output {
                case .success(let ok):
                        self.MYTASKS = ok.empTask!
                        self.TABLEVIEW.reloadData()
                        self.MYACTIVITY.isHidden = true
                        self.MYACTIVITY.stopAnimating()
                case.failure(let error):
                    self.alert(title: "Error", messsage: "\(error.localizedDescription)")
                    self.MYACTIVITY.isHidden = true
                    self.MYACTIVITY.stopAnimating()
                default :
                    print("There is some error while fetching the data")
                    self.MYACTIVITY.isHidden = true
                    self.MYACTIVITY.stopAnimating()
                    
                }
            }
        }
    }
    

    @IBAction func CLOSEBUTTON(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
}


extension EmpTASK : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MYTASKS.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EMTASKCELL = tableView.dequeueReusableCell(withIdentifier: "emtask") as! EMTASKCELL
        cell.TASKNAME.text = MYTASKS[indexPath.row].name
        cell.DEADLINE.text = MYTASKS[indexPath.row].deadline
        cell.STARTDATE.text = MYTASKS[indexPath.row].taskStart
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
        let modifyAction = UIContextualAction(style: .normal, title:  "DONE", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            DispatchQueue.main.async {
                self.showDeleteWarning(for: indexPath)
            }
            
            success(true)
        })
        
        modifyAction.image = UIImage(named: "DONE-ICON")
        modifyAction.backgroundColor = #colorLiteral(red: 0, green: 0.7390694022, blue: 0.57028687, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func showDeleteWarning(for indexPath: IndexPath) {
        //Create the alert controller and actions
        let alert = UIAlertController(title: "Task Done", message: "Have you done the task ?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "DONE", style: .destructive) { _ in
            DispatchQueue.main.async {
                let id  = self.MYTASKS[indexPath.row].id
                self.parameter["task_id"] = id
                print(id)
                httpRequest(vc: self, url: get.root.TASK_DONE!, httpMethod: .post, parameters:self.parameter, headers:self.token) { (rest:Swift.Result<Errorresponse,Error>?) in
                    if let output = rest {
                        switch output {
                        case .success(let ok):
                            self.alert(title: "Task is done", messsage: ok.msg ?? "")
                            DispatchQueue.main.async {
                                self.GETTASKS()
                                self.TABLEVIEW.reloadData()

                            }
                        case.failure(let error):
                            print(error.localizedDescription)
                        default:
                            print("there is some error while done the task")
                        }
                    }else{
                        self.alert(title: "delelted", messsage:"\(Errorresponse.init(msg:"message deleted"))")
                        self.TABLEVIEW.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
        }
        
        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        //Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.destination is DoneVC {
////            segue.destination.transitioningDelegate = self
////            segue.destination.modalPresentationStyle = .custom
////            if let dis=segue.destination as? DoneVC {
////                if let iph=sender as? EmpTask{
////                    dis.MYDONE=iph
////                }
////            }
////        }
////
////    }
//
//
//
//    }
    
}
extension EmpTASK: BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 4), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (7/3)))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, blurEffectStyle: .dark, presentedViewController: presented, delegate: self)
        
        
        
////         or Bubble animation initiated from a view
//        return BonsaiController(fromView:DONEVIEW, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
    }
}
