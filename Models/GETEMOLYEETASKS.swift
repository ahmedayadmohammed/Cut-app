//
//  GETEMOLYEETASKS.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/20/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.


import Foundation
// MARK: - Getemp
struct Getemp: Codable {
    let empTask: [EmpTask]?
}

// MARK: - EmpTask
struct EmpTask: Codable {
    let id, name, taskStart, deadline: String?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case taskStart = "task_start"
        case deadline
    }
}
