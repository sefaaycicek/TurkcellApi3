//
//  MapViewController.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 20.09.2024.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locatioManager : CLLocationManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCoreLocation()
    }
    
    func prepareMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true // map üstündeki mavi pin
    }
    
    func prepareMapRegion(coordinate : CLLocationCoordinate2D) {
        let regionRadius : CLLocationDistance = 2000
        let currentRegion = MKCoordinateRegion(center: coordinate,
                                               latitudinalMeters: regionRadius,
                                               longitudinalMeters: regionRadius)
        mapView.setRegion(currentRegion, animated: true)
        addAnnotation(coordinate: coordinate)
    }
    
    func prepareCoreLocation() {
        locatioManager = CLLocationManager()
        locatioManager?.delegate = self
        
        locatioManager?.requestAlwaysAuthorization()
    }
    
    func addAnnotation(coordinate : CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        let myPoint = MyPoint(title: "Bisiklet", coordinate: coordinate)
        mapView.addAnnotation(myPoint)
    }
    
    func requestLocation() {
        locatioManager?.startUpdatingLocation()
    }
}

extension MapViewController  : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            self.requestLocation()
            break
        case .authorizedWhenInUse:
            self.requestLocation()
            //locatioManager?.requestAlwaysAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach({ location in
            print("\(location.coordinate.latitude) \(location.coordinate.longitude)")
            self.prepareMapRegion(coordinate: location.coordinate)
        })
        
        
        //manager.stopUpdatingLocation()
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        if let myPoint = annotation as? MyPoint {
            
        }
    }
}


class MyPoint : NSObject, MKAnnotation {
    var title : String?
    var coordinate : CLLocationCoordinate2D
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
