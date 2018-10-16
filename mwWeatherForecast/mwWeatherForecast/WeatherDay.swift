//
//  WeatherDay.swift
//  mwWeatherForecast
//
//  Created by Student on 16.10.2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import Foundation

struct WeatherDay{
    
    static let urlPath = ""
    
    let summary: String
    let icon: String
    let temperatureMin: Double
    let temperatureMax: Double
    let windSpeed: Double
    let windBearing: Int
    let humidity: Double
    let pressure: Double
    
    
    init?(jsonDict: [String: Any]){
        
        guard let summary = jsonDict["summary"] as? String,
            let icon = jsonDict["icon"] as? String,
            let temperatureMin = jsonDict["temperatureMin"] as? Double,
            let temperatureMax = jsonDict["temperatureMax"] as? Double,
            let windSpeed = jsonDict["windSpeed"] as? Double,
            let windBearing = jsonDict["windBearing"] as? Int,
            let humidity = jsonDict["humidity"] as? Double,
            let pressure = jsonDict["pressure"] as? Double else {
                return nil
            }
        self.summary = summary
        self.icon = icon
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        self.humidity = humidity
        self.pressure = pressure
    }
    
    static func prepareForecast(long: String, lat: String, completionHandler: @escaping ([WeatherDay]) -> Void){
        
        let myPath = urlPath + lat + "," + long
        let myURL = URL(string: myPath)
        let myrequest = URLRequest(url: myURL!)
        
        let mySession = URLSession.shared
        
        let myTask = mySession.dataTask(with: myrequest, completionHandler: {
            (data:Data?, response:URLResponse?, error:Error?) in
            
            var daysArray: [WeatherDay]
            
            
        })
        myTask.resume()
        
      
        
        
    }
}


