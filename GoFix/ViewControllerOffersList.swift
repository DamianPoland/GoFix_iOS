//
//  ViewControllerOffersCraftsman.swift
//  GoFix
//
//  Created by Wolf on 06/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewControllerOffersList: UIViewController, FetchDataDelegate, FetchDataSecondDelegate {

    // view outlets
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var viewNoOrders: UILabel!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTable: UITableView!
    
    // get titule from previous view ViewControllerOffers
    var titleToShow = ""
    var url = ""
    
    // need to send craftsman offer
    var orderId = 0 // user order ID
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // object to LoadData
    var fetchDataSecond = FetchDataSecond()
    
    // defaults
    let defaults = UserDefaults.standard
    
    // table with all industries and services
    var tableOffers: [CraftsmanOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // put titule text from previous view
        viewTitle.text = titleToShow
        
        // reload and refresh view
        refreshView()
        
    }
    
    func refreshView() {
        // add delegate
        fetchData.delegate = self
        
        // fetch data func
        let urlSerwer:String = "\(C.API)\(url)" // login user endpoint
        fetchData.getData(urlSerwer: urlSerwer)
        
        // show indicator
        viewIndicator.isHidden = false
    }
    
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code:Int, data:Data) {
        print("Class ViewControllerOffersList code: \(code), data Success: \(data)")
        if let result = try? JSON(data: data){ // must be import SwiftyJSON
            
            // if are any orders
            if result.count != 0 {
                
                //clear table
                tableOffers.removeAll()
                
                // get user orders
                for i in 0...result.count-1 {
                    let currentItem = result[i]

                    // if client_name not exist (="") than it is all ofers list - if exist than rest of lists
                    var name = ""
                    if currentItem["client_name"].stringValue == "" {
                        name = "Kategoria:: \(currentItem["service_name"].stringValue)"
                    } else {
                        name = "Nazwa: \(currentItem["client_name"].stringValue)"
                    }
                    let city = "Miasto: \(currentItem["city"].stringValue)"
                    let description = "Opis: \(currentItem["description"].stringValue)"
                    let order_id = currentItem["id"].intValue
                    
                    // add  items to table
                    let craftsmanOrder = CraftsmanOrder(name: name, city: city, description: description, order_id: order_id)
                    tableOffers.append(craftsmanOrder)
                    
                    viewTable.reloadData() // update viewTable
                    viewNoOrders.isHidden = true // if is more than zero orders than hide
                }
            }
        }
        // hide indicator
        self.viewIndicator.isHidden = true
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
    
    
    // MARK: - sent craftsman offer
    // create alert dialog with send craftman offer to serwer
    func showAlertDialogWithCraftsmanOfferToSend(){
        let alert = UIAlertController(title: "Oferta", message: "Czy chcesz wysłać ofertę do tego zlecenia?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil)) // do nothing
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertData) in
            
            // send craftsman offer
            let urlSerwer:String = "\(C.API)craftsman/offer" // login user endpoint
            // add parameters to send on serwer - request object
            let parameters: [String: Any] = ["orderId": self.orderId, "details": "empty", "price": 0 ] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject
            
            // fetch data func - send to server rating
            self.fetchDataSecond.delegate = self // add delegate
            self.fetchDataSecond.postDataSecond(urlSerwer: urlSerwer, parameters: parameters)
            
            // show indicator
            self.viewIndicator.isHidden = false
        }))
        present(alert, animated: true)
    }
    
    // fetch data from server success - protocol FetchDataDelegate SECOND
    func didFetchDataSuccessSecond(code:Int, data:Data) {
        print("Class ViewControllerOffersList SECOND code: \(code), data Success: \(data)")

        // after back to view and get response reload
        refreshView()
    }
    
    // fetch data from server error - protocol FetchDataDelegate SECOND
    func didFetchDataErrorSecond(code:Int, data: String) {
        print("Class ViewControllerOffersList SECOND code: \(code), data Error: \(data)")
        showAlertDialog(title: "Code: \(code)", message: data)
    }

}



// MARK: -
extension ViewControllerOffersList: UITableViewDelegate, UITableViewDataSource{
    // rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableOffers.count
        
    }
    
    //data in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdCellOffersList") as! TableViewCellCraftsmanOffersList
        // add text
        cell.viewName.text = tableOffers[indexPath.row].name
        cell.viewCity.text = tableOffers[indexPath.row].city
        cell.viewDescription.text = tableOffers[indexPath.row].description
        return cell
    }
    
    // open alert if is list with all user affers
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if is list with open orders than after click can send craftsman offer
        if url == "craftsman/orders/open" {
            
            // if balance is 0 than not allow to sent offer
            if defaults.integer(forKey: C.currentBalance) == 0 {
                showAlertDialog(title: "Info", message: "Aby wysłać ofertę musisz doładować konto.")
                return
            }
            
            orderId = tableOffers[indexPath.row].order_id
            showAlertDialogWithCraftsmanOfferToSend()
        }
        tableView.deselectRow(at: indexPath, animated: true) // auto click out cell
    }
}
