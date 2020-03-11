//
//  ViewControllerInfo.swift
//  GoFix
//
//  Created by Wolf on 18/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit

class ViewControllerInfo: UITableViewController {
    
    
    // views outlets
    @IBOutlet weak var viewVersion: UILabel!
    
    @IBOutlet weak var viewCellPrivacy: UITableViewCell!
    @IBOutlet weak var viewCellGoFix: UITableViewCell!
    @IBOutlet weak var viewCellWolfMobileApps: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))

        // get and show app version
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        viewVersion.text = appVersion
        
        // add indicators to cells
        viewCellPrivacy.accessoryType = .disclosureIndicator
        viewCellGoFix.accessoryType = .disclosureIndicator
        viewCellWolfMobileApps.accessoryType = .disclosureIndicator
    }
    
    // open url when click
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected \(indexPath.row)")
        
        // url adresses
        let urlArray = ["","https://gofix.pl/polityka-prywatnosci","https://gofix.pl/", "https://wolfmobileapps.com/pl/"]
        
        // open url
        let urlString = urlArray[indexPath.row]
        if let url = URL(string: urlString)
        {
            UIApplication.shared.open(url)
        }
    }
    


}


