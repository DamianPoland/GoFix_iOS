//
//  ViewControllerCraftsman.swift
//  GoFix
//
//  Created by Wolf on 24/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase

class ViewControllerCraftsmanProfile: UIViewController, FetchDataDelegate {
    
    
    // views outlets
    @IBOutlet weak var viewName: UILabel!
    @IBOutlet weak var viewEmail: UILabel!
    @IBOutlet weak var viewRating: UILabel!
    @IBOutlet weak var viewPoints: UILabel!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // defaults
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))
        
        // Fetching the current registration token for NOTIFICATIONS
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            
            let urlSerwer:String = "\(C.API)user/mobile" // logout user endpoint
             // add parameters to send on serwer - request object
            let parameters: [String: Any] = ["token_notifications": result.token] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject

             // fetch data func - send to server token to notifications - no delegat added
            let fetchDataSecondWithoutDelegate = FetchDataSecond()
            fetchDataSecondWithoutDelegate.putData(urlSerwer: urlSerwer, parameters: parameters)
          }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // add delegate
        fetchData.delegate = self
        
        // fetch data func
        let urlSerwer:String = "\(C.API)user/preferences" // login user endpoint
        fetchData.getData(urlSerwer: urlSerwer)
        
        // show indicator
        viewIndicator.isHidden = false
    }
    
    // button to change data - link to web
    @IBAction func buttonChangeData(_ sender: Any) {
        if let url = URL(string: "https://www.gofix.pl") {
            UIApplication.shared.open(url)
        }
    }
    
    // button Log Out
    @IBAction func buttonLogOut(_ sender: UIBarButtonItem) {
        // user LogOut
        userLogOut()
    }
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code:Int, data:Data) {
        print("Class ViewControllerCraftsmanProfile: code: \(code), data Success: \(data)")
        if let result = try? JSON(data: data){ // must be import SwiftyJSON

            // get data and put to views
            viewName.text = "Nazwa: \(result["name"].stringValue)"
            viewEmail.text = "E-mail: \(result["email"].stringValue)"
            let ratingTaken = result["rating"].doubleValue
            if ratingTaken == 0 {
                viewRating.text = "Moja ocena: brak ocen"
            } else {
                let ratingTimesTen = (ratingTaken)*10
                let rating = Double(round(ratingTimesTen))/20 // devided by 20 not 10 because rating is 1-10 in serwer and for user 0.5-5
                viewRating.text = "Moja ocena: \(rating)"
            }
            viewPoints.text = "Punkty: \(result["balance"].intValue)"
            defaults.set(result["balance"].intValue, forKey: C.currentBalance)

            
        }
        // hide indicator
        viewIndicator.isHidden = true
    }
    
    // user LogOut
    func userLogOut() {
        // fetch data func LogOut
        let urlSerwer:String = "\(C.API)user/logout" // logout user endpoint
        // add parameters to send on serwer - request object
        let parameters: [String: Any] = ["": ""] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject

        // fetch data func - send to server chosed craftsman
        self.fetchData.postData(urlSerwer: urlSerwer, parameters: parameters)
        
        // clean user token when logout
        defaults.set("", forKey: C.tokenUserAndCraftsman)
        
        // unwind segue to back to start screan after log out https://stackoverflow.com/questions/30052587/how-can-i-go-back-to-the-initial-view-controller-in-swift
        performSegue(withIdentifier: "IDUnvindToViewControllerCraftsman", sender: self)
        
        print("LogOut")
    }
    
    // fetch data from server error - protocol FetchDataDelegate
    func didFetchDataError(code:Int, data: String) {
        
        // if code is unauthenticated that auto log out
        if code == 401 {
                    // user LogOut
            userLogOut()
            return
        }
        
        showAlertDialog(title: "Code: \(code)", message: data)
        
        // hide indicator
        viewIndicator.isHidden = true
    }
    
    // create alert dialog
    func showAlertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil)) // nic nie robi tylko zamyka alert
        present(alert, animated: true)
    }
    
}
