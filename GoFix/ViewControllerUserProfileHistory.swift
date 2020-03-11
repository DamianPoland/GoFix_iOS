//
//  ViewControllerUserOrderHistory.swift
//  GoFix
//
//  Created by Wolf on 02/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewControllerUserProfileHistory: UIViewController, FetchDataDelegate {
    
    // vjiews outlets
    @IBOutlet weak var viewTable: UITableView!
    @IBOutlet weak var viewLackOfOrders: UILabel!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // defaults
    let defaults = UserDefaults.standard
    
    // table with all industries and services
    var tableUserOrdersHistory: [UserOrdersHistory] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))

        // add delegate
        fetchData.delegate = self
        
        // fetch data func
        let urlSerwer:String = "\(C.API)client/history" // login user endpoint
        fetchData.getData(urlSerwer: urlSerwer)
        
        // show indicator
        viewIndicator.isHidden = false
    }
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code:Int, data:Data) {
        print("code: \(code), data Success: \(data)")
        if let result = try? JSON(data: data){ // must be import SwiftyJSON

            // if are any orders history
            if result.count != 0 {
                // get user orders history
                for i in 0...result.count-1 {
                    let currentItem = result[i]
                    let nameService = currentItem["service_name"].stringValue
                    let description = currentItem["description"].stringValue
                    let craftsmanName = currentItem["craftsman_name"].stringValue
                    let craftsmanEmail = currentItem["craftsman_email"].stringValue
                    let craftsmanPhone = currentItem["craftsman_phone"].stringValue

                    // add  items to table
                    let orderUserHistoryItem = UserOrdersHistory(industryAndService: nameService, description: description, craftsmanName: craftsmanName, craftsmanEmail: craftsmanEmail, craftsmanPhone: craftsmanPhone)
                    tableUserOrdersHistory.append(orderUserHistoryItem)
                    
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

// MARK: - viewTable
extension ViewControllerUserProfileHistory: UITableViewDelegate, UITableViewDataSource{
    // rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableUserOrdersHistory.count
    }
    
    //data in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDCellUserOrdersHistory") as! TableViewCellUserOrdersHistory
        
        // add data to every textView
        cell.viewIndustryAndService.text = tableUserOrdersHistory[indexPath.row].industryAndService
        cell.viewDescription.text = tableUserOrdersHistory[indexPath.row].description
        cell.viewCraftsmanName.text = "Nazwa: \(tableUserOrdersHistory[indexPath.row].craftsmanName)"
        cell.viewCraftsmanEmail.text = "E-mail: \(tableUserOrdersHistory[indexPath.row].craftsmanEmail)"
        cell.viewCraftsmanPhone.text = "Nr. telefonu: \(tableUserOrdersHistory[indexPath.row].craftsmanPhone)"
        
        tableView.deselectRow(at: indexPath, animated: true) // auto click out cell
        
        return cell
    }
    
    // open next view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true) // auto click out cell
        
    }
}
