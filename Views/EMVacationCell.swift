//
//  EMVacationCell.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/22/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit

class EMVacationCell: UITableViewCell {

    @IBOutlet weak var VACATIONNAME: UILabel!
    @IBOutlet weak var NUMBEROFDAYS: UILabel!
    @IBOutlet weak var MAINVVIEW: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MAINVVIEW.layer.cornerRadius = 10
        MAINVVIEW.addShadow()

    }
    
    
    
    
    

  
}
