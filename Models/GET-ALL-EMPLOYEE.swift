//
//  GET-ALL-EMPLOYEE.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/5/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//


import Foundation

// MARK: - Employee
struct EmployeeINFO: Codable {
    let allEmployee: [AllEmployee]
}

// MARK: - AllEmployee
struct AllEmployee: Codable {
    let id: String
    let phone: Int
    let name, location, email, position: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case phone, name, location, email, position, image
    }
}

