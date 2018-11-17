//
//  GPSstudio.swift
//  mwWeatherForecast
//
//  Created by Matteo on 14/11/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit
import CoreLocation

class GPSstudio: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    let searchView: SearchViewController
    
    init?(view: SearchViewController){
        searchView = view
    }
   
    func startGPSservice(){
        if(CLLocationManager.locationServicesEnabled() == true) {
            
            if((CLLocationManager.authorizationStatus() == .restricted) ||
                (CLLocationManager.authorizationStatus() == .denied) ||
                (CLLocationManager.authorizationStatus() == .notDetermined)){
                    locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy =  100.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
            
            
        } else {
            print("Włącz GPS")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Problem z uzyskaniem Twojej lokalizacji")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        searchView.setLocationAquired(location: locations[0])
    }
    
    func stopGPSservice(){
        locationManager.stopUpdatingLocation()
    }

}
