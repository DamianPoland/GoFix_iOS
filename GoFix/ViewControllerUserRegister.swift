//
//  ViewControllerUserRegister.swift
//  GoFix
//
//  Created by Wolf on 24/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import UIKit


class ViewControllerUserRegister: UIViewController, FetchDataDelegate{
    
    
    // views outlets
    @IBOutlet weak var viewPickerRegions: UIPickerView!
    @IBOutlet weak var viewName: UITextField!
    @IBOutlet weak var viewEmail: UITextField!
    @IBOutlet weak var viewCity: UITextField!
    @IBOutlet weak var viewPassword: UITextField!
    @IBOutlet weak var viewConfirmPassword: UITextField!
    @IBOutlet weak var viewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewButtonRegistry: UIButton!
    
    // object to LoadDataProducts()
    var fetchData = FetchData()
    
    // list to picker
    var regionsPolishList: [RegionsPolishItem] = []
    
    // vars to register
    var region_ID: Int = 1 // defaulf number
    
    // defaults
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add delegate
        fetchData.delegate = self
        
        // picker delegates
        viewPickerRegions.delegate = self
        viewPickerRegions.dataSource = self
        
        // load list of regions
        let regionsPolish = RegionsPolish()
        regionsPolishList = regionsPolish.getRegions()
        
        // hide indicator
        viewIndicator.isHidden = true
    }
    
    // open back - ViewControllerLoginScreen
    @IBAction func backButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewControllerLoginScreenID") as! ViewControllerLoginScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonRegister(_ sender: UIButton) {
        
        // check that edit text are not empty
        if viewName.text == "" {
            showAlertDialog(title: "Info", message: "Wpisz Imię")
            return
        }
        if viewEmail.text == "" {
            showAlertDialog(title: "Info", message: "Wpisz email")
            return
        }
        if viewCity.text == "" {
            showAlertDialog(title: "Info", message: "Wpisz miasto")
            return
        }
        if viewPassword.text == "" {
            showAlertDialog(title: "Info", message: "Wpisz hasło")
            return
        }
        if viewPassword.text != viewConfirmPassword.text {
            showAlertDialog(title: "Info", message: "Hasła są różne")
            return
        }
        
        // take all data to register
        let userName = viewName.text
        let userEmail = viewEmail.text
        defaults.set(userEmail, forKey: C.userEmal) // write userEmail
        let userCity = viewCity.text
        let userPassword = viewPassword.text
        
        // send data to serwer
        let urlSerwer:String = "\(C.API)user/client"
        let parameters: [String: Any] = ["name": userName!, "email": userEmail!, "password": userPassword!, "regionId": region_ID, "city": userCity!] // if in AF.request add encoding: JSONEncoding.default than will create jsonObject

        // fetch data func
        fetchData.postData(urlSerwer: urlSerwer, parameters: parameters)
        print("fetchData.postData: name: \(userName!), email: \(userEmail!), password: \(userPassword!), regionId: \(region_ID), city: \(userCity!)")
        
        // hide button and show indicator
        viewButtonRegistry.isHidden = true
        viewIndicator.isHidden = false
    }
    
    // fetch data from server success - protocol FetchDataDelegate
    func didFetchDataSuccess(code: Int, data: Data) {
        
        // open view token
        performSegue(withIdentifier: "SegueIDOpenUserToken", sender: self)
    }
    
    // fetch data from server error - protocol FetchDataDelegate
    func didFetchDataError(code: Int, data: String) {
        showAlertDialog(title: "Error", message: "\(data)")
        
        // hide indicator and show button
        viewButtonRegistry.isHidden = false
        viewIndicator.isHidden = true
    }
    
    // create alert dialog
    func showAlertDialog(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

//MARK: - picker extension

extension ViewControllerUserRegister: UIPickerViewDataSource , UIPickerViewDelegate {

    // from UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of COLUMNS
    }
    // from UIPickerViewDataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regionsPolishList.count // number of ROWS
    }

    // call in every row of picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return regionsPolishList[row].region_name // add list
    }
    // call when chose some element
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        print("region: \(regionsPolishList[row].region_name), id: \(regionsPolishList[row].region_ID)")
        region_ID = regionsPolishList[row].region_ID
    }

}
