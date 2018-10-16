//
//  ViewController.swift
//  mwWeatherForecast
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherDay.prepareForecastForAllDays(lat: "42.3601", long: "-71.0589") { (output, error) in
            
            if let error = error {
                print(error)
                return
            }
            if let dailyForecasts = output {
                //jesli results length null
                for result in dailyForecasts {
                    print("\(result)\n\n")
                }
                
            }else{
                print(error!)
                return
            }
           
        }

    }
    
  
    

}

