//
//  WeatherForecastStudio.swift
//  mwWeatherForecast
//
//  Created by Matteo on 17/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit

class WeatherForecastStudio{
    
    static let urlPath = "https://api.darksky.net/forecast/1775fb1b743817c2f9243911448cabe9/"
    
    enum definedError: Error{
        case urlError(message: String)
        case parsingError(message: String)
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
