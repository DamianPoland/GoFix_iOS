//
//  ViewControllerUser.swift
//  GoFix
//
//  Created by Wolf on 24/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON
import Cosmos // to stars view
import Firebase

class ViewControllerUserProfile: UIViewController, FetchDataDelegate, FetchDataSecondDelegate{

    
    // view outlets
    @IBOutlet weak var viewTable: UITableView! // view Table
    @IBOutlet weak var viewLackOfOrders: UILabel!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    
    // object to LoadData
    var fetchData = FetchData()
    
    // object to LoadData
    var fetchDataSecond = FetchDataSecond()
    
    // defaults
    let defaults = UserDefaults.standard
    
    // table with all industries and services
    var tableUserOrders: [UserOrders] = []
    
    // variables with rating
    var ratingGetFromAlert = 10.0 // to change this must change how much stars on the begining - is 10 because 5.0*2
    var orderId = ""
    
    
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
        // reload and refresh view
        refreshView()
    }
    
    // reload and refresh view
    func refreshView() {
        
        // add delegate
        fetchData.delegate = self
        
        // fetch data func
        let urlSerwer:String = "\(C.API)client/orders" // login user endpoint
        fetchData.getData(urlSerwer: urlSerwer)
        
        // show indicator
        viewIndicator.isHidden = false
    }
    
    @IBAction func buttonLogOut(_ sender: UIBarButtonItem) {
        // user LogOut
        userLogOut()
        }

    // open history orders
    @IBAction func buttonHistory(_ sender: Any) {
        performSegue(withIdentifier: "SegueIDOpenUserOrdersHistory", sender: self)
    }
    
    // user LogOut
    func userLogOut(){
        // fetch data func LogOut
        let urlSerwer:String = "\(C.API)user/logout" // logout user endpoint
        // add parameters to send on serwer - request object
        let parameters: [String: Any] = ["": ""] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject

        // fetch data func - send to server chosed craftsman
        self.fetchData.postData(urlSerwer: urlSerwer, parameters: parameters)
        
        // clean user token when logout
        defaults.set("", forKey: C.tokenUserAndCraftsman)
        
        // unwind segue to back to start screan after log out https://stackoverflow.com/questions/30052587/how-can-i-go-back-to-the-initial-view-controller-in-swift
        performSegue(withIdentifier: "IDUnvindToViewControllerUser", sender: self)
        
        print("LogOut")
    }

    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code:Int, data:Data) {
        print("Class ViewControllerUserProfile code: \(code), data Success: \(data)")
        if let result = try? JSON(data: data){ // must be import SwiftyJSON
            
            // if are any orders
            if result.count != 0 {
                
                //clear table
                tableUserOrders.removeAll()
                
                // get user orders
                for i in 0...result.count-1 {
                    let currentItem = result[i]
                    let orderId = "\(currentItem["id"].intValue)"
                    let nameService = currentItem["service_name"].stringValue
                    let description = currentItem["description"].stringValue
                    let craftsmanName = currentItem["craftsman_name"].stringValue
                    let craftsmanEmail = currentItem["craftsman_email"].stringValue
                    let craftsmanPhone = currentItem["craftsman_phone"].stringValue
                    
                    // dane w ofertach - jeśli closed_at == "" to znaczy że otwarte zlecenie a jak closed_at == "jakaś data" to zamknięte i przeniesione od historii
                    let offer_picked_at = currentItem["offer_picked_at"].stringValue
                    let closed_at = currentItem["closed_at"].stringValue
                    
                    // add  items to table
                    let orderUserItem = UserOrders(orderId: orderId, industryAndService: nameService, description: description, craftsmanName: craftsmanName, craftsmanEmail: craftsmanEmail, craftsmanPhone: craftsmanPhone, offer_picked_at: offer_picked_at, closed_at: closed_at)
                    tableUserOrders.append(orderUserItem)
                    
                    viewTable.reloadData() // update viewTable
                    viewLackOfOrders.isHidden = true // if is more than zero orders than hide
                }
            }
        }
        // hide indicator
        self.viewIndicator.isHidden = true
    }
    
    // fetch data from server error - protocol FetchDataDelegate
    func didFetchDataError(code:Int, data: String) {
        print("Class ViewControllerUserProfile code: \(code), data Error: \(data)")
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
    
    
    // MARK: - stars rating
    // create alert dialog with rating stars - must be import Cosmos from cocoapod
    func showAlertDialogFromTableViewCellUserOrders(title: String, message: String){
        let alert = UIAlertController(title: "Oceń\n\n\n", message: nil, preferredStyle: .alert)
        
        let ratingView = CosmosView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        ratingView.rating = 5 // how much stars on the begining
        ratingView.settings.starSize = 30 // Change the size of the stars
        ratingView.settings.emptyBorderColor = UIColor.black
        ratingView.settings.updateOnTouch = true
        ratingView.settings.fillMode = .half
        ratingView.frame.origin.x = alert.view.frame.width/2 - 160 // width from left
        ratingView.frame.origin.y = 60 // height stars from top of frame
        ratingView.didTouchCosmos = { rating in
            // save rating in variable
            self.ratingGetFromAlert = rating*2
            print("rating: \(self.ratingGetFromAlert)")
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Oceń", style: .default, handler: { (alert) in
            // send rating to serwer
            let urlSerwer:String = "\(C.API)client/review/order" // login user endpoint
            // add parameters to send on serwer - request object
            let parameters: [String: Any] = ["orderId": self.orderId, "rate": self.ratingGetFromAlert ] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject
            
            // fetch data func
            self.fetchDataFrom_AlertDialog(urlSerwer: urlSerwer, parameters: parameters)
        }))
        alert.view.addSubview(ratingView)
        self.present(alert, animated: true)
    }
    
    func fetchDataFrom_AlertDialog(urlSerwer: String, parameters: [String: Any]){
        // fetch data func - send to server rating
        fetchDataSecond.delegate = self // add delegate
        fetchDataSecond.postDataSecond(urlSerwer: urlSerwer, parameters: parameters)
    }
    
    // fetch data from server success - protocol FetchDataDelegate SECOND
    func didFetchDataSuccessSecond(code:Int, data:Data) {
        print("Class ViewControllerUserProfile SECOND code: \(code), data Success: \(data)")

        // after back to view and get response reload
        refreshView()
    }
    
    // fetch data from server error - protocol FetchDataDelegate SECOND
    func didFetchDataErrorSecond(code:Int, data: String) {
        print("Class ViewControllerUserProfile SECOND code: \(code), data Error: \(data)")
        showAlertDialog(title: "Code: \(code)", message: data)
    }
}

