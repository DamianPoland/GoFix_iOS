//
//  ViewControllerUserRegisterToken.swift
//  GoFix
//
//  Created by Wolf on 09/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewControllerUserRegisterToken: UIViewController, FetchDataDelegate  {
    
    // views outlets
    @IBOutlet weak var viewTextToken: UITextField!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewButtonLogIn: UIButton!
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // defaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide viewIndicator
        viewIndicator.isHidden = true
        
        // add delegate
        fetchData.delegate = self
    }
    

    @IBAction func buttonLogIn(_ sender: Any) {
        
        // check that edit text is not empty
        if viewTextToken.text == "" {
            showAlertDialog(title: "Error", message: "Wpisz token")
            return
        }
        
        // take all data to register
        let userToken = Int(viewTextToken.text!)
        let userEmail = defaults.string(forKey: C.userEmal) // get from defaults
        print("fetchData.putData: token: \(userToken!), email: \(userEmail!)")
        
        // send data to serwer
        let urlSerwer:String = "\(C.API)user/confirm"
        let parameters: [String: Any] = ["token": userToken!, "email": userEmail!] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject
        
        // fetch data func
        fetchData.putData(urlSerwer: urlSerwer, parameters: parameters)
        
        // hide button and show indicator
        viewButtonLogIn.isHidden = true
        viewIndicator.isHidden = false
    }
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code: Int, data: Data) {
        
        print("didFetchDataSuccess: data: \(data)")
        
        if let result = try? JSON(data: data){ // must be import SwiftyJSON
        
            let userToken = result["token"].stringValue
            print("didFetchDataSuccess: userToken: \(userToken)")
            
            // save in defaults that is user and his token
            defaults.set(false, forKey: C.isCraftsman)
            defaults.set(userToken, forKey: C.tokenUserAndCraftsman)
            
            // open app as user
            performSegue(withIdentifier: "SegueIDOpenAppUser", sender: self)
        }
    }
    
    // fetch data from server error - protocol FetchDataDelegate
    func didFetchDataError(code: Int, data: String) {
        showAlertDialog(title: "Error", message: "Niepoprawny token")
        
        // hide indicator and show button
        viewButtonLogIn.isHidden = false
        viewIndicator.isHidden = true
    }
    
    func showAlertDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    

}
