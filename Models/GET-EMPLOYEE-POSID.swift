//
//  GET-EMPLOYEE-POSID.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/13/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation
import UIKit
struct Getemployee: Codable {
    let employee: [Employee]
}

// MARK: - Employee
struct Employee: Codable {
    let id, name, image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, image
    }
}
