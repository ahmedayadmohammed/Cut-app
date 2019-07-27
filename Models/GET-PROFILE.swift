//
//  GET-PROFILE.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/21/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation

// MARK: - Getprofile
struct Getprofile: Codable {
    let employeeInfo: [EmployeeInfo]?
    let vicationBalance: [VicationBalance]?
}

// MARK: - EmployeeInfo
struct EmployeeInfo: Codable {
    let id: String?
    let phone: Int?
    let name, location, email: String?
    let position: Position?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case phone, name, location, email, position, image
    }
}

// MARK: - Position
struct Position: Codable {
    let id, name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}


// MARK: - VicationBalance
struct VicationBalance: Codable {
    let id: String?
    let vicationID: VicationID?
    let hourTaken: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vicationID = "vication_id"
        case hourTaken
    }
}

// MARK: - VicationID
struct VicationID: Codable {
    let id, name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

