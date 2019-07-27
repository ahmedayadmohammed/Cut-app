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
        static let GET_VACATIONS = URL(string: "\(BASEURL)/vication/getvication")
        static let VACATIONS_GET_SET = URL(string: "\(BASEURL)/vication/getset")
        static let ADD_VACATION = URL(string: "\(BASEURL)/vication/add")
        static let DELETE_VACATION = URL(string: "\(BASEURL)/vication/delete")
        static let UPDATE_VACATION = URL(string: "\(BASEURL)/vication/edite")
        static let GET_PERSONAL_EMPLOYEE_TASK = URL(string:"\(BASEURL)/task/gettask")
        static let TASK_DONE = URL(string: "\(BASEURL)/task/mytask")
        static let GET_REPORTS = URL(string: "\(BASEURL)/task/report")
        static let EM_VACATION = URL(string: "\(BASEURL)/vication/empVication")
        static let VACATION_ADD = URL(string: "\(BASEURL)/takevication/add")
        static let ACCECCPT_VACATION = URL(string: "\(BASEURL)/takevication/accept")
        static let REJECTION_VACATIONS = URL(string: "\(BASEURL)/takevication/reject")
        static let GET_VACATION_REQUEST = URL(string: "\(BASEURL)/takevication/viewRequset")
        static let GET_EM_PROFILE = URL(string: "\(BASEURL)/employee/mProfile")
        static let GET_TASK_BY_EMPLOYEEID = URL(string: "\(BASEURL)/task/empTask")
        static let GET_PERSONAL_PROFILE_FOR_EM = URL(string: "\(BASEURL)/employee/eProfile")
        static let GET_TASK_BY_TOKEN = URL(string:"\(BASEURL)/task/gettask")
    }
}
