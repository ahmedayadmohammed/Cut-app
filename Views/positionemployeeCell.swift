//
//  positionemployeeCell.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/13/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit

class positionemployeeCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var EMPLOYEEIMAGE: UIImageView!
    @IBOutlet weak var VIEW: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        VIEW.layer.cornerRadius = 10
        VIEW.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
