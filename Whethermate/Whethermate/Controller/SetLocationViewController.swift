//
//  SetLocationViewController.swift
//  Whethermate
//
//  Created by MacMini3 on 12/11/18.
//  Copyright © 2018 MacMini3. All rights reserved.
//

import UIKit

protocol CustomLocationDelegate {
    func locationFromUser(city: String)
}

class SetLocationViewController: UIViewController {
    
    @IBOutlet weak var txtChangeCity: UITextField!
    @IBOutlet weak var btnGetWeather: UIButton!
    var delegate: CustomLocationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnGetWeather(_ sender: Any) {
        let cityName = txtChangeCity.text!
        delegate?.locationFromUser(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
