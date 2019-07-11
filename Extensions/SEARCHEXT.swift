//
//  SEARCHEXT.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/3/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation
import UIKit
import SearchTextField
import Alamofire

extension SearchTextField{
    
    open override func awakeFromNib() {

        self.highlightAttributes = [NSAttributedString.Key.backgroundColor: UIColor.gray, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12)]

        self.theme.font = UIFont.systemFont(ofSize: 17)
        self.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        self.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        self.theme.cellHeight = 50
        self.theme.cellHeight = 30

    }
    
    
    
    func itemSelectionHandler(sugs:[Name], completionHandler: @escaping (_ rest: String) -> Void){
        self.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.text = item.title
            
            
            for sug in sugs {
                if let name = sug.name {
                    
                    if item.title == name {
                        completionHandler(sug.id ?? "0")
                    }
                }
            }
            
            self.theme.fontColor = UIColor.black
            self.clearButtonMode = .always
            self.resignFirstResponder()
        }
    }
    
    
    func getSug(vc:UIViewController, url:URL,parameters:Parameters?,header:HTTPHeaders? , completion: @escaping ([Name]) -> ()){
        httpRequest(vc: vc, url: url, httpMethod: .get, parameters: parameters, headers: header) { (rest:Swift.Result<SugModel,Error>) in
            switch rest{
            case .success(let output):
                
                var sugNames = [String]()
                if let  names = output.name {
                    for item in names {
                        sugNames.append(item.name ?? "")
                    }
                    self.filterStrings(sugNames)
                    completion(names)
                }else{
                    print("there's a problem")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    
    
    
}
