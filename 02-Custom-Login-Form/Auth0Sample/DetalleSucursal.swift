//
//  DetalleSucursal.swift
//  GuiApp
//
//  Created by Fernando Garay on 5/2/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import MapKit


class DetalleSucursal: Base, SucursalesViewModelDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var btnTelefono: UIButton!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lbDireccion: UILabel!
    @IBOutlet weak var lbTelefono: UILabel!
    @IBOutlet weak var lbDelivery: UILabel!
    @IBOutlet weak var lb24Hs: UILabel!
    @IBOutlet weak var lbDiasYHorarios: UILabel!
    @IBOutlet weak var btEditar: UIButton!
    @IBOutlet weak var mkMap: MKMapView!
    var locationManager: CLLocationManager!
    var currentPlacemark: CLPlacemark?
    let vcDetalle = EditarSucursalViewController(nibName: "EditarSucursalViewController", bundle: nil)
    var idSucursal: String?
    var sucursalViewModel: SucursalesViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        sucursalViewModel = SucursalesViewModel()
        sucursalViewModel?.delegate = self
        startAnimating()
        sucursalViewModel?.getSucursalesById(id: idSucursal!)
        btEditar.isHidden = true
        mkMap.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.goToMap(_:)))
        mkMap.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goToMap(_ sender: UITapGestureRecognizer) {
        let latitude:CLLocationDegrees = Double(sucursalViewModel?.listaSucursales![0].latitud as! String)!
        let longitude:CLLocationDegrees = Double(sucursalViewModel?.listaSucursales![0].longitud as! String)!
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = sucursalViewModel?.listaSucursales![0].direccion
        mapItem.openInMaps(launchOptions: options)
    }
    
    @IBAction func tapBtnTelefono(_ sender: Any) {
        guard let number = URL(string: "tel://" + lbTelefono.text!) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func tapEditar(_ sender: Any) {
        vcDetalle.setEmpresa(sucursal: (sucursalViewModel?.listaSucursales![0])!)
        self.present(self.vcDetalle, animated: true, completion: nil)
    }
    
    @IBAction func tapBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    public func setIdSucursal (idSucursal: String){
        self.idSucursal = idSucursal
    }
   
    func setUpViews() {
        if let direccion = sucursalViewModel?.listaSucursales![0].direccion {
            lblTitulo.text = "Sucursal " + (sucursalViewModel?.listaSucursales![0].direccion)!
            lbDireccion.text = direccion
        }else{
            lbDireccion.text = ""
        }
        
        if let telefono = sucursalViewModel?.listaSucursales![0].telefono {
            lbTelefono.text = telefono
        }else{
            lbTelefono.text = ""
        }
        
        if let delivery = sucursalViewModel?.listaSucursales![0].delivery {
            if delivery == "0"{
                lbDelivery.text = "NO"
            }else if delivery == "1"{
                lbDelivery.text = "SI"
            }else{
                lbDelivery.text = ""
            }
        }
        
        if let hs24 = sucursalViewModel?.listaSucursales![0].veinticuatroHs {
            if hs24 == "0"{
                lb24Hs.text = "NO"
            }else if hs24 == "1"{
                lb24Hs.text = "SI"
            }else{
                lb24Hs.text = ""
            }
        }
        
        if let diasYHorarios = sucursalViewModel?.listaSucursales![0].diasHorarios {
            lbDiasYHorarios.text = diasYHorarios
        }else{
            lbDiasYHorarios.text = ""
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let center = CLLocationCoordinate2D(latitude: Double(sucursalViewModel?.listaSucursales![0].latitud as! String)!, longitude: Double(sucursalViewModel?.listaSucursales![0].longitud as! String)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mkMap.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        let anno = MKPointAnnotation()
        anno.coordinate = CLLocationCoordinate2D(latitude: Double(sucursalViewModel?.listaSucursales![0].latitud as! String)!, longitude: Double(sucursalViewModel?.listaSucursales![0].longitud as! String)!)
        anno.title = sucursalViewModel?.listaSucursales![0].razonSocial
        currentPlacemark = MKPlacemark(coordinate: anno.coordinate)
        self.mkMap.addAnnotation(anno)
        self.showDirections()
    }
    
    func showDirections(){
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        
        let directionRequest = MKDirectionsRequest()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .walking
        
        // calculate the directions / route
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (directionsResponse, error) in
            guard let directionsResponse = directionsResponse else {
                if let error = error {
                    print("error getting directions: \(error.localizedDescription)")
                }
                return
            }
            
            let route = directionsResponse.routes[0]
            self.mkMap.removeOverlays(self.mkMap.overlays)
            self.mkMap.add(route.polyline, level: .aboveRoads)
            
            let routeRect = route.polyline.boundingMapRect
            self.mkMap.setRegion(MKCoordinateRegionForMapRect(routeRect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func checkLocationServiceAuthenticationStatus()
    {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mkMap.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func finishSendingSucursales() {
        
    }
    
    func finishGettingSucursales() {
        
    }
    
    func finishGettingSucursalesById() {
        setUpViews()
        if (CLLocationManager.locationServicesEnabled())
        {
            checkLocationServiceAuthenticationStatus()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        stopAnimating()
    }
    
}
