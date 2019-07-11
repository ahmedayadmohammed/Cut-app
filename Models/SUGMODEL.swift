//
//  SUGMODEL.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation

// MARK: - SugModel
struct SugModel: Codable {
    let name: [Name]?
}

// MARK: - Name
struct Name: Codable {
    let id, name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

