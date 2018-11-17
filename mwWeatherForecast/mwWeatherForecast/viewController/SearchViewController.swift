//
//  SearchViewControllerTableViewController.swift
//  mwWeatherForecast
//
//  Created by Matteo on 11/11/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit
import CoreLocation
class SearchViewController: UITableViewController {


    @IBOutlet weak var btn_lookup: UIButton!
    
    @IBOutlet weak var btn_dismiss: UIButton!
    
    @IBOutlet weak var texField: UITextField!
    
    @IBOutlet weak var lbl_whereYouAre: UILabel!
    var whereYouAre: String = ""
    var lattlong: String = ""
    
    @IBOutlet weak var btn_checkGPS: UIButton!
    
    var localizationsArray: [Location] = []
    
    var chosenCity: String = ""
    
    let geoCoder = CLGeocoder()
    var gpsStudio: GPSstudio?
    //let serialQueue = DispatchQueue(label: "gpsSerialQueue") // if gps was handled by different thread
    var locationAquired = CLLocation()
    
    //for notyfing user when location is confirmed by API, but doesn't provide any daily forecasts
    var notifyUser: Bool = false
    var notifyString: String = ""
    
    func setLocationAquired(location: CLLocation){
        //serialQueue.sync {
        self.locationAquired = location
        updateView()
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.notifyUser){
            self.showToast(message: self.notifyString)
        }
        self.gpsStudio = GPSstudio(view: self)
        self.gpsStudio?.startGPSservice()
       
    }

    
    func updateView(){
        self.geoCoder.reverseGeocodeLocation(locationAquired) { (placemarks, error) in
            if let place = placemarks?.first{
                self.whereYouAre = place.locality!
                self.lattlong = "\(self.locationAquired.coordinate.latitude)"
                self.lattlong += ",\(self.locationAquired.coordinate.longitude)"
                self.lbl_whereYouAre.text = place.compactAddress //"Jesteś w " + String(place.thoroughfare) + " " + String(place.postalCode) + " " + String(place.locality)
            }
        }
    }
    
    @IBAction func weather_onGPS_pressed(_ sender: Any) {
        WeatherForecastStudio.findLocationsByName(name: self.whereYouAre) { (locations, error) in
            if let locats = locations {
                print(String(locats.count))
                
                if(locats.count == 1){  //Users GPS location is found by weather API - return to master to request for weather forecast
                    
                    self.chosenCity = (locats.first?.title)!
                    self.performSegue(withIdentifier: "unwindToMaster", sender: self)
                    
                } else {
                    
                    if(locats.count == 0){  //Users GPS location is NOT found by weather API -  supposed to find the closest locations
                        
                        WeatherForecastStudio.findLocationsByCoordinates(lattlong: self.lattlong) { (locations2, error2) in
                            if let locats2 = locations2 {
                                
                                self.localizationsArray = locats2
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }else{
                                print(error2!)
                                return
                            }
                        }
                    } else { // More than 1 localization from geocoded GPS position name
                        self.localizationsArray = locats
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }else{
                print(error!)
                return
            }
        }
    }
    
    @IBAction func lookup_pressed(_ sender: Any) {
        WeatherForecastStudio.findLocationsByName(name: texField.text!) { (locations, error) in
            if let locats = locations {
                
                self.localizationsArray = locats
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }else{
                print(error!)
                return
            }
        }
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.localizationsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)

        cell.textLabel?.text = self.localizationsArray[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        self.chosenCity = self.localizationsArray[indexPath.row].title!
        performSegue(withIdentifier: "unwindToMaster", sender: self)
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMaster" {
         //   self.gpsStudio?.stopGPSservice()
            //let masterView = segue.destination as! MasterViewController
            
            //masterView.newLocation = true
            //masterView.newLocationName = self.chosenCity
            //masterView.addNewLocation(name: self.chosenCity)
            
        }
    }*/

    

}

extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
        var result = name
            
            result = "Jesteś w "
        
            if let city = locality {
                //print(city)
                result += "\(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        return nil
    }
}
// SOURCE  https://stackoverflow.com/questions/31540375/how-to-toast-message-in-swift
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
