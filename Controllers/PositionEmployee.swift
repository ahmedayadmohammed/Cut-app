//
//  PositionEmployee.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/13/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
class PositionEmployee: UIViewController {

    
    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var REFRESHBUTTON: LoadingButton!
    
    //    variables
    var EMPLOYEEE = [Employee]()
    var SECTIONID:Name!
    var POSID :String!
    var token:HTTPHeaders?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        REFRESHBUTTON.showLoading()
        REFRESHBUTTON.setImage(nil, for:.normal)
        POSID = SECTIONID.id
        token = ["Content-Type":"application/x-www-form-urlencoded","token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        GETALLEMPLOYEEBYID()
    }

//    GET ALL EMPLOYEE FUNCTION BY POSTION ID
    func GETALLEMPLOYEEBYID(){
        let posid = POSID!
        print("this is the id of the position\(posid.description)")
        let param:Parameters = ["position_id":posid]
        httpRequest(vc:self, url: get.root.GET_EMPLOYEE_BY_POSITIONS_ID!, httpMethod: .get, parameters:param, headers: self.token) { (rest:Swift.Result<Getemployee,Error>?) in
            if let output = rest{
                switch output{
                case .success(let ok):
                    if ok.employee.count >= 1{
                        self.REFRESHBUTTON.hideLoading()
                        self.REFRESHBUTTON.setImage(UIImage(named: "RefreshIcon"), for: .normal)
                        self.EMPLOYEEE = ok.employee
                        self.TABLEVIEW.reloadData()
                    }else{
                        self.alert(title:"Empty Section", messsage: "There is no data in this section")
                        self.REFRESHBUTTON.hideLoading()
                        self.REFRESHBUTTON.setImage(UIImage(named: "RefreshIcon"), for: .normal)
                    }
                   
                case .failure(let error):
                    print(error.localizedDescription)
                    self.REFRESHBUTTON.hideLoading()
                    self.REFRESHBUTTON.setImage(UIImage(named: "RefreshIcon"), for: .normal)
                default:
                    print("THER IS SOME ERROR IN THE FETCHING DATA")
                }
            }
        }
    }
    
    
//    REFRESH-BUTTON
    @IBAction func REFRESHBUTTON(_ sender: Any) {
        GETALLEMPLOYEEBYID()
    }
    
    
    
//    DISMISS BUTTON
    @IBAction func DISMISSBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    


}


// TABLE-VIEW-EXTENSION

extension PositionEmployee : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EMPLOYEEE.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :positionemployeeCell = tableView.dequeueReusableCell(withIdentifier: "poscell") as! positionemployeeCell
        cell.Name.text = EMPLOYEEE[indexPath.row].name
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
}
