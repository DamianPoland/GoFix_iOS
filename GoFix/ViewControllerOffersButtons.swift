//
//  ViewControllerOffers.swift
//  GoFix
//
//  Created by Wolf on 24/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit

class ViewControllerOffersButtons: UIViewController {
    
    var buttonNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))
    }
    
    // buttons
    @IBAction func buttonAllOrders(_ sender: UIButton) {
        buttonNumber = 1 // set before click to sent correct data
        performSegue(withIdentifier: "SegueIDCraftsmanOrders", sender: self)
    }
    
    @IBAction func buttonMyOrders(_ sender: UIButton) {
        buttonNumber = 2 // set before click to sent correct data
        performSegue(withIdentifier: "SegueIDCraftsmanOrders", sender: self)
    }
    
    @IBAction func buttonMyOrdersAccepted(_ sender: Any) {
        buttonNumber = 3 // set before click to sent correct data
        performSegue(withIdentifier: "SegueIDCraftsmanOrders", sender: self)
    }
    
    @IBAction func buttonMyOrdersHistory(_ sender: Any) {
        buttonNumber = 4 // set before click to sent correct data
        performSegue(withIdentifier: "SegueIDCraftsmanOrders", sender: self)
    }
    
    //func to send data to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewControllerOffersList {
            let vc = segue.destination as! ViewControllerOffersList
            
            switch buttonNumber {
            case 1:
                vc.titleToShow = "Wszystkie oferty w okolicy:"
                vc.url = "craftsman/orders/open" // url to all ofers in region
            case 2:
                vc.titleToShow = "Moje złożone zlecenia:"
                vc.url = "craftsman/orders/applied" // url to all ofers wher craftsman applien
            case 3:
                vc.titleToShow = "Moje zaakceptowane zlecenia:"
                vc.url = "craftsman/orders/picked" // url to all ofers accepted
            case 4:
                vc.titleToShow = "Moje zakończone zlecenia:"
                vc.url = "craftsman/orders/history" // url to all ofers in history
                
            default:
                print(" Error switch case not fit ")
            }
            
            
        }
    }
    
    
}
