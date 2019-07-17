//
//  GetAllTasks.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation

// MARK: - Getemployee
struct Gettasks: Codable {
    let all: [All]
}

// MARK: - All
struct All: Codable {
    let id, name: String
    let employeeID: EmployeeID
    let taskStart, deadline: String
    let done: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case employeeID = "employee_id"
        case taskStart = "task_start"
        case deadline, done
    }
}

// MARK: - EmployeeID
struct EmployeeID: Codable {
    let id, name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}
