//
//  ERROR-RESPONSE.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation

// MARK: - Errorresponse
class Errorresponse: Codable {
    let msg: String?
    
    init(msg: String?) {
        self.msg = msg
    }
}
