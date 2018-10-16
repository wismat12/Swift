//
//  ViewController.swift
//  mwWeatherForecast
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let myURL = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=50.068,-5.316")
    
    @IBOutlet weak var lbl_output1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: <#Any#>)
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    @IBAction func btn_getWeather(_ sender: Any) {
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: myURL!) { (data, response, err) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    lbl_output1.text = json
             
                } catch {
                    print("Could not serialise")
                }
                
            }
        }
        task.resume()
        
        
    }
    

}

