//
//  ViewControllerServices.swift
//  GoFix
//
//  Created by Wolf on 25/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit

class ViewControllerServices: UIViewController {
    
    var tableServices: [Services] = []
    var industryName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))

        print("services: \(tableServices)")

    }
    
}

// MARK: -
extension ViewControllerServices: UITableViewDelegate, UITableViewDataSource{
    // rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableServices.count
        
    }
    
    //data in cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDCellServices") as! TableViewCellServices
        // add text
        cell.viewLabel.text = tableServices[indexPath.row].name
        // check arrow in row
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    //f open view services
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = storyboard?.instantiateViewController(identifier: "IDStoryboardViewControllerUserOrder") as? ViewControllerUserOrder
        vc?.serviceID = tableServices[indexPath.row].id // pass data to next controller
        vc?.serviceName = tableServices[indexPath.row].name // pass data to next controller
        vc?.industryName = industryName // pass data to next controller
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
