//
//  MapViewController.swift
//  mwWeatherForecast
//
//  Created by Matteo on 14/11/2018.
//  Copyright © 2018 RS KIS.EDU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var latlongCity: String = ""
    var nameCity: String = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CITY NAME FROM MAP VIEW \(latlongCity)")
        let coordinatesArray = self.latlongCity.split(separator: ",")
        
        let locationCoord = CLLocationCoordinate2D(latitude: Double(coordinatesArray[0])!, longitude: Double(coordinatesArray[1])!)
        
        let annotation = MKPointAnnotation()
        annotation.title = self.nameCity
        annotation.coordinate = locationCoord
        
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        
        let region = MKCoordinateRegion(center: locationCoord, span: span)
        
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(region, animated: true)
        
    
    }
    
/*
    @IBAction func unwindFromDetailVC(_ sender: UIStoryboardSegue){
        if( sender.source is DetailViewController){
            if let senderVC = sender.source as? DetailViewController {
              self.cityToDisplay = senderVC.cityName
                print("CITY NAME FROM MAP VIEW \(cityToDisplay)")
            }
        }
    }
*/
}
