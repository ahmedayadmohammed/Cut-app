//
//  VacationCell.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/18/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit

class VacationCell: UITableViewCell {

    @IBOutlet weak var VACATIONNAME: UILabel!
    @IBOutlet weak var MAINVIEW: UIView!
    @IBOutlet weak var HOURS: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MAINVIEW.layer.cornerRadius = 10
        MAINVIEW.addShadow()


    }

  
}
