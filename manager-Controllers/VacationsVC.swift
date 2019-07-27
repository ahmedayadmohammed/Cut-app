//
//  VacationsVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/18/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import BonsaiController

class VacationsVC: UIViewController {

//    outlets
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var REFRESHBUTTON: LoadingButton!
    @IBOutlet weak var NOTIFICATIONLABEL: UILabel!
    @IBOutlet weak var NOTIFICATION_BUTTON: UIButton!
    //    variables
    lazy var Vacations = [Vication]()
    var token:HTTPHeaders?
    override func viewDidLoad() {
        super.viewDidLoad()
        REFRESHBUTTON.setImage(nil, for: .normal)
        REFRESHBUTTON.showLoading()
        token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        GET_REQUESTED_VACATIONS()
        GETVACATIONS()

    }
    
    @IBAction func REFRESHER(_ sender: LoadingButton) {
        sender.showLoading()
        self.REFRESHBUTTON.setImage(nil, for: .normal)
        self.GETVACATIONS()
        TABLEVIEW.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        GETVACATIONS()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        GETVACATIONS()
        TABLEVIEW.reloadData()
    }
    
    func GETVACATIONS(){
        httpRequest(vc: self, url:get.root.GET_VACATIONS!, httpMethod: .get, parameters: nil, headers: self.token) { (rest:Swift.Result<Getvacations,Error>?) in
            if let output = rest {
                switch output {
                case.success(let ok):
                    self.Vacations = ok.vications!
                    self.TABLEVIEW.reloadData()
                    self.REFRESHBUTTON.hideLoading()
                    self.REFRESHBUTTON.setImage(UIImage(named: "RefreshIcon"), for: .normal)
                case.failure(let error):
                    print(error.localizedDescription)
                    self.REFRESHBUTTON.hideLoading()
                    self.REFRESHBUTTON.setImage(UIImage(named: "RefreshIcon"), for: .normal)
                    self.alert(title: "Error", messsage: "Sorry but there is some error")
                    
                default:
                    print("there is some error while downloading the vacations")
                }
            }
        }
    }
    
    func GET_REQUESTED_VACATIONS(){
        httpRequest(vc: self, url:get.root.GET_VACATION_REQUEST!, httpMethod: .get, parameters: nil, headers: self.token) {[weak self] (rest:Swift.Result<Vacationrequest,Error>?) in
            if let output = rest {
                switch output {
                case.success(let ok):
                    if ok.vicationRequest!.count >= 1 {
                        self?.NOTIFICATIONLABEL.text = ok.vicationRequest?.count.description
                        self?.NOTIFICATION_BUTTON.setImage(UIImage(named: "NOTIFICATIONS-ICON2"), for: .normal)
                        print(ok.vicationRequest?.count)
                    }else {
                           self?.NOTIFICATION_BUTTON.setImage(UIImage(named: "NOTIFICATIONS-ICON"), for: .normal)
                            self?.NOTIFICATIONLABEL.text = ""

                    }
               
                case.failure(let error):
                    print(error.localizedDescription)
                    
                default:
                    print("there is some error while downloading the vacations")
                }
            }
        }
    }
 
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ADDVACATIONS(_ sender: Any) {
        let addVACATIONSVC = storyboard?.instantiateViewController(withIdentifier: "AddVacationsVC") as! AddVacationsVC
        self.present(addVACATIONSVC, animated: true, completion: nil)
        
    }
    
    @IBAction func NOTIFICATIONBUTTON(_ sender: Any) {
        let VACC = storyboard?.instantiateViewController(withIdentifier: "VacationRequest") as! VacationRequest
        self.present(VACC,animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    

}



extension VacationsVC : UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Vacations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : VacationCell = tableView.dequeueReusableCell(withIdentifier: "Vcell") as! VacationCell
        cell.VACATIONNAME.text = Vacations[indexPath.row].name
        cell.HOURS.text = Vacations[indexPath.row].numberOfHour?.description
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
        modifyAction.backgroundColor = #colorLiteral(red: 0, green: 0.5941872001, blue: 0.9286010265, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func showDeleteWarning(for indexPath: IndexPath) {
        //Create the alert controller and actions
        let alert = UIAlertController(title: "حذف أجازة", message: "سوف تقوم بحذف أجازة هل انت متأكد ؟", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                
                let id = self.Vacations[indexPath.row].id
                let parameters:Parameters = ["vication_id":id]
                httpRequest(vc:self, url: get.root.DELETE_VACATION!, httpMethod: .post, parameters:parameters, headers: self.token
                    , completion: { (rest:Swift.Result<Errorresponse,Error>?) in
                        if let output = rest {
                            switch output{
                            case .success(let ok):
                                print(ok.msg)
                                self.alert(title: "Message", messsage: ok.msg ?? "")
                                DispatchQueue.main.async {
                                    self.GETVACATIONS()
                                    self.TABLEVIEW.reloadData()
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
        performSegue(withIdentifier: "v", sender: Vacations[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UpdateVC {
            segue.destination.transitioningDelegate = self
            segue.destination.modalPresentationStyle = .custom
            if let dis=segue.destination as? UpdateVC {
                if let iph=sender as? Vication{
                    dis.myvacation=iph
                }
            }
        }
        
    }
    
    
}
extension VacationsVC: BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 4), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/3)))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, blurEffectStyle: .light, presentedViewController: presented, delegate: self)
        
        
        
        // or Bubble animation initiated from a view
        //        return BonsaiController(fromView:AddSections, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
    }
}













