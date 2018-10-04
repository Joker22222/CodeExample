//
//  EmpresasViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 19/04/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import CropViewController

class EmpresasViewController: Base, UITableViewDelegate, UITableViewDataSource, EmpresaViewModelDelegate, UIScrollViewDelegate, SucursalesViewModelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PermisoViewModelDelegate, CropViewControllerDelegate{
    
    var viewModel : EmpresaViewModel?
    var sucursalesViewModel : SucursalesViewModel?
    var empresas : Empresas?
    var categorias : [Categoria]?
    var empresaSelectedID: String?
    
    @IBOutlet weak var btnLogo: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var tfEmpresa: UITextField!
    @IBOutlet weak var tfCategoria: UITextField!
    @IBOutlet weak var tfPalabrasClaves: UITextField!
    @IBOutlet weak var tfTwitter: UITextField!
    @IBOutlet weak var tfInstagram: UITextField!
    @IBOutlet weak var tfFacebook: UITextField!
    @IBOutlet weak var tfEstado: UITextField!
    @IBOutlet weak var tfMetodoDePago: UITextField!
    @IBOutlet weak var tfCUIT: UITextField!
    @IBOutlet weak var tfRazonSocial: UITextField!
    @IBOutlet weak var contentViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var tableViewHConstraint: NSLayoutConstraint!
    var imagePicker = UIImagePickerController()
    var imageBase64 : String?
    var selectedEmpresa : Empresa?
    let categoriaPicker = UIPickerView()
    let empresaPicker = UIPickerView()
    var selectedCat = ""
    var permisosViewModel: PermisoViewModel = PermisoViewModel()
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.delegate = self
        imagePicker.delegate = self
        viewModel = EmpresaViewModel()
        viewModel?.delegate = self
        viewModel?.recibir()
        sucursalesViewModel = SucursalesViewModel()
        sucursalesViewModel?.delegate = self
        createEmpresaPicker()
        createCategoriaPicker()
        fixSize(nuevaEmpresa: true)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        categorias = [Categoria]()
        fillCategorias()
        btnLogo.layer.cornerRadius = btnLogo.bounds.size.width / 2.0
        btnLogo.clipsToBounds = true
        tfCUIT.keyboardType = UIKeyboardType.decimalPad
    }
    override func viewDidLayoutSubviews() {
        btnLogo.layer.cornerRadius = btnLogo.bounds.size.width / 2.0
        btnLogo.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        if (tfEmpresa.text == "Nueva Empresa"){
            checkLimite()
        }
        if (selectedEmpresa != nil){
            startAnimating()
            sucursalesViewModel?.getSucursales(id: (selectedEmpresa?.id)!)
        }
    }
    @IBAction func tapLogo(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func addSucursal(_ sender: Any) {
        if (UserDefaults.standard.string(forKey: "SUCURSAL") == "1"){
            let alert = UIAlertController(title: "Error", message: "Limite de sucursales alcanzado.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if (empresaSelectedID != "" && empresaSelectedID != nil ){
                let vc = EditarSucursalViewController()
                vc.setEmpresa(id: empresaSelectedID!)
                present(vc, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Debe guardar la empresa antes de agregar una sucursal.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    @IBAction func tapNuevoEvento(_ sender: Any) {
        if (UserDefaults.standard.string(forKey: "EVENTOS") == "1"){
            let alert = UIAlertController(title: "Error", message: "Limite de eventos alcanzado.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if (empresaSelectedID != "" && empresaSelectedID != nil ){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "EdicionEvento") as! EdicionDeEventoViewController
                vc.setIdEmpresa(idEmpresa: empresaSelectedID!)
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Error", message: "Debe guardar la empresa antes de agregar un Evento.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func fillCategorias(){
        let cat = Categoria()
        cat.id = "0"
        cat.titulo = "Moda"
        categorias?.append(cat)
        let cat1 = Categoria()
        cat1.id = "1"
        cat1.titulo = "Gastronomia"
        categorias?.append(cat1)
        let cat2 = Categoria()
        cat2.id = "2"
        cat2.titulo = "Salud"
        categorias?.append(cat2)
        let cat3 = Categoria()
        cat3.id = "3"
        cat3.titulo = "Entretenimiento"
        categorias?.append(cat3)
        let cat4 = Categoria()
        cat4.id = "4"
        cat4.titulo = "Transporte"
        categorias?.append(cat4)
        let cat5 = Categoria()
        cat5.id = "5"
        cat5.titulo = "Servicios"
        categorias?.append(cat5)
        let cat6 = Categoria()
        cat6.id = "6"
        cat6.titulo = "Turismo"
        categorias?.append(cat6)
        let cat7 = Categoria()
        cat7.id = "7"
        cat7.titulo = "Calendario"
        categorias?.append(cat7)
        let cat8 = Categoria()
        cat8.id = "8"
        cat8.titulo = "Más"
        categorias?.append(cat8)
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
        cropViewController.imageCropFrame = CGRect(x: 0, y: 0, width: 225, height: 250)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.5)! as NSData
        imageBase64 = imageData.base64EncodedString()
        self.btnLogo.setImage(image, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func fixSize(nuevaEmpresa:Bool){
        if (nuevaEmpresa){
            tableViewHConstraint.constant = 0
            contentViewConstraint.constant = 950 - (43*5)
        }else{
            if ((sucursalesViewModel?.listaSucursales?.count)! > 5){
                tableViewHConstraint.constant = CGFloat(43*5)
                contentViewConstraint.constant = 950
            } else {
                tableViewHConstraint.constant = CGFloat(43*(sucursalesViewModel?.listaSucursales?.count)!)
                contentViewConstraint.constant = 950 - CGFloat(43*(5 - (sucursalesViewModel?.listaSucursales?.count)!))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sucursalesViewModel?.listaSucursales?.count) != nil{
            return (sucursalesViewModel?.listaSucursales!.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "empresasCell", for: indexPath) as! EmpresasTableViewCell
        cell.razonSocial.text = sucursalesViewModel?.listaSucursales![indexPath.row].direccion
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditarSucursalViewController()
        vc.setEmpresa(sucursal: (sucursalesViewModel?.listaSucursales![indexPath.row])!)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapGaleria(_ sender: Any) {
        if (tfEmpresa.text != "Nueva Empresa"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GaleriaViewController") as! GaleriaViewController
            vc.setEmpresa(idEmpresa: empresaSelectedID!)
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "", message: "Para editar imagenes debe guardar la empresa.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
   
    @IBAction func tapGuardar(_ sender: Any) {
        if (tfRazonSocial.text == "" || tfCUIT.text == "" || tfEstado.text == "" || tfPalabrasClaves.text == ""){
            let alert = UIAlertController(title: "Error", message: "Datos obligatorios faltantes.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if( tfEmpresa.text == "Nueva Empresa" ){
                startAnimating()
                let id = UUID().uuidString
                empresaSelectedID = id
                viewModel?.guardar(id : empresaSelectedID!,
                                   razonSocial: tfRazonSocial.text!,
                                   cuit: tfCUIT.text!,
                                   metodoPago: tfMetodoDePago.text!,
                                   estado: tfEstado.text!,
                                   facebook: tfFacebook.text!,
                                   instagram: tfInstagram.text!,
                                   twitter: tfTwitter.text!,
                                   palabrasClaves: tfPalabrasClaves.text!,
                                   categoria: selectedCat)
            }else{
                startAnimating()
                viewModel?.Actualizar(id: empresaSelectedID!,
                                      razonSocial: tfRazonSocial.text!,
                                      cuit: tfCUIT.text!,
                                      metodoPago: tfMetodoDePago.text!,
                                      estado: tfEstado.text!,
                                      facebook: tfFacebook.text!,
                                      instagram: tfInstagram.text!,
                                      twitter: tfTwitter.text!,
                                      palabrasClaves: tfPalabrasClaves.text!,
                                      categoria: selectedCat)
            }
        }
    }
    
    func createEmpresaPicker(){
        empresaPicker.delegate = self
        tfEmpresa.inputView = empresaPicker
    }
    
    func createCategoriaPicker(){
        categoriaPicker.delegate = self
        tfCategoria.inputView = categoriaPicker
    }
    func checkLimite(){
        if (UserDefaults.standard.string(forKey: "EMPRESA") == "1"){
            let alert = UIAlertController(title: "", message: "Limite de empresas alcanzado.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            tfRazonSocial.text = ""
            tfCUIT.text = ""
            tfMetodoDePago.text = ""
            tfEstado.text = ""
            tfFacebook.text = ""
            tfInstagram.text = ""
            tfTwitter.text = ""
            tfPalabrasClaves.text = ""
            tfCategoria.text = ""
            tfEmpresa.text = "Nueva Empresa"
            tfRazonSocial.isEnabled = false
            tfCUIT.isEnabled = false
            tfMetodoDePago.isEnabled = false
            tfEstado.isEnabled = false
            tfFacebook.isEnabled = false
            tfInstagram.isEnabled = false
            tfTwitter.isEnabled = false
            tfPalabrasClaves.isEnabled = false
            tfCategoria.isEnabled = false
            empresaSelectedID = ""
            btnLogo.setImage(UIImage(named: "LogoEmpresa.png"), for: .normal)
            fixSize(nuevaEmpresa: true)
            imageBase64 = ""
            empresaSelectedID = ""
        }
    }
    func setViews (){
        
        if(selectedEmpresa == nil){
            if (UserDefaults.standard.string(forKey: "EMPRESA") == "1"){
                let alert = UIAlertController(title: "", message: "Limite de empresas alcanzado.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                present(alert, animated: true, completion: nil)
                tfRazonSocial.text = ""
                tfCUIT.text = ""
                tfMetodoDePago.text = ""
                tfEstado.text = ""
                tfFacebook.text = ""
                tfInstagram.text = ""
                tfTwitter.text = ""
                tfPalabrasClaves.text = ""
                tfCategoria.text = ""
                tfEmpresa.text = "Nueva Empresa"
                tfRazonSocial.isEnabled = false
                tfCUIT.isEnabled = false
                tfMetodoDePago.isEnabled = false
                tfEstado.isEnabled = false
                tfFacebook.isEnabled = false
                tfInstagram.isEnabled = false
                tfTwitter.isEnabled = false
                tfPalabrasClaves.isEnabled = false
                tfCategoria.isEnabled = false
                empresaSelectedID = ""
                btnLogo.setImage(UIImage(named: "LogoEmpresa.png"), for: .normal)
                fixSize(nuevaEmpresa: true)
                imageBase64 = ""
            }else{
                
                tfEmpresa.text = "Nueva Empresa"
                tfRazonSocial.text = ""
                tfCUIT.text = ""
                tfMetodoDePago.text = ""
                tfEstado.text = ""
                tfFacebook.text = ""
                tfInstagram.text = ""
                tfTwitter.text = ""
                tfPalabrasClaves.text = ""
                tfCategoria.text = ""
                empresaSelectedID = ""
                btnLogo.setImage(UIImage(named: "LogoEmpresa.png"), for: .normal)
                fixSize(nuevaEmpresa: true)
                imageBase64 = ""
            }
            
        } else {
            tfRazonSocial.isEnabled = true
            tfCUIT.isEnabled = true
            tfMetodoDePago.isEnabled = true
            tfEstado.isEnabled = true
            tfFacebook.isEnabled = true
            tfInstagram.isEnabled = true
            tfTwitter.isEnabled = true
            tfPalabrasClaves.isEnabled = true
            tfCategoria.isEnabled = true
            tfEmpresa.text = selectedEmpresa?.razonSocial
            tfRazonSocial.text = selectedEmpresa?.razonSocial
            tfCUIT.text = selectedEmpresa?.cuit
            tfMetodoDePago.text = selectedEmpresa?.medioPago
            tfEstado.text = selectedEmpresa?.estado
            tfFacebook.text = selectedEmpresa?.facebook
            tfInstagram.text = selectedEmpresa?.instagram
            tfTwitter.text = selectedEmpresa?.twitter
            tfPalabrasClaves.text = selectedEmpresa?.palabrasClave
            tfCategoria.text = ""
            empresaSelectedID = selectedEmpresa?.id
            sucursalesViewModel?.getSucursales(id: (selectedEmpresa!.id))
            btnLogo.downloadedFrom(link: (selectedEmpresa!.logo))
            imageBase64 = ""
        }
    }
    
    func finishSendingEmpresa() {
        viewModel?.recibir()
        empresaPicker.reloadAllComponents()
        if(selectedEmpresa?.logo == nil && imageBase64 != nil){
            viewModel?.postImagenEmpresa(id: (empresaSelectedID)!, imagen: imageBase64!)
        }else if ((selectedEmpresa?.logo != nil) && imageBase64 != nil){
            viewModel?.putImagenEmpresa(id: (selectedEmpresa?.id)!, imagen: imageBase64!)
        }else if (imageBase64 == nil){
            stopAnimating()
            permisosViewModel.getPaquetes()
            let alert = UIAlertController(title: "", message: "Guardado!, muy pronto su negocio se dará de alta", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func finishGettingEmpresas(empresas: Empresas) {
        stopAnimating()
        self.empresas = empresas
    }
    func finishGettingEmpresasById() {
        
    }
    func finishSendingImagenEmpresa() {
        stopAnimating()
        viewModel?.recibir()
        let alert = UIAlertController(title: "", message: "Guardado!, muy pronto su negocio se dará de alta.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        tfEmpresa.text = tfRazonSocial.text
        permisosViewModel.getPaquetes()
    }
    func finishGettingImagenes() {
        
    }
    
    func finishSendingSucursales() {
        
    }
    func finishGettingSucursalesById() {
        
    }
    func finishGettingSucursales() {
        stopAnimating()
        tableView.reloadData()
        fixSize(nuevaEmpresa: false)
        permisosViewModel.getPaquetes()
    }
    
    func setPermisos(){
        for i in 0...(permisosViewModel.listaPermisos?.count)! - 1 {
            UserDefaults.standard.set(permisosViewModel.listaPermisos?[i].limAlcanzado,forKey: permisosViewModel.listaPermisos![i].modulo)
        }
    }
    func finishGetingMisPermisos() {
        setPermisos()
    }
    
}

extension EmpresasViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == empresaPicker){
            return (self.empresas?.empresas.count)! + 1
        } else {
            return (categorias?.count)!
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == empresaPicker){
            if (row == 0){
                return "Nueva Empresa"
            }else{
                return self.empresas?.empresas[row - 1].razonSocial
            }
        }else{
            return categorias![row].titulo
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(true)
        if (pickerView == empresaPicker){
            if row == 0{
                selectedEmpresa = nil
            }else{
                selectedEmpresa = viewModel?.listaEmpresas![row-1]
            }
            setViews()
        }else{
            selectedCat = categorias![row].id
            tfCategoria.text = categorias![row].titulo
        }
        
    }
}

extension UIButton {
    func downloadedFrom(url: URL) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.setImage(image, for: .normal)
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
}





