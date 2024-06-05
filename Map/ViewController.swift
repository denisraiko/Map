//
//  ViewController.swift
//  Map
//
//  Created by Denis Raiko on 24.05.24.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(revealRegionDetailsWithLongPressOnMap(sender: )))
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        print("Locations = \(location.latitude) \(location.longitude)")
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let geocoder: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            let location: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            
            
            geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
                    
                    let point = MKPointAnnotation()
                    point.coordinate = center
                    point.title = addressString
                    self.mapView.addAnnotation(point)
                }
            })
            
        }


    @IBAction func buttonPressed(_ sender: UIButton) {
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
                mapView.centerToLocation(initialLocation)
                
                let point = MKPointAnnotation()
                point.coordinate = initialLocation.coordinate
                point.title = "Hello"
                point.subtitle = "hidden subtitle"
                mapView.addAnnotation(point)
    }
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
            if sender.state != UIGestureRecognizer.State.began { return }
            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            let point = MKPointAnnotation()
            point.coordinate = locationCoordinate
            point.title = "Hello"
            point.subtitle = "hidden subtitle"
            mapView.addAnnotation(point)
            
            self.getAddressFromLatLon(pdblLatitude: "\(locationCoordinate.latitude)", withLongitude: "\(locationCoordinate.longitude)")
        }
    
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}


