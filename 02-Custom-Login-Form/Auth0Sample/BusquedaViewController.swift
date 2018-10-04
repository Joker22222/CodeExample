//
//  BusquedaViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 12/1/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class BusquedaViewController: Base, BusquedaViewModelDelegate, MapDelegate {

    @IBOutlet weak var btnPublicidad: UIButton!
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var busquedaTextField: UITextField!
    @IBOutlet weak var tFieldBuscar: UITextField!
    @IBOutlet weak var btnBuscar: UIButton!
    @IBOutlet weak var imgPublicidad: UIImageView!
    var base: BaseController = BaseController()
    var latitud: String?
    var longitud: String?
    var param: String?
    var cat: String?
    var viewModel:BusquedaViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BusquedaViewModel()
        viewModel?.delegate = self
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
        self.hideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "perform search" {
            let nextScene =  segue.destination as! ResultadoBusquedaViewController
            if let lat = latitud {
                nextScene.latitud = lat
            }else{
                nextScene.latitud = "0"
            }
            
            if let long = longitud {
                nextScene.longitud = long
            }else{
                nextScene.longitud = "0"
            }
            
            if let category = cat {
                nextScene.cat = category
            }else{
                nextScene.cat = ""
            }
            
            if let parameter = tFieldBuscar.text {
                nextScene.param = parameter
            }else{
                nextScene.param = ""
            }
        }
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    @IBAction func tapBtnPublicidad(_ sender: Any) {
        if let url = URL(string: (viewModel?.publicidades?.publicidades[0].url)!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func tapBtnBuscar(_ sender: Any) {
        if (tFieldBuscar.text != ""){
            param = tFieldBuscar.text
            buscar()
        }
    }
    @IBAction func tapModa(_ sender: Any) {
        cat = "0"
        buscar()
    }
    @IBAction func tapGastronomia(_ sender: Any) {
        cat = "1"
        buscar()
    }
    @IBAction func tapSalud(_ sender: Any) {
        cat = "2"
        buscar()
    }
    @IBAction func tapEntretenimiento(_ sender: Any) {
        cat = "3"
        buscar()
    }
    @IBAction func tapTransportes(_ sender: Any) {
        cat = "4"
        buscar()
    }
    @IBAction func tapServicios(_ sender: Any) {
        cat = "5"
        buscar()
    }
    @IBAction func tapTurismo(_ sender: Any) {
        cat = "6"
        buscar()
    }
    @IBAction func tapCalendario(_ sender: Any) {
        cat = "7"
        buscar()
    }
    @IBAction func tapMas(_ sender: Any) {
        cat = "8"
        buscar()
    }
    
    func buscar(){
        performSegue(withIdentifier: "perform search", sender: nil)
    }
    @IBAction func tapMap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mapa") as! MapViewController
        vc.delegate = self
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    func finishGettingPublicidad() {
        imgPublicidad.downloadedFrom(link: (viewModel?.publicidades?.publicidades[0].imagen)!)
    }
    @IBAction func tapText(_ sender: Any) {
    view.endEditing(true)
    }
    
    func finishedSettingCoodenadas(longitud: String, latitud: String) {
        self.longitud = longitud
        self.latitud = latitud
    }
    

    
}

extension BusquedaViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


