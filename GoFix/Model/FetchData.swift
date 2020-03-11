//
//  FetchData.swift
//  GoFix
//
//  Created by Wolf on 24/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// protocol to sen back data to controller
protocol FetchDataDelegate {
    func didFetchDataSuccess(code:Int, data:Data)
    func didFetchDataError(code:Int, data:String)
}

// class to fetch data from url
class FetchData {
    
    // defaults
    let defaults = UserDefaults.standard
    
    // declare object delegate
    var delegate: FetchDataDelegate?
    
    // post data to URL
    func postData(urlSerwer:String, parameters: [String: Any]) {
        
        // standard headers
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Consumer": C.headerCustomer,
            "Authorization": "Bearer \(defaults.string(forKey: C.tokenUserAndCraftsman) ?? "")"] // not always needed
        
        
        // create request
        AF.request(urlSerwer, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            print("Class FetchData: response: \(response)") // print full json object
            print("Class FetchData: status: \(String(describing: response.response?.statusCode))") // print status code
            
            //get status code
            if let status = response.response?.statusCode {
                switch status {
                case 200 ..< 300:
                    self.delegate?.didFetchDataSuccess(code: status, data: response.data!)
                    break
                case 401:
                    self.delegate?.didFetchDataError(code: status, data: "Niepoprawny login lub hasło")
                    break
                case 422:
                    print("status ERROR code 422")
                    // get result as json object error
                    if let result = try? JSON(data: response.data!){ // must be import SwiftyJSON
                        let errors = result["errors"]// get json object named "errors" from full json object
                        print(errors)
                        
                        let email = errors["email"] // get json array named "email" from json object named "errors"
                        let emailErrorString = email[0].stringValue // get first object to string
                        print(emailErrorString)
                        
                        let phoneNumber = errors["phoneNumber"] // get json array named "phoneNumber" from json object named "errors"
                        let phoneNumberErrorString = phoneNumber[0].stringValue // get first object to string
                        print(phoneNumberErrorString)
                        
                        let password = errors["password"] // get json array named "email" from json object named "errors"
                        let passwordErrorString = password[0].stringValue // get first object to string
                        print(passwordErrorString)
                        
                        let description = errors["description"] // get json array named "description"
                        let descriptionErrorString = description[0].stringValue // get first object to string
                        print(descriptionErrorString)
                        
                        self.delegate?.didFetchDataError(code: status, data: "\(emailErrorString) \n \(phoneNumberErrorString) \n \(passwordErrorString) \n \(descriptionErrorString)")
                    }
                    break
                case 401 ... 600:
                    print(response.data!)
                    self.delegate?.didFetchDataError(code: status, data: "\(response.data!)")
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
                    self.delegate?.didFetchDataSuccess(code: status, data: response.data!)
                    break
                case 401 ... 600:
                    print(response.data!)
                    self.delegate?.didFetchDataError(code: status, data: "\(response.data!)")
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
                    self.delegate?.didFetchDataSuccess(code: status, data: response.data!)
                    break
                default:
                    self.delegate?.didFetchDataError(code: status, data: "\(response)")
                    break
                }
            }
        })
    }
    
    
}
