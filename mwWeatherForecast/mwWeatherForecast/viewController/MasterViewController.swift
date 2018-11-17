//
//  MasterViewController.swift
//  mwWeatherForecast
//
//  Created by Student on 30.10.2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit
protocol CitySelectionDelegate: class {
    func citySelected(_ newCity: Int)
}

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_cellCity: UILabel!
    @IBOutlet weak var field_cellTemp: UITextField!
    @IBOutlet weak var img_cell: UIImageView!
    
}

class MasterViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var collapseDetailViewController = true
    weak var delegate: CitySelectionDelegate?
    
    
    var newLocation: Bool = false
    var newLocationName: String = ""
    @IBOutlet weak var btn_newCitySearching: UIButton!
    
    var noWeatherForecast: Bool = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
        
        if WeatherForecastStudio.firstInit {
            WeatherForecastStudio.addLocationForecastsToArray(name: "barcelona", completionHandler: { (returned) in
                if returned == true {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
            WeatherForecastStudio.addLocationForecastsToArray(name: "budapest", completionHandler: { (returned) in
                if returned == true {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
            WeatherForecastStudio.addLocationForecastsToArray(name: "warsaw", completionHandler: { (returned) in
                if returned == true {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
            WeatherForecastStudio.firstInit = false
        }
        
    }
    
    func addNewLocation(name: String){
        WeatherForecastStudio.addLocationForecastsToArray(name: name, completionHandler: { (returned) in
            if returned == true {
                self.noWeatherForecast = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.noWeatherForecast = true
                self.performSegue(withIdentifier: "toSearchView", sender: self)
            }
        })
    }
    
    @IBAction func unwindFromSearchVC(_ sender: UIStoryboardSegue){
        if( sender.source is SearchViewController){
            if let senderVC = sender.source as? SearchViewController {
                if(senderVC.chosenCity != ""){
                    print("Adding location in MasterVC \(senderVC.chosenCity)")
                    addNewLocation(name: senderVC.chosenCity)
                } else {
                    print("chosen city is null")
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ((segue.identifier == "toSearchView") && noWeatherForecast) {
            let searchView = segue.destination as! SearchViewController
            searchView.notifyUser = true
            searchView.notifyString = "Brak prognozy "
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //print("\n"+String(WeatherForecastStudio.locationForecastsArray.count))
        return WeatherForecastStudio.locationForecastsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CityTableViewCell

        // Configure the cell...
        cell.lbl_cellCity?.text = WeatherForecastStudio.locationForecastsArray[indexPath.row].first?.location?.title
        cell.img_cell?.image = UIImage(named: ((WeatherForecastStudio.locationForecastsArray[indexPath.row].first?.icon!)!))
        let temperature = ((WeatherForecastStudio.locationForecastsArray[indexPath.row].first?.temperatureMin)! + (WeatherForecastStudio.locationForecastsArray[indexPath.row].first?.temperatureMax)!)/2
        
        cell.field_cellTemp?.text = String(temperature)

        return cell
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let detail = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            detail.chosenCityIndex = indexPath!.row
        }
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let selectedCity = WeatherForecastStudio.locationForecastsArray[indexPath.row]
       delegate?.citySelected(indexPath.row)
        
        if let detailViewCOntroller = delegate as? DetailViewController,
            let detailNavigationController = detailViewCOntroller.navigationController{
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return self.collapseDetailViewController
    }
    



}
