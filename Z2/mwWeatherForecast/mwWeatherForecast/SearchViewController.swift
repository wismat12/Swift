//
//  SearchViewControllerTableViewController.swift
//  mwWeatherForecast
//
//  Created by Matteo on 11/11/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {


    @IBOutlet weak var btn_lookup: UIButton!
    
    @IBOutlet weak var btn_dismiss: UIButton!
    
    @IBOutlet weak var texField: UITextField!
    
    var localizationsArray: [Location] = []
    
    var chosenCity: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func lookup_pressed(_ sender: Any) {
        WeatherForecastStudio.findLocationsByName(name: texField.text!) { (locations, error) in
            if let locats = locations {
                
                self.localizationsArray = locats
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }else{
                print(error!)
                return
            }
        }
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.localizationsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)

        cell.textLabel?.text = self.localizationsArray[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        self.chosenCity = self.localizationsArray[indexPath.row].title!
        performSegue(withIdentifier: "toMasterView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMasterView" {
            let masterView = segue.destination as! MasterViewController
            //masterView.newLocation = true
            //masterView.newLocationName = self.chosenCity
            masterView.addNewLocation(name: self.chosenCity)
            
        }
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
