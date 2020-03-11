//
//  ViewControllerUserProfileChoseCraftsmanOffer.swift
//  GoFix
//
//  Created by Wolf on 02/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewControllerUserProfileChoseCraftsmanOffer: UIViewController, FetchDataDelegate, FetchDataSecondDelegate {

    // view outlets
    @IBOutlet weak var viewTable: UITableView!
    @IBOutlet weak var viewLackOfOrders: UILabel!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // object to LoadData
    var fetchDataSecond = FetchDataSecond()
    
    // defaults
    let defaults = UserDefaults.standard
    
    // table with all industries and services
    var tableUserOrdersChoseCraftsman: [CraftsmanOfferToShow] = []
    
    
    var orderID = "" // id order to send with URL
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))

        // add delegate
        fetchData.delegate = self
        
        // fetch data func
        let urlSerwer:String = "\(C.API)client/order/\(orderID)/offers" // login user endpoint
        fetchData.getData(urlSerwer: urlSerwer)
        
        // show indicator
        viewIndicator.isHidden = false
    }
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code:Int, data:Data) {
        print("Class ViewControllerUserProfileChoseCraftsmanOffer: code: \(code), data Success: \(data)")
        if let result = try? JSON(data: data){ // must be import SwiftyJSON
            
            // if are any orders
            if result.count != 0 {
                // get user orders
                for i in 0...result.count-1 {
                    let currentItem = result[i]
                    let offer_id = currentItem["id"].stringValue
                    let craftsman_name = currentItem["craftsman_name"].stringValue
                    let craftsman_rating_times_ten = currentItem["craftsman_rating"].doubleValue*10
                    let craftsman_rating = Double(round(craftsman_rating_times_ten))/10

                    // add  items to table
                    let orderUserItem = CraftsmanOfferToShow(offerID: offer_id, craftsmanName: craftsman_name, craftsmanRating: craftsman_rating)
                    tableUserOrdersChoseCraftsman.append(orderUserItem)
                    
                    viewLackOfOrders.isHidden = true // if is more than zero orders than hide info about no orders
                }
            }
        }
        viewTable.reloadData() // update viewTable
        
        // hide indicator
        viewIndicator.isHidden = true

    }
    
    // fetch data from server error - protocol FetchDataDelegate
    func didFetchDataError(code:Int, data: String) {
        showAlertDialog(title: "Class ViewControllerUserProfileChoseCraftsmanOffer: Code: \(code)", message: data)
        
        // hide indicator
        viewIndicator.isHidden = true
    }
    
    // create alert dialog
    func showAlertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil)) // nic nie robi tylko zamyka alert
        present(alert, animated: true)
    }
    // create alert dialog
    func showAlertDialogWithAction(offerID: String){
        let alert = UIAlertController(title: "Oferta", message: "Czy chcesz wybrać tego wykoanwcę do swojego zlecenia?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NIE", style: .cancel, handler: nil)) // nic nie robi tylko zamyka alert
        alert.addAction(UIAlertAction(title: "TAK", style: .default, handler: { (alert) in

            print("offerID: \(offerID)")
            
            // fetch data func
            let urlSerwer:String = "\(C.API)client/offer/\(offerID)/pick" // login user endpoint
            // add parameters to send on serwer - request object
            let parameters: [String: Any] = ["": ""] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject

            // add delegate
            self.fetchDataSecond.delegate = self
            
            // fetch data func - send to server chosed craftsman
            self.fetchDataSecond.putData(urlSerwer: urlSerwer, parameters: parameters)
            
            // show indicator
            self.viewIndicator.isHidden = false
            
        }))
        present(alert, animated: true)
    }
    
    // fetch data from server success - protocol FetchDataDelegate SECOND
    func didFetchDataSuccessSecond(code:Int, data:Data) {
        print("Class ViewControllerUserProfileChoseCraftsmanOffer SECOND code: \(code), data Success: \(data)")
        
        // hide indicator
        viewIndicator.isHidden = true

        // back to previous view
        self.navigationController?.popViewController(animated: true)
    }
    
    // fetch data from server error - protocol FetchDataDelegate SECOND
    func didFetchDataErrorSecond(code:Int, data: String) {
        print("Class ViewControllerUserProfileChoseCraftsmanOffer SECOND code: \(code), data Error: \(data)")
        
        // hide indicator
        viewIndicator.isHidden = true        
        showAlertDialog(title: "Code: \(code)", message: data)
    }
}


// MARK: - viewTable
extension ViewControllerUserProfileChoseCraftsmanOffer: UITableViewDelegate, UITableViewDataSource{
    // rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableUserOrdersChoseCraftsman.count
    }
    
    //data in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDCellUserOrdersChoseCraftsman") as! TableViewCellUserOrdersChoseCraftsmanOrder
        
        // add data to every textView
        cell.viewName.text = "Nazwa: \(tableUserOrdersChoseCraftsman[indexPath.row].craftsmanName)"
        cell.viewRating.text = "Ocena: \(tableUserOrdersChoseCraftsman[indexPath.row].craftsmanRating)"
        // if no rating yet
        if tableUserOrdersChoseCraftsman[indexPath.row].craftsmanRating == 0 {
            cell.viewRating.text = "Ocena: brak ocen"
        }
        
        return cell
    }
    
    // open next view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offerID = tableUserOrdersChoseCraftsman[indexPath.row].offerID
        showAlertDialogWithAction(offerID: offerID)
    }
}
