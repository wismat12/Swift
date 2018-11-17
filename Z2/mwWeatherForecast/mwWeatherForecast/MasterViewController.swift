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
    
    var firstInit: Bool = true
    var newLocation: Bool = false
    var newLocationName: String = ""
    @IBOutlet weak var btn_newCitySearching: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
        if firstInit {
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
            firstInit = false
            
        }/*
        if(newLocation && !firstInit){
            WeatherForecastStudio.addLocationForecastsToArray(name: newLocationName, completionHandler: { (returned) in
                if returned == true {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
            newLocation = false
            newLocationName = ""
        }*/
        
    }
    
    func addNewLocation(name: String){
        WeatherForecastStudio.addLocationForecastsToArray(name: name, completionHandler: { (returned) in
            if returned == true {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
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
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
