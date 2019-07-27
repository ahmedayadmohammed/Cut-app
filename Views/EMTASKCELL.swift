//
//  EMTASKCELL.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/20/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit

class EMTASKCELL: UITableViewCell {
 
    
    @IBOutlet weak var TASKNAME: UILabel!
    @IBOutlet weak var STARTDATE: UILabel!
    @IBOutlet weak var DEADLINE: UILabel!
    @IBOutlet weak var MAINVIEW: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MAINVIEW.layer.cornerRadius = 10
        MAINVIEW.addShadow()
        
        
    }



}
