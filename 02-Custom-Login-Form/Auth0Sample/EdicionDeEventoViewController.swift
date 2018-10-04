//
//  EdicionDeEventoViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 07/07/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import CropViewController

class EdicionDeEventoViewController: Base, UITextFieldDelegate, UIPickerViewDelegate, EventosBusquedaViewModelDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate {
 
    
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var btnimagen: UIImageView!
    @IBOutlet weak var tfCategoria: UITextField!
    @IBOutlet weak var tfTitulo: UITextField!
    @IBOutlet weak var tfLugar: UITextField!
    @IBOutlet weak var tfFecha: UITextField!
    @IBOutlet weak var tfHora: UITextField!
    @IBOutlet weak var dpkrFechz: UIDatePicker!
    @IBOutlet weak var btnOkFecha: UIButton!
    @IBOutlet weak var btnOkHora: UIButton!
    @IBOutlet weak var dpkHora: UIDatePicker!
    @IBOutlet weak var lblSeleccionarImagen: UILabel!
    
    let categoriaPicker = UIPickerView()
    var fecha = ""
    var hora = ""
    var categoria = ""
    var viewModel : EventosViewModel?
    var idEmpresa = ""
    var evento: Evento?
    var imagePicker = UIImagePickerController()
    var imageBase64 = ""
    var edicion = false
    var idEvento = ""
    var base: BaseController = BaseController()
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    var image : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        viewModel = EventosViewModel()
        viewModel?.delegate = self
        viewModel?.getCategoriaEventos()
        dpkHora.isHidden = true
        dpkrFechz.isHidden = true
        btnOkHora.isHidden = true
        btnOkFecha.isHidden = true
        dpkrFechz.backgroundColor = UIColor(red: 146/255.0, green: 53/255.0, blue: 198/255.0, alpha: 1.00)
        dpkrFechz.setValue(UIColor.white, forKeyPath: "textColor")
        dpkHora.backgroundColor = UIColor(red: 146/255.0, green: 53/255.0, blue: 198/255.0, alpha: 1.00)
        dpkHora.setValue(UIColor.white, forKeyPath: "textColor")
        tfHora.delegate = self
        tfFecha.delegate = self
        categoriaPicker.delegate = self
        tfCategoria.inputView = categoriaPicker
        imagePicker.delegate = self
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
        if edicion == true {
            tfLugar.text = evento?.ubicacion
            tfTitulo.text = evento?.nombre
            tfHora.text = evento?.horaInicio
            tfFecha.text = evento?.fechaInicio
            btnimagen.downloadedFrom(link: (evento?.imagen)!)
            idEvento = (evento?.id)!
            fecha = (evento?.fechaInicio)!
            hora = (evento?.horaInicio)!
            categoria = (evento?.idTipo)!
            lblSeleccionarImagen.isHidden = true
        }else{
            idEvento = UUID().uuidString
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    public func setIdEmpresa(idEmpresa: String){
        self.idEmpresa = idEmpresa
    }
    
    public func setEvento(evento: Evento){
        self.evento = evento
        self.edicion = true
    }
    
    @IBAction func tapVolver(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGuardar(_ sender: Any) {
        startAnimating()
        if edicion {
            if (categoria != "" && fecha != "" && hora != "" && tfTitulo.text != "" && tfLugar.text != ""){
                viewModel?.editarEventos(id: idEvento,
                                         nombre: tfTitulo.text!,
                                         descripcion: tfTitulo.text!,
                                         imagen: (evento?.imagen)!,
                                         idTipo: categoria,
                                         ubicacion: tfLugar.text!,
                                         fecInicio: fecha,
                                         idEmpresa: (evento?.idEmpresa)!,
                                         horaInicio: hora)
            }else{
                let alert = UIAlertController(title: "Error", message: "Datos obligatorios faltantes.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            if (categoria != "" && fecha != "" && hora != "" && tfTitulo.text != "" && tfLugar.text != "" && imageBase64 != ""){
                viewModel?.enviarEventos(id: idEvento,
                                         nombre: tfTitulo.text!,
                                         descripcion: tfTitulo.text!,
                                         imagen: "",
                                         idTipo: categoria,
                                         ubicacion: tfLugar.text!,
                                         fecInicio: fecha,
                                         idEmpresa: idEmpresa,
                                         horaInicio: hora)
            }else{
                let alert = UIAlertController(title: "Error", message: "Datos obligatorios faltantes.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tapOkFecha(_ sender: Any) {
        let actualDate = Date()
        if (dpkrFechz.date >= actualDate){
            dpkrFechz.isHidden = true
            btnOkFecha.isHidden = true
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            fecha = dateFormatter.string(from: dpkrFechz.date)
            tfFecha.text = fecha
        } else {
            let alert = UIAlertController(title: "Error", message: "La fecha es invalida.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tapDate(_ sender: Any) {
        dpkrFechz.isHidden = false
        btnOkFecha.isHidden = false
        view.endEditing(true)
    }
    
    @IBAction func tapHour(_ sender: Any) {
        dpkHora.isHidden = false
        btnOkHora.isHidden = false
        view.endEditing(true)
    }
   
    @IBAction func tapCategoria(_ sender: Any) {
    }
    
    @IBAction func tapOkHora(_ sender: Any) {
        dpkHora.isHidden = true
        btnOkHora.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        hora = dateFormatter.string(from: dpkHora.date)
        tfHora.text = hora
    }
   
    @IBAction func tapimagen(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        presentCropViewController()
    }
    
    func presentCropViewController(){
        let cropViewController = CropViewController(image: image!)
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.imageCropFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 136)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.5)! as NSData
        imageBase64 = imageData.base64EncodedString()
        self.lblSeleccionarImagen.isHidden = true
        btnimagen.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tfHora.resignFirstResponder();
        tfFecha.resignFirstResponder();
        tfCategoria.resignFirstResponder();
        // Additional code here
        return false
    }
    
    func finishGetingMisEventos() {
        
    }
    
    func finishGetingCategorias() {
        
    }
    
    func finishSendingEventos() {
        if edicion{
            if imageBase64 != "" {
                viewModel?.putImagenEvento(id: idEvento, imagen: imageBase64)
            }else{
                stopAnimating()
                let alert = UIAlertController(title: "", message: "Evento guardado correctamente.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            viewModel?.postImagenEvento(id: idEvento, imagen: imageBase64)
        }
        
    }
    
    func finishSendingImagenEvento() {
        stopAnimating()
        let alert = UIAlertController(title: "", message: "Evento guardado correctamente.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        if !edicion{
            btnimagen.image = nil
            lblSeleccionarImagen.isHidden = false
            tfCategoria.text = ""
            tfFecha.text = ""
            tfHora.text = ""
            tfLugar.text = ""
            tfTitulo.text = ""
            categoria = ""
            fecha = ""
            hora = ""
            idEvento = UUID().uuidString
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (viewModel?.categoriaEventos?.categoriaEventos.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.categoriaEventos?.categoriaEventos[row].tipo
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoria = (viewModel?.categoriaEventos?.categoriaEventos[row].id)!
        tfCategoria.text = viewModel?.categoriaEventos?.categoriaEventos[row].tipo 
        self.view.endEditing(true)
    }
    
}

extension EdicionDeEventoViewController {
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
