//
//  ViewControllerCraftsmanRegisterServicesToChose.swift
//  GoFix
//
//  Created by Wolf on 11/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewControllerCraftsmanRegisterServicesToChose: UIViewController, FetchDataDelegate {
    
    // views outlets
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTable: UITableView!
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // defaults
    let defaults = UserDefaults.standard
    
    // list to picker with all industries and services
    var tableIndustriesAndServices: [IndustriesAndServices] = [] //table to show in viewTable
    
    var listOfServicesChosen: [Int] = [] // starting list to save to notifications

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add delegate
        fetchData.delegate = self
        
        // fetch data func to load industries and services
        let urlSerwer:String = "\(C.API)industries" // login user endpoint
        fetchData.getData(urlSerwer: urlSerwer)
        
        // hide indicatorSecond
        viewIndicator.isHidden = false
    }
    
    // button save listOfServicesChosen and close view modally
    @IBAction func buttonSave(_ sender: Any) {
        // pass listOfServices to ViewControllerCraftsmanRegister when close view
        if let navController = presentingViewController as? UINavigationController {
            let presenter = navController.topViewController as! ViewControllerCraftsmanRegister // this is viewController to back
            presenter.listOfServices = listOfServicesChosen // listOfServices this is var in ViewControllerCraftsmanRegister
        }
        dismiss(animated: true, completion: nil) // dismiss view
    }
    
    

    //MARK: - fetch Industries
    // fetch data from server success - protocol FetchDataSecondDelegate
    func didFetchDataSuccess(code:Int, data:Data) {
        print("code: \(code), data Success: \(data)")
        
        // clear table
        tableIndustriesAndServices.removeAll()
        
        if let result = try? JSON(data: data){ // must be import SwiftyJSON

            // get Industries
            for i in 0...result.count-1 {
                let currentItem = result[i]
                
                let industry_id = currentItem["id"].intValue
                let industry_name = currentItem["name"].stringValue
                let services = currentItem["services"]
                
                // get services in current Industries
                for j in 0...services.count-1 {
                    let currentItemArray = services[j]
                    let service_id = currentItemArray["id"].intValue
                    let service_name = currentItemArray["name"].stringValue
                    
                    // add service item to table
                    let industryAndServiceItem = IndustriesAndServices(industry_id: industry_id, industry_name: industry_name, service_id: service_id, service_name: service_name)
                    tableIndustriesAndServices.append(industryAndServiceItem)
                }
            }
        }
        // hide indicatorSecond
        viewIndicator.isHidden = true
        // reload data in table
        viewTable.reloadData()
    }
    
    // fetch data from server error - protocol FetchDataSecondDelegate
    func didFetchDataError(code:Int, data: String) {
        showAlertDialog(title: "Code: \(code)", message: data)
        
        // hide indicatorSecond
        viewIndicator.isHidden = true
    }
    
    // create alert dialog
    func showAlertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - table view
extension ViewControllerCraftsmanRegisterServicesToChose: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableIndustriesAndServices.count //  how many rows
    }
    
    // call in every cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDCellServicesToNotifications") as! TableViewCellServicesToNotifications

        // add text to cell
        cell.viewLabel.text = "\(tableIndustriesAndServices[indexPath.row].industry_name): \(tableIndustriesAndServices[indexPath.row].service_name)"
        
        return cell
    }
    
    //func when click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("row selected witch service_id: \(tableIndustriesAndServices[indexPath.row].service_id)")
        
        if viewTable.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark { // if row is checked
            viewTable.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none // uncheck row
            
            if let index = listOfServicesChosen.firstIndex(of: tableIndustriesAndServices[indexPath.row].service_id) { // remove element from list
                listOfServicesChosen.remove(at: index)
                print(listOfServicesChosen)
            }
            
        } else { // if row is not chcked
            viewTable.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark // check row
            listOfServicesChosen.append(tableIndustriesAndServices[indexPath.row].service_id) // add element to list
            print(listOfServicesChosen)
        }

        // deselect after click
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

