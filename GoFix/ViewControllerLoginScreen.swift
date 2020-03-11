//
//  FirstViewController.swift
//  GoFix
//
//  Created by Wolf on 18/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON



class ViewControllerLoginScreen: UIViewController, FetchDataDelegate {

    
    // outlets
    @IBOutlet weak var editTextEmail: UITextField!
    @IBOutlet weak var editTextPassword: UITextField!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewButtonLogIn: UIButton!
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // defaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add delegate
        fetchData.delegate = self
        
        // navigation bar hide back button
        navigationItem.hidesBackButton = true
    }
    
    

    // button to open gofix.pl
    @IBAction func buttonForgotPassword(_ sender: UIButton) {
        if let url = URL(string: "https://www.gofix.pl") {
            UIApplication.shared.open(url)
        }
    }
    
    
    //button login
    @IBAction func buttonLogIn(_ sender: UIButton) {
        
        // check that edit text are not empty
        if editTextEmail.text == "" {
            showAlertDialog(message: "Wpisz e-mail")
            return
        }
        // check that edit text are not empty
        if editTextPassword.text == "" {
            showAlertDialog(message: "Wpisz hasło")
            return
        }

        let urlSerwer:String = "\(C.API)user/auth" // login user endpoint
        let email = editTextEmail.text!
        let password = editTextPassword.text!
        
        // add parameters to send on serwer - request object
        let parameters: [String: Any] = ["email": email, "password": password] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject

        // fetch data func
        fetchData.postData(urlSerwer: urlSerwer, parameters: parameters)
        
        // hide button and show indicator
        viewButtonLogIn.isHidden = true
        viewIndicator.isHidden = false
    }
    
    // button register as craftsman
    @IBAction func buttonRegisterCraftsman(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueIDRegisterCraftsman", sender: self)
    }
    
    // button register as user
    @IBAction func buttonRegisterUser(_ sender: Any) {
        performSegue(withIdentifier: "SegueIDRegisterUser", sender: self)
    }
    
    
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code:Int, data:Data) {
        print("Class ViewControllerLoginScreen: code: \(code), data Success: \(data)")
        if let result = try? JSON(data: data){ // must be import SwiftyJSON
            
            // add to defaults is craftsman or user
            let is_craftsman = result["is_craftsman"].bool!
            print("is_craftsman: \(is_craftsman)")
            defaults.set(is_craftsman, forKey: C.isCraftsman)
                
            // add to defaults token
            let token = result["token"].stringValue
            print(token)
            defaults.set(token, forKey: C.tokenUserAndCraftsman)
            
            //open app
            if is_craftsman {
                performSegue(withIdentifier: "SegueIDOpenAppCraftsmanFromLogin", sender: self)
            } else {
                performSegue(withIdentifier: "SegueIDOpenAppUserFromLogin", sender: self)
            }
        }
        
        // hide indicator and show button
        viewButtonLogIn.isHidden = false
        viewIndicator.isHidden = true
    }
    
    // fetch data from server error - protocol FetchDataDelegate
    func didFetchDataError(code:Int, data: String) {
        showAlertDialog(message: data)
        
        // hide indicator and show button
        viewButtonLogIn.isHidden = false
        viewIndicator.isHidden = true
    }
    
    // create alert dialog
    func showAlertDialog(message: String){
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil)) // nic nie robi tylko zamyka alert
        present(alert, animated: true)
    }
    
}

