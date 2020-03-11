//
//  ViewControllerUserOrder.swift
//  GoFix
//
//  Created by Wolf on 25/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit

class ViewControllerUserOrder: UIViewController, FetchDataDelegate {

    
    
    // views outlets
    @IBOutlet weak var vievIndustryAndServiceName: UILabel!
    @IBOutlet weak var viewTextView: UITextView!
    
    // vars from previous view
    var industryName: String = ""
    var serviceName: String = ""
    var serviceID: Int = -1
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar set logo
        navigationItem.titleView = UIImageView(image: UIImage(named: "gofix_small_transparent"))
        
        // show industry and service names in view
        vievIndustryAndServiceName.text = "\(industryName): \(serviceName)"
        
        // add delegate
        fetchData.delegate = self
    }
    
    // send data to server
    @IBAction func buttonSend(_ sender: Any) {
        
        let urlSerwer:String = "\(C.API)client/order"
        let description = viewTextView.text

        // add parameters to send on serwer - request object
        let parameters: [String: Any] = ["serviceId": serviceID, "description": description!] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject

        // fetch data func
        fetchData.postData(urlSerwer: urlSerwer, parameters: parameters)
    }
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code: Int, data: Data) {
        // clean text field
        viewTextView.text = ""
        
        // show alert
        showAlertDialog(title: "Powodzenie", message: "Zlecenie zostało wysłane")
        

    }
    
    // fetch data from server error - protocol FetchDataDelegate
    func didFetchDataError(code: Int, data: String) {
        showAlertDialog(title: "Error", message: "\(data)")
    }
    
    func showAlertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil)) // nic nie robi tylko zamyka alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            // back to previous view
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }


}
