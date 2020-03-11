//
//  FetchDataSecond.swift
//  GoFix
//
//  Created by Wolf on 04/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


// protocol to sen back data to controller
protocol FetchDataSecondDelegate {
    func didFetchDataSuccessSecond(code:Int, data:Data)
    func didFetchDataErrorSecond(code:Int, data:String)
}

class FetchDataSecond {
    
    // defaults
    let defaults = UserDefaults.standard
    
    // declare object delegate
    var delegate: FetchDataSecondDelegate?
    
    // post data to URL
    func postDataSecond(urlSerwer:String, parameters: [String: Any]) {
        
        // standard headers
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Consumer": C.headerCustomer,
            "Authorization": "Bearer \(defaults.string(forKey: C.tokenUserAndCraftsman) ?? "")"] // not always needed
        
        
        // create request
        AF.request(urlSerwer, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            print("Class FetchData SECOND: response: \(response)") // print full json object
            print("Class FetchData SECOND: status: \(String(describing: response.response?.statusCode))") // print status code
            
            //get status code
            if let status = response.response?.statusCode {
                switch status {
                case 200 ..< 300:
                    print(response)
                    self.delegate?.didFetchDataSuccessSecond(code: status, data: response.data!)
                    break
                case 300 ... 600:
                    print(response)
                    self.delegate?.didFetchDataErrorSecond(code: status, data: "\(response.data!)")
                    break
                default:
                    print("dafault")
                    break
                }
            }
        })
    }
    
    
    // put data to URL
    func putData(urlSerwer:String, parameters: [String: Any]) {
        
        // standard headers
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Consumer": C.headerCustomer,
            "Authorization": "Bearer \(defaults.string(forKey: C.tokenUserAndCraftsman) ?? "")"] // not always needed
        
        
        // create request
        AF.request(urlSerwer, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            print("Class FetchData: response: \(response)") // print full json object
            print("Class FetchData: status: \(String(describing: response.response?.statusCode))") // print status code
            
            //get status code
            if let status = response.response?.statusCode {
                switch status {
                case 200 ..< 300:
                    print(response.data!)
                    self.delegate?.didFetchDataSuccessSecond(code: status, data: response.data!)
                    break
                case 401 ... 600:
                    self.delegate?.didFetchDataErrorSecond(code: status, data: "\(response.data!)")
                    break
                default:
                    print("dafault")
                    break
                }
            }
        })
    }
    
    
    // post data to URL
    func getData(urlSerwer:String) {
        
        // standard headers
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Consumer": C.headerCustomer,
            "Authorization": "Bearer \(defaults.string(forKey: C.tokenUserAndCraftsman) ?? "")"] // not always needed
        
        // create request
        AF.request(urlSerwer, method: .get, headers: headers).responseJSON(completionHandler: { response in
            print("Class FetchData: response: \(response)") // print full json object
            print("Class FetchData: status: \(String(describing: response.response?.statusCode))") // print status code
            
            //get status code
            if let status = response.response?.statusCode {
                switch status {
                case 200 ..< 300:
                    self.delegate?.didFetchDataSuccessSecond(code: status, data: response.data!)
                    break
                default:
                    self.delegate?.didFetchDataErrorSecond(code: status, data: "\(response)")
                    break
                }
            }
        })
    }
}
