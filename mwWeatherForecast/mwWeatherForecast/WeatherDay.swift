//
//  WeatherDay.swift
//  mwWeatherForecast
//
//  Created by Student on 16.10.2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import Foundation

struct WeatherDay{
    
    static let urlPath = "https://api.darksky.net/forecast/1775fb1b743817c2f9243911448cabe9/"
    
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
    
    enum definedError: Error{
        case urlError(message: String)
        case parsingError(message: String)
    }
    
    static func prepareForecastForAllDays(lat: String, long: String, completionHandler: @escaping ([WeatherDay]?, Error?) -> Void){
        
        let myPath = urlPath + lat + "," + long
        let myURL = URL(string: myPath)
        let myrequest = URLRequest(url: myURL!)
        let mySession = URLSession.shared
        
        let myTask = mySession.dataTask(with: myrequest, completionHandler: {
            (data:Data?, response:URLResponse?, error:Error?) in
            
            guard let receivedData = data else{
                let error = definedError.parsingError(message: "error with obtaining data from response")
                completionHandler(nil, error)
                return
            }
            
            var forecastDaysArray = [WeatherDay]()
        
            do {
                if let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as? [String: Any]{
                    
                    if let daily = json["daily"] as? [String: Any]{
                        
                        if let dataDailyArray = daily["data"] as? [[String: Any]]{
                            
                            for particularDay in dataDailyArray {
                                
                                if let weatherDay = WeatherDay(jsonDict: particularDay){
                                    forecastDaysArray.append(weatherDay)
                                }
                            }
                            
                        }
                    }
                    
                }
            }catch{
                completionHandler(nil, error)
                return
            }
            completionHandler(forecastDaysArray, nil)
            
            
        })
        myTask.resume()
        
      
        
        
    }
}


