//
//  GetAllTasks.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Gettasks
struct Gettasks: Codable {
    let all: [All]
}

// MARK: - All
struct All: Codable {
    let id, name: String
    let employeeID: EmployeeID
    let done: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case employeeID = "employee_id"
        case done
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


