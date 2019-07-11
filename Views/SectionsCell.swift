//
//  SectionsCell.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/10/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit

class SectionsCell: UITableViewCell {

    @IBOutlet weak var MAINVIEW: UIView!
    @IBOutlet weak var SECTIONNAME: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         MAINVIEW.layer.cornerRadius = 10
        MAINVIEW.addShadow()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
