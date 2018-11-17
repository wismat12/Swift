//
//  Location.swift
//  mwWeatherForecast
//
//  Created by Matteo on 10/11/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import Foundation

struct Location: Hashable{
    
    let title: String?
    let latt_long: String?
    let location_type: String?
    
    
    init?(jsonDict: [String: Any]){
        
        let title = jsonDict["title"] as? String
        let latt_long = jsonDict["latt_long"] as? String
        let location_type = jsonDict["location_type"] as? String
    
        self.title = title
        self.latt_long = latt_long
        self.location_type = location_type
    
    }
    
}
