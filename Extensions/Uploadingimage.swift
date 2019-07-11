//
//  Uploadingimage.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/7/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation
import Alamofire

class UploadImageController: NSObject {
    
    // MARK: - shared
    
    static let shared  = UploadImageController()
    
    // MARK: - init
    
    let decoder = JSONDecoder()
    
    // MARK: - uploadImageOnly
    
    func uploadImageWith(endUrl: String, photo: UIImage?, parameters: [String : Any]?, headers: HTTPHeaders?, completion: @escaping (_ success: Bool, _ uploadImageResponse: UploadImageResponse?) -> Void ) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let data = UIImage.jpegData(compressionQuality:0.5) {
                
                multipartFormData.append(data, withName: "invoice", fileName: "invoice.jpeg", mimeType: "invoice/jpeg")
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: endUrl, method: .post, headers: headers) { (result) in
            
            switch result {
                
            case .failure(let error):
                print("UploadImageController.requestWith.Alamofire.usingThreshold:", error)
                completion(false, nil)
                
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON(completionHandler: { (response) in
                    
                    switch response.result {
                        
                    case .failure(let error):
                        
                        print("UploadImageController.requestWith.Alamofire.upload.responseJSON:", error)
                        
                        completion(false, nil)
                        
                    case .success( _):
                        
                        print("UploadImageController.requestWith.Alamofire.upload.responseJSON Succes")
                        guard let data = response.data else { return }
                        
                        do {
                            
                            let uploadImageResponse = try self.decoder.decode(UploadImageResponse.self, from: data)
                            
                            completion(true, uploadImageResponse)
                            
                        } catch let jsonError {
                            
                            print("Error serializing json.ProfileController.getProfile:", jsonError)
                            completion(false, nil)
                        }
                    }
                })
            }
        }
}
}
