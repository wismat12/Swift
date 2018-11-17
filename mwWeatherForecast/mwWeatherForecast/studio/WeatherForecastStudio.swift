//
//  WeatherForecastStudio.swift
//  mwWeatherForecast
//
//  Created by Matteo on 17/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit



class WeatherForecastStudio{
    
    static let warsawLocationSearch = "https://www.metaweather.com/api/location/search/?lattlong=52.235352,21.009390"
    static let budapestLocationSearch = "https://www.metaweather.com/api/location/search/?lattlong=47.506222,19.064819"
    static let barcelonaLocationSearch = "https://www.metaweather.com/api/location/search/?query=barcelona"

    static var locationForecastsArray = [[WeatherDay]]()
    
    static let urlPath = "https://api.darksky.net/forecast//"
    
    static var firstInit: Bool = true
    
    enum definedError: Error{
        case urlError(message: String)
        case parsingError(message: String)
    }
    
    static func findLocationsByName(name: String, completionHandler: @escaping ([Location]?, Error?) -> Void){
        
        let myPath = "https://www.metaweather.com/api/location/search/?query=" + name //urlPath + lat + "," + long + "?units=si"//
        
        let updatedUrl = myPath.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        guard let myURL = URL(string: updatedUrl!) else{
            let error = definedError.urlError(message: "error with creating URL")
            completionHandler(nil, error)
            return
        }
        let myrequest = URLRequest(url: myURL)
        let mySession = URLSession.shared
        
        let myTask = mySession.dataTask(with: myrequest, completionHandler: {
            (data:Data?, response:URLResponse?, error:Error?) in
            guard let receivedData = data else{
                let error = definedError.parsingError(message: "error with obtaining data from response")
                completionHandler(nil, error)
                return
            }
            var locationsArray: [Location] = []
            do {
                if let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as? [[String: Any]]{
                    for loca in json{
                        if let location = Location(jsonDict: loca){
                            locationsArray.append(location)
                        }
                    }
                    completionHandler(locationsArray, nil)
                }
            }catch{
                completionHandler(nil, error)
                return
            }
        })
        myTask.resume()
    }
    static func findLocationsByCoordinates(lattlong: String, completionHandler: @escaping ([Location]?, Error?) -> Void){
        
        let myPath = "https://www.metaweather.com/api/location/search/?lattlong=" + lattlong 
        
        let updatedUrl = myPath.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        guard let myURL = URL(string: updatedUrl!) else{
            let error = definedError.urlError(message: "error with creating URL")
            completionHandler(nil, error)
            return
        }
        let myrequest = URLRequest(url: myURL)
        let mySession = URLSession.shared
        
        let myTask = mySession.dataTask(with: myrequest, completionHandler: {
            (data:Data?, response:URLResponse?, error:Error?) in
            guard let receivedData = data else{
                let error = definedError.parsingError(message: "error with obtaining data from response")
                completionHandler(nil, error)
                return
            }
            var locationsArray: [Location] = []
            do {
                if let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as? [[String: Any]]{
                    for loca in json{
                        if let location = Location(jsonDict: loca){
                            locationsArray.append(location)
                        }
                    }
                    completionHandler(locationsArray, nil)
                }
            }catch{
                completionHandler(nil, error)
                return
            }
        })
        myTask.resume()
    }

    
    static func findLocationByName(name: String, completionHandler: @escaping (Location?, Error?) -> Void){
        
        let myPath = "https://www.metaweather.com/api/location/search/?query=" + name //urlPath + lat + "," + long + "?units=si"//
        
        let updatedUrl = myPath.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let myURL = URL(string: updatedUrl!) else{
            let error = definedError.urlError(message: "error with creating URL")
            completionHandler(nil, error)
            return
        }
        let myrequest = URLRequest(url: myURL)
        let mySession = URLSession.shared
        
        let myTask = mySession.dataTask(with: myrequest, completionHandler: {
            (data:Data?, response:URLResponse?, error:Error?) in
            guard let receivedData = data else{
                let error = definedError.parsingError(message: "error with obtaining data from response")
                completionHandler(nil, error)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: receivedData, options: []) as? [[String: Any]]{
                    if let location = Location(jsonDict: json[0]){
                        completionHandler(location, nil)
                    }
                }
            }catch{
                completionHandler(nil, error)
                return
            }
        })
        myTask.resume()
    }
  
    static func addLocationForecastsToArray(name: String,completionHandler: @escaping (Bool) -> Void){
        self.findLocationByName(name: name, completionHandler: { (output, error) in
            
            if let error = error {
                print(error)
                return
            }
            if let location = output {
                
                let coordinatesArray = location.latt_long?.split(separator: ",")
                
                self.prepareForecastForAllDays(lat: String(coordinatesArray![0]), long: String(coordinatesArray![1])) { (output2, error2) in
                    
                    if let error2 = error2 {
                        print(error2)
                        completionHandler(false)
                        return
                    }
                    if var dailyForecasts = output2 {
                
                        if dailyForecasts.count == 0 {
                            print("didn't recieve any daily forecasts!!")
                            completionHandler(false)
                            return
                        }
                        
                        dailyForecasts[0].location = location

                        self.locationForecastsArray.append(dailyForecasts)
                       completionHandler(true)
                    
                        
                    }else{
                        print(error!)
                        completionHandler(false)
                        return
                    }
                }
                print("Saving location from closure")
            }else{
                print(error!)
                return
            }
        })
    }

    
    static func prepareForecastForAllDays(lat: String, long: String, completionHandler: @escaping ([WeatherDay]?, Error?) -> Void){
        
        let myPath = urlPath + lat + "," + long + "?units=si"
        
        guard let myURL = URL(string: myPath) else{
            let error = definedError.urlError(message: "error with creating URL")
            completionHandler(nil, error)
            return
        }
        let myrequest = URLRequest(url: myURL)
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
