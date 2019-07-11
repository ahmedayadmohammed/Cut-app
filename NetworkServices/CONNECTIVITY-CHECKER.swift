//
//  CONNECTIVITY-CHECKER.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation
import Alamofire

// function to Handle the connection in the Application >>>>>>>?/\/\/\/\/\/\

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
