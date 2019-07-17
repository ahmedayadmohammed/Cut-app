//
//  NetWorkServices.swift
//  CleanerApp
//
//  Created by Ahmed Ayad on 7/2/19.
//  Copyright © 2019 ahmed ayad. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration
import UIKit
import Lottie


// ----------------------------- GENERAL FUNCTION OF POST.DELETE.GET ---------------------------------------



 func httpRequest<T: Codable >(vc:UIViewController, url:URL, httpMethod:HTTPMethod, parameters: Parameters?,headers:HTTPHeaders?, completion: @escaping (Swift.Result<T,Error>) -> ()) {

    Alamofire.request(url, method: httpMethod, parameters: parameters,encoding: URLEncoding.default, headers:headers).validate().responseJSON() { (response) in
        print(response)
        switch response.response?.statusCode {
        case 200:
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let output = try decoder.decode(T.self, from: data)
                    completion(.success(output))
        

                } catch let JsonError{
                    completion(.failure(JsonError))
                }
            }

        case 401:
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let output = try decoder.decode(Errorresponse.self, from: data)

                    vc.alert(title: "خطأ", messsage: output.msg ?? ""){
                       print("error ahmed 401")
                        
                        let LoginC = vc.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        vc.present(LoginC, animated: true, completion: nil)
                        
                    }

                } catch let JsonError{
                    completion(.failure(JsonError))
                }
            }

        case 400:
            if let data = response.data {
                let decoder = JSONDecoder()

                do {
                    let output = try decoder.decode(Errorresponse.self, from: data)
                    vc.alert(title: "error", messsage: output.msg ?? "")

                } catch let JsonError{
                    completion(.failure(JsonError))
                }
            }

        default:
            if let data = response.data {
                let decoder = JSONDecoder()

                do {
                    let output = try decoder.decode(Errorresponse.self, from: data)
                    vc.alert(title: "there is a problem\(response.response?.statusCode)", messsage: output.msg ?? "")

                } catch let JsonError{
                    completion(.failure(JsonError))
                }
            }
        }
    }
    }
//    END OF GENERAL FUNCTION -------------------------------------






    
    
//    LOGIN USER FUNCTION ------------------------------------------
func LoginUser<T: Codable >(vc:UIViewController,Loading:LoadingButton,url:URL, httpMethod:HTTPMethod, parameters: Parameters?,headers:HTTPHeaders?, completion: @escaping (Swift.Result<T,Error>) -> ()) {
        
        Alamofire.request(url, method: httpMethod, parameters: parameters,encoding: URLEncoding.default, headers:headers).validate().responseJSON() { (response) in
            print(response)
            switch response.response?.statusCode {
            case 200:
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let output = try decoder.decode(T.self, from: data)
                        completion(.success(output))
                        
                    } catch let JsonError{
                        completion(.failure(JsonError))
                    }
                }
                
            case 401:
                if let data = response.data {
                    let decoder = JSONDecoder()
                    do {
                        let output = try decoder.decode(Errorresponse.self, from: data)
                        Loading.hideLoading()
                        vc.alert(title: "خطأ", messsage: output.msg ?? "")
                        {
                            if !vc.isKind(of: LoginVC.self){
                                let LoginC = vc.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                vc.present(LoginC, animated: true, completion: nil)
                            }else{
                              print("there is some error\(output)")
                            }
                        }
                        
                    } catch let JsonError{
                        completion(.failure(JsonError))
                    }
                }
                
            case 400:
                if let data = response.data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let output = try decoder.decode(Errorresponse.self, from: data)
                        Loading.hideLoading()
                    
                        vc.alert(title: "خطأ", messsage: output.msg ?? "")
                    } catch let JsonError{
                        completion(.failure(JsonError))
                    }
                }
                
            default:
                if let data = response.data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let output = try decoder.decode(Errorresponse.self, from: data)
                        vc.alert(title: "there is a problem\(response.response?.statusCode)", messsage: output.msg ?? "")
                        
                    } catch let JsonError{
                        completion(.failure(JsonError))
                    }
                }
            }
        }
        
        
        
//        ----------------------------------- THE END OF USER LOGIN FUNCTION ------------------------------
 
        
        
    }
    
   







