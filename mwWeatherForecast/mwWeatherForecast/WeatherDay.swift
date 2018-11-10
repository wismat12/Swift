//
//  WeatherDay.swift
//  mwWeatherForecast
//
//  Created by Student on 16.10.2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import Foundation

struct WeatherDay{
    
    let summary: String?
    let icon: String?
    let temperatureMin: Double?
    let temperatureMax: Double?
    let windSpeed: Double?
    let windBearing: Int?
    let precipIntensity: Double?
    let precipType: String?
    let pressure: Double?
    
    
    init?(jsonDict: [String: Any]){
        
        let summary = jsonDict["summary"] as? String
        let icon = jsonDict["icon"] as? String
        let temperatureMin = jsonDict["temperatureMin"] as? Double
        let temperatureMax = jsonDict["temperatureMax"] as? Double
        let windSpeed = jsonDict["windSpeed"] as? Double
        let windBearing = jsonDict["windBearing"] as? Int
        let precipType = jsonDict["precipType"] as? String
        let precipIntensity = jsonDict["precipIntensity"] as? Double
        let pressure = jsonDict["pressure"] as? Double
        self.summary = summary
        self.icon = icon
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        self.precipType = precipType
        self.precipIntensity = precipIntensity
        self.pressure = pressure
    }

}


