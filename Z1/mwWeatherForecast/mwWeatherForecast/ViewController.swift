//
//  ViewController.swift
//  mwWeatherForecast
//
//  Created by Student on 09/10/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //0 - today
    var currentDay = 0
    
    var dailyForecasts: [WeatherDay] = []
    var lat =  "42.3601"
    var long = "-71.0589"

    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var txtView_summary: UITextView!
    @IBOutlet weak var img_icon: UIImageView!
    
    @IBOutlet weak var txtField_Tmin: UITextField!
    @IBOutlet weak var txtField_Tmax: UITextField!
    @IBOutlet weak var txtField_Vwind: UITextField!
    @IBOutlet weak var txtField_WindBearing: UITextField!
    @IBOutlet weak var txtField_Pressure: UITextField!
    @IBOutlet weak var txtField_PrecipType: UITextField!
    @IBOutlet weak var txtField_PrecipIntensity: UITextField!
    
    @IBOutlet weak var btn_prev: UIButton!
    @IBOutlet weak var btn_next: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForecast()
     
    }
    
    @IBAction func btn_prev_Pressed(_ sender: Any) {
        self.currentDay = self.currentDay - 1
        if self.currentDay == 0 {
            self.btn_prev.isEnabled = false
        }
        self.btn_next.isEnabled = true
        DispatchQueue.main.async {
            self.updateFields()
        }
    }
    
  
    @IBAction func btn_next_Pressed(_ sender: Any) {
        self.currentDay = self.currentDay + 1
        if self.currentDay == self.dailyForecasts.count - 1 {
            self.btn_next.isEnabled = false
        }
        self.btn_prev.isEnabled = true
        DispatchQueue.main.async {
            self.updateFields()
        }
    }
    
    func prepareForecast(){
        WeatherForecastStudio.prepareForecastForAllDays(lat: self.lat, long: self.long) { (output, error) in
      
                if let error = error {
                    print(error)
                    return
                }
                if let dailyForecasts = output {
                    
                    if dailyForecasts.count == 0 {
                        print("didn't recieve any daily forecasts!!")
                        DispatchQueue.main.async {
                             self.lbl_date.text = "didn't recieve any daily forecasts!!"
                        }
                        return
                    }
                    
                    if dailyForecasts.count > 1 {
                        DispatchQueue.main.async {
                            self.btn_next.isEnabled = true
                        }
                    }
                    self.dailyForecasts = dailyForecasts
                    print("Saving array from closure" + "\(self.dailyForecasts.count)")
                    
                    DispatchQueue.main.async {
                        self.updateFields()
                    }
                    
                }else{
                    print(error!)
                    return
                }
        }
    }
    
    func getParticularDayForecast(number: Int) -> WeatherDay {
      
        return self.dailyForecasts[number]
    }
    
    func updateFields(){
        
        let day = self.getParticularDayForecast(number: self.currentDay)
        //print(day?.icon)
        self.lbl_date.text = getDateAsString(dayNumber: self.currentDay)
        self.txtView_summary.text = day.summary
        self.img_icon.image = UIImage(named: day.icon!)
        self.txtField_Tmin.text = day.temperatureMin != nil ? "\(day.temperatureMin!) C" : "none"
        self.txtField_Tmax.text = day.temperatureMax != nil ? "\(day.temperatureMax!) C" : "none"
        self.txtField_Vwind.text = day.windSpeed != nil ? "\(day.windSpeed!) m/s" : "none"
        self.txtField_Pressure.text = day.pressure != nil ? "\(day.pressure!) hPa" : "none"
        self.txtField_PrecipType.text = day.precipType
        self.txtField_PrecipIntensity.text = day.precipIntensity != nil ? "\(day.precipIntensity!) mm/h" : "none"
        
        let windDirs: [String] = ["N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW","N"]
        
        self.txtField_WindBearing.text = day.windBearing != nil ?
            "\(windDirs[Int(round(Double((day.windBearing)! % 360)/22.5))])" : "none"
        
    }
    
    func getDateAsString(dayNumber: Int) -> String{
        let rawDate = Calendar.current.date(byAdding: .day, value: dayNumber, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        
        return dateFormatter.string(from: rawDate!)
        
    }
    
    

}

