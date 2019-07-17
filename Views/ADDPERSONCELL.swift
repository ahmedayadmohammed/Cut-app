//
//  ADDPERSONCELL.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import UIKit

class ADDPERSONCELL: UITableViewCell {

    @IBOutlet weak var MAINVIEW: UIView!
    @IBOutlet weak var PERSONEIMAGE: UIImageView!
    @IBOutlet weak var PERSONENAME: UILabel!
    @IBOutlet weak var POSTION: UILabel!
    @IBOutlet weak var LOCATIONLABEL: UILabel!
    @IBOutlet weak var EMAIL: UILabel!
    @IBOutlet weak var PHONE: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        MAINVIEW.layer.cornerRadius = 10
        MAINVIEW.addShadow()

    }


}
