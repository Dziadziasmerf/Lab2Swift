//
//  ViewController.swift
//  Lab2
//
//  Created by Użytkownik Gość on 24.10.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var locationInput: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var currentLocationManager : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        if(CLLocationManager.locationServicesEnabled()) {
            currentLocationManager = CLLocationManager()
            currentLocationManager?.delegate = self
            currentLocationManager?.requestWhenInUseAuthorization()
            //currentLocationManager?.startUpdatingLocation()
        }
        
        stopButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonAction(_ sender: Any) {
        stopButton.isEnabled = true
        startButton.isEnabled = false
        currentLocationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.setCenter(locations[0].coordinate, animated: true)
        let marker = MKPointAnnotation()
        marker.coordinate = locations[0].coordinate
        mapView.addAnnotation(marker)
    }
    
    @IBAction func clear(_ sender: Any) {
        mapView.removeAnnotations(mapView.annotations)
    }
    

    @IBAction func stop(_ sender: Any) {
        currentLocationManager?.stopUpdatingLocation()
    }
    
    
}

