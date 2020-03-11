//
//  SecondViewController.swift
//  GoFix
//
//  Created by Wolf on 18/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewControllerIndustries: UIViewController, FetchDataDelegate {
    
    // views outlets
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    
    // view Table
    @IBOutlet weak var viewTable: UITableView!
    
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // defaults
    let defaults = UserDefaults.standard
    
    // table with all industries and services
    var tableIndustries: [Industries] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))
        
        // add delegate
        fetchData.delegate = self
        
        // fetch data func
        let urlSerwer:String = "\(C.API)industries" // login user endpoint
        fetchData.getData(urlSerwer: urlSerwer)
        
        // show indicator
        viewIndicator.isHidden = false
        
    }
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code:Int, data:Data) {
        print("code: \(code), data Success: \(data)")
        if let result = try? JSON(data: data){ // must be import SwiftyJSON

            // get Industries
            for i in 0...result.count-1 {
                let currentItem = result[i]
                let icon = currentItem["icon"].stringValue
                let id = currentItem["id"].intValue
                let name = currentItem["name"].stringValue
                let services = currentItem["services"]
                
                var tableServices: [Services] = []
                
                // get services in current Industries
                for j in 0...services.count-1 {
                    let currentItemArray = services[j]
                    let id = currentItemArray["id"].intValue
                    let industry_id = currentItemArray["industry_id"].intValue
                    let name = currentItemArray["name"].stringValue
                    
                    // add service item to table
                    let serviceItem = Services(id: id, industry_id: industry_id, name:  name)
                    tableServices.append(serviceItem)
                }
                // add industry item to table
                let industryItem = Industries(icon: icon, id: id, name: name, services: tableServices)
                tableIndustries.append(industryItem)
                

                
            }
        }
        viewTable.reloadData() // update viewTable
        //print("moje industry i services: \(tableIndustries.description)")
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


// MARK: -
extension ViewControllerIndustries: UITableViewDelegate, UITableViewDataSource{
    // rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableIndustries.count
        
    }
    
    //data in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDCellIndustries") as! TableViewCellIndustries
        // add image
        cell.viewImage.image = UIImage(imageLiteralResourceName: tableIndustries[indexPath.row].icon)
        // add text
        cell.viewLabel.text = tableIndustries[indexPath.row].name
        // check arrow in row
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    // open view services
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = storyboard?.instantiateViewController(identifier: "IDStoryboardViewControllerServices") as? ViewControllerServices
        vc?.tableServices = tableIndustries[indexPath.row].services// pass data to next controller
        vc?.industryName = tableIndustries[indexPath.row].name// pass data to next controller
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
