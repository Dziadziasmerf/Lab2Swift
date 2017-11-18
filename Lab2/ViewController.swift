import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var 	locationInput: UITextField!
    
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

            print("init")
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
        var zoom: Double
        if(locations[0].speed <= 0) {
            zoom = 0.01
        } else {
            zoom = locations[0].speed/200
        }
        let span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        let region = MKCoordinateRegion(center:locations[0].coordinate,span:span)
        mapView.setRegion(region,animated:true)
        let marker = MKPointAnnotation()
        marker.coordinate = locations[0].coordinate
        mapView.addAnnotation(marker)
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if let placemark: CLPlacemark = placemarks?[0] {
                let address = (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
                print(address)
                self.locationInput.text = address
            }
        })
    }
    
    @IBAction func clear(_ sender: Any) {
        mapView.removeAnnotations(mapView.annotations)
    }
    

    @IBAction func stop(_ sender: Any) {
        currentLocationManager?.stopUpdatingLocation()
        stopButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    
}

