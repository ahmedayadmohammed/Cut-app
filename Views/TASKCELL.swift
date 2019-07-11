//
//  TASKCELL.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit

class TASKCELL: UITableViewCell {

    @IBOutlet weak var TASKIMAGE: UIImageView!
    @IBOutlet weak var TASKNAME: UILabel!
    @IBOutlet weak var EMPLOYEENAME: UILabel!
    @IBOutlet weak var MAINCELLVIEW: UIView!
    @IBOutlet weak var DATE: UILabel!
    @IBOutlet weak var DATELABEL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     MAINCELLVIEW.layer.cornerRadius = 10

    }

}
