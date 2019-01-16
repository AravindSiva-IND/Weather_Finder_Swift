//
//  ViewController.swift
//  Whethermate
//
//  Created by MacMini3 on 12/11/18.
//  Copyright © 2018 MacMini3. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, CustomLocationDelegate {
    
    let weatherUrl = "http://api.openweathermap.org/data/2.5/weather"
    let weatherApiKey = "3f956eeb7a5f659bbace12cde348f623"
    
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    
    //Instance variables
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setup the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func btnNavSetLocation(_ sender: Any) {
        performSegue(withIdentifier: "toNext", sender: self)
    }
    
    
    //MARK: Networking
    func GetWeatherData(url:String, parameters:[String:String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print(response.result)
                
                let weatherJson: JSON = JSON(response.result.value!)
                self.UpdateWeatherData(json: weatherJson)
                
            }
            else {
                print("Error: \(String(describing: response.result.error))")
                self.lblCity.text = "check connection"
            }
        }
        
    }
    
    
    //MARK: Json Parsing
    func UpdateWeatherData(json: JSON) {
        
        if let currTemperature = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(currTemperature - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            UpdateUserInterface()
        }
        else {
            lblCity.text = "unavailable"
        }
    }
    
    //MARK: Update UI
    func UpdateUserInterface() {
        lblCity.text = weatherDataModel.city
        lblTemperature.text = "\(weatherDataModel.temperature)℃"
        imgWeather.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    //MARK: Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil  //stop getting location once fetched the lcoation details
            print("longitude: \(location.coordinate.longitude), latitude: \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String : String] = ["lat" : latitude, "lon" : longitude, "appId" : weatherApiKey]
            
            GetWeatherData(url: weatherUrl, parameters: params)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("couldn't retrieve location")
        print(error)
        lblCity.text = "Location unavailable"
    }
    
    //MARK: Change City Delegate Methods
    func locationFromUser(city: String) {
        print(city)
        let params : [String: String] = ["q" : city, "appid" : weatherApiKey]
        GetWeatherData(url: weatherUrl, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNext" {
            let destination = segue.destination as! SetLocationViewController
            destination.delegate = self
        }
    }
    
}

