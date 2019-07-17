//
//  URL.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation
import UIKit

// ROUTIG ALL THE URLS OF THE APP 
let BASEURL = "https://cleaner-task.herokuapp.com/api/v1"
struct get {
    struct root {
        static let LOGIN = URL(string:"\(BASEURL)/account/login")
        static let WORKER_REGISTERATION = URL(string: "\(BASEURL)/employee/register")
        static let WORKER_LOGIN = URL(string:"\(BASEURL)/worker/login")
        static let ADD_EMPLOYEE = URL(string: "\(BASEURL)/employee/add")
        static let ADD_TASK = URL(string:"\(BASEURL)/task/add")
        static let GET_TASK_BY_ID = URL(string:"\(BASEURL)")
        static let GET_ALL_TASK = URL(string: "\(BASEURL)/task/all")
        static let DELETE_TASK = URL(string: "\(BASEURL)/task/delete")
        static let GET_EMPLOYEE = URL(string: "\(BASEURL)/employee/all")
        static let ID_AND_NAMES = URL(string: "\(BASEURL)/employee/selector")
        static let TASK_UPDATE = URL(string: "\(BASEURL)/task/update")
        static let DELETE_EMPLOYEE = URL(string: "\(BASEURL)/employee/delete")
        static let POSITION = URL(string: "\(BASEURL)/position/get")
        static let ADD_SECTIONS = URL(string: "\(BASEURL)/position/add")
        static let GET_EMPLOYEE_BY_POSITIONS_ID = URL(string: "\(BASEURL)/position/employee")
        static let DELETE_POSITION = URL(string: "\(BASEURL)/position/delete")
        static let TASK_TYPE = URL(string: "\(BASEURL)/task/getype")
    }
}
