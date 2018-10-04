//
//  EditarSucursalViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 5/2/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class EditarSucursalViewController: Base, MapDelegate, SucursalesViewModelDelegate {
    
    var long: String?
    var lat: String?
    let option = ["Si", "No"]
    var viewModel : SucursalesViewModel?
    var idEmpresa: String?
    var sucursal: Sucursal?
    var editar: Bool?
    
    @IBOutlet weak var tfDireccion: UITextField!
    
    @IBOutlet weak var tfTelefonos: UITextField!
    
    @IBOutlet weak var tfEnvios: UITextField!
    
    @IBOutlet weak var tf24Hs: UITextField!
    
    @IBOutlet weak var tfHorarios: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickers()
        viewModel = SucursalesViewModel()
        viewModel?.delegate = self
        self.hideKeyboard()
        if let sucursal = sucursal{
            idEmpresa = sucursal.idEmpresa
            lat = sucursal.latitud
            long = sucursal.longitud
            editar = true
            setViews()
        }else{
            editar = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func setEmpresa (id: String){
        idEmpresa = id
    }
    
    public func setEmpresa (sucursal: Sucursal){
        self.sucursal = sucursal
    }
    
    func setViews(){
        if (sucursal != nil){
            tfDireccion.text = sucursal?.direccion
            tfHorarios.text = sucursal?.diasHorarios
            tfTelefonos.text = sucursal?.telefono
            if (sucursal?.delivery == "0"){
                tfEnvios.text = "NO"
            }else{
                tfEnvios.text = "SI"
            }
            if (sucursal?.veinticuatroHs == "0"){
                tf24Hs.text = "NO"
            }else{
                tf24Hs.text = "SI"
            }
        }
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tapInsertarCoordenadas(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mapa") as! MapViewController
        vc.delegate = self
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapGuardar(_ sender: Any) {
        if lat == nil || long == nil{
            let alert = UIAlertController(title: "", message: "Ingrese las coordenadas.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            if (tf24Hs.text != "" && tfEnvios.text != "" && tfHorarios.text != "" && tfDireccion.text != "" && tfTelefonos.text != ""){
                
                startAnimating()
                let envios: String
                let hs24: String
                
                if (tfEnvios.text == "Si"){
                    envios = "1"
                }else{
                    envios = "0"
                }
                
                
                if (tf24Hs.text == "Si"){
                    hs24 = "1"
                }else{
                    hs24 = "0"
                }
                if (editar)!{
                    viewModel?.actualizarSucursal(id: (sucursal?.id)!,
                                                  idEmpresa: idEmpresa!,
                                                  direccion: tfDireccion.text!,
                                                  latitud: lat!,
                                                  longitud: long!,
                                                  telefono: tfTelefonos.text!,
                                                  delivery: envios,
                                                  veinticuatroHs: hs24,
                                                  diasHorarios: tfHorarios.text!)
                }else {
                    viewModel?.enviarSucursal(idEmpresa: idEmpresa!,
                                              direccion: tfDireccion.text!,
                                              latitud: lat!,
                                              longitud: long!,
                                              telefono: tfTelefonos.text!,
                                              delivery: envios,
                                              veinticuatroHs: hs24,
                                              diasHorarios: tfHorarios.text!)
                }
                
            }else{
                let alert = UIAlertController(title: "", message: "Ingrese los datos faltantes.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    @IBAction func tapBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func createPickers(){
        let enviosPicker = UIPickerView()
        enviosPicker.tag = 100
        enviosPicker.delegate = self
        tfEnvios.inputView = enviosPicker
        
        let hsPicker = UIPickerView()
        hsPicker.tag = 200
        hsPicker.delegate = self
        tf24Hs.inputView = hsPicker
    }
    
    func finishedSettingCoodenadas(longitud: String, latitud: String) {
        long = longitud
        lat = latitud
    }
    
    func finishSendingSucursales() {
        stopAnimating()
        let alert = UIAlertController(title: "", message: "Sucursal guardada correctamente.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func finishGettingSucursales() {
        
    }
    func finishGettingSucursalesById() {
        
    }
}

extension EditarSucursalViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.option[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 200){
            self.tf24Hs.text = self.option[row]
        }else{
            self.tfEnvios.text = self.option[row]
        }
        self.view.endEditing(true)
    }
}

extension EditarSucursalViewController {
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
