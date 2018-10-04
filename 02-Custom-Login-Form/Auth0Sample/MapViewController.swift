//
//  MapViewController.swift
//  GuiApp
//
//  Created by Fernando  on 4/17/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
protocol MapDelegate {
    func finishedSettingCoodenadas(longitud: String, latitud:String)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var latitud: String?
    var longitud: String?
    var param: String?
    var delegate: MapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultados" {
            let nextScene =  segue.destination as! BusquedaViewController
            nextScene.latitud = latitud
            nextScene.longitud = longitud
        }
    }
  
    @IBAction func tapBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.userLocation.title = "Ubicacion Actual"
    }
    
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.began { return }
        let touchLocation = gestureRecognizer.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        latitud = String(locationCoordinate.latitude)
        longitud = String(locationCoordinate.longitude)
        param = ""
        delegate?.finishedSettingCoodenadas(longitud: longitud!, latitud: latitud!)
       
        let alert = UIAlertController(title: "", message: "Coordenadas ingresadas correctamente.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
