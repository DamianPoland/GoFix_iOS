//
//  ViewControllerStartScreen.swift
//  GoFix
//
//  Created by Wolf on 24/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit

class ViewControllerStartScreen: UIViewController {
    
    // defaults
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // go to app if user is logged
        if defaults.string(forKey: C.tokenUserAndCraftsman) ?? "" != "" {
            
            if defaults.bool(forKey: C.isCraftsman) { // open app if user is logged as craftsman
                performSegue(withIdentifier: "SegueIDOpenAppCraftsman", sender: self)
            } else { //open app if user is logged as user
                performSegue(withIdentifier: "SegueIDOpenAppUser", sender: self)
            }
            
        } else { // go to login screen if user is NOT logged
            // open login screen
            performSegue(withIdentifier: "SegueIDLoginScreen", sender: self)
        }
    }
    
    // for uwind segue - back here after log out https://stackoverflow.com/questions/30052587/how-can-i-go-back-to-the-initial-view-controller-in-swift
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        // no code needed
    }
}