// MARK: - viewTable
extension ViewControllerUserProfile: UITableViewDelegate, UITableViewDataSource{
    // rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableUserOrders.count
    }
    
    //data in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("func tableView cellForRowAt indexPath is called \ntableUserOrders[indexPath.row].craftsmanName = \(tableUserOrders[indexPath.row].craftsmanName)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDCellUserOrders") as! TableViewCellUserOrders
        
        // if craftsman is not choddesd then hide button text views and show accessory indicator
        if tableUserOrders[indexPath.row].craftsmanName == "" {
            cell.viewAction.text = "Wybierz wykonawcę"
        } else {
            cell.viewAction.text = "Oceń wykonawcę"
        }
        
        // add data to every textView
        cell.viewIndustryAndService.text = tableUserOrders[indexPath.row].industryAndService
        cell.viewDescription.text = tableUserOrders[indexPath.row].description
        cell.viewCraftsmanName.text = "Nazwa: \(tableUserOrders[indexPath.row].craftsmanName)"
        cell.viewCraftsmanEmail.text = "E-mail: \(tableUserOrders[indexPath.row].craftsmanEmail)"
        cell.viewCraftsmanPhone.text = "Nr. telefonu: \(tableUserOrders[indexPath.row].craftsmanPhone)"
        
        return cell
    }
    
    // open next view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // if craftsman is chosen than no open new view
        if tableUserOrders[indexPath.row].craftsmanName != "" {
            
            // add variable to cell to button action - add rating
            orderId = tableUserOrders[indexPath.row].orderId
            showAlertDialogFromTableViewCellUserOrders(title: "Oceń wykonawcę", message: "")
            
            tableView.deselectRow(at: indexPath, animated: true) // auto click out cell
            return
        }
        
        // open view with craftsman offers
        let vc = storyboard?.instantiateViewController(identifier: "IDSoryboardUserProfileChoseCraftsmanOffer") as? ViewControllerUserProfileChoseCraftsmanOffer

        vc?.orderID = tableUserOrders[indexPath.row].orderId // sent orderId to next view ViewControllerUserProfileChoseCraftsmanOffer
        navigationController?.pushViewController(vc!, animated: true)

        tableView.deselectRow(at: indexPath, animated: true) // auto click out cell
    }
}

