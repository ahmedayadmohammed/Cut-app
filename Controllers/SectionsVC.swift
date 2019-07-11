//
//  SectionsVC.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/10/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import BonsaiController

class SectionsVC: UIViewController {

    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var REFRESHBUTTON: LoadingButton!
    
    var token:HTTPHeaders?
    var POSITION = [Name]()
    override func viewDidLoad() {
        super.viewDidLoad()
        REFRESHBUTTON.setImage(nil, for: .normal)
        REFRESHBUTTON.showLoading()
         token = ["token":KeychainWrapper.standard.string(forKey: "token") ?? ""]
        GETPOSITION()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.TABLEVIEW.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.TABLEVIEW.reloadData()
    }
    
    
    @IBAction func ADDSECTIONBUTTON(_ sender: Any) {
        let SECTIONs = storyboard?.instantiateViewController(withIdentifier: "AddSections") as! AddSections
        SECTIONs.transitioningDelegate = self
        SECTIONs.modalPresentationStyle = .custom
        present(SECTIONs, animated: true, completion: nil)
    }

    @IBAction func REFRESHBUTTON(_ sender: LoadingButton) {
        sender.showLoading()
        self.REFRESHBUTTON.setImage(nil, for: .normal)
        self.GETPOSITION()
    }
    func GETPOSITION(){
        LoginUser(vc: self, Loading: REFRESHBUTTON, url: get.root.POSITION!, httpMethod: .get, parameters: nil, headers: self.token) { (rest:Swift.Result<SugModel,Error>?) in
            if let output = rest {
                switch output {
                case .success(let ok):
                    self.POSITION = ok.name!
                    self.TABLEVIEW.reloadData()
                    self.REFRESHBUTTON.hideLoading()
                    self.REFRESHBUTTON.setImage(UIImage(named: "RefreshIcon"), for: .normal)
                    print("Successfully fetching\(ok.name)")
                case.failure(let error):
                    self.REFRESHBUTTON.hideLoading()
                    self.REFRESHBUTTON.setImage(UIImage(named: "RefreshIcon"), for: .normal)
                    self.REFRESHBUTTON.setImage(UIImage(named: "RefreshIcon"), for: .normal)
                    print("\(error.localizedDescription)")
                    
                default:
                    print("there is an error while fetching")
                }
            }
        }
    }
    
    @IBAction func CLOSEBUTTON(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SectionsVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return POSITION.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SectionsCell = tableView.dequeueReusableCell(withIdentifier: "Scell") as! SectionsCell
        cell.SECTIONNAME.text = POSITION[indexPath.row].name
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
extension SectionsVC: BonsaiControllerDelegate {
    
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


