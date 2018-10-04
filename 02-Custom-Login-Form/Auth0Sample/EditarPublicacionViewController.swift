//
//  EditarPublicacionViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 6/2/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import CropViewController

class EditarPublicacionViewController: Base, UIImagePickerControllerDelegate, UINavigationControllerDelegate,EmpresaViewModelDelegate, PublicacionesViewModelDelegate, MisPublicacionesDelegate,PermisoViewModelDelegate, CropViewControllerDelegate{
    
    @IBOutlet weak var imagenPrincipal: UIImageView!
    @IBOutlet weak var btnCargarImagen: UIButton!
    
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var btnVerPublicaciones: UIButton!
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var tfTitulo: UITextField!
    @IBOutlet weak var tfEmpresa: UITextField!
   
    @IBOutlet weak var tfDescripcion: UITextField!
    var base: BaseController = BaseController()
    var empresasViewModel:EmpresaViewModel?
    var publicacionesViewModel: PublicacionesViewModel?
    var imageBase64 : String?
    var imagePicker = UIImagePickerController()
    var idEmpresaSelected: String?
    var idPublicacion: String?
    var publicacion: Publicacion?
    var publicacionDest: PublicacionDest?
    var empresaEditar: Empresa?
    var edicion: Bool = false
    var destacada: String?
    var permisosViewModel: PermisoViewModel = PermisoViewModel()
    var imagenStatus = ""
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imagePicker.delegate = self
        empresasViewModel = EmpresaViewModel()
        empresasViewModel?.delegate = self
        publicacionesViewModel = PublicacionesViewModel()
        publicacionesViewModel?.delegate = self
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
        createEmpresaPicker()
        
        if let publi = publicacion {
            edicion = true
            setViews()
            idPublicacion = publi.id
        }
        
        if let publiDest = publicacionDest {
            edicion = true
            startAnimating()
            empresasViewModel?.recibirPorId(id: (publicacionDest?.idEmpresa)!)
            setViewsDest()
            idPublicacion = publiDest.id
            destacada = "1"
        }else{
            destacada = "0"
        }
        
        empresasViewModel?.recibir()
        
        self.hideKeyboard()
        if (UserDefaults.standard.bool(forKey: "Invitado")){
            if (edicion){
                btnGuardar.isHidden = true
                btnCancelar.isHidden = true
                btnVerPublicaciones.isHidden = true
                tfEmpresa.isEnabled = false
                tfTitulo.isEnabled = false
                tfDescripcion.isEnabled = false
                btnCargarImagen.isEnabled = false
            }
            return
        }
        permisosViewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.bool(forKey: "Invitado")){
            if(!edicion){
                invitado()
                return
            }
        }
        if (UserDefaults.standard.string(forKey: "PUBLICACION") == "1"){
            if(!edicion){
                limiteAlcanzado()
                return
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func invitado(){
        let alert = UIAlertController(title: "", message: "Con cuenta invitado no puede realizar publicaciones. Por favor regístrese. Cierre la app para volver a intentarlo.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil) }))
        present(alert, animated: true, completion: nil)
        
    }
    
    func limiteAlcanzado(){
        let alert = UIAlertController(title: "", message: "Limite de publicaciones alcanzado.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil) }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func tapBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
        
    }
  
    @IBAction func tapSelectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    func setViews(){
        tfTitulo.text = publicacion?.titulo
        tfDescripcion.text = publicacion?.descripcion
        tfEmpresa.text = publicacion?.razonSocial
        imagenStatus = "Cargar Imagen"
        idEmpresaSelected = publicacion?.idEmpresa
        imagenPrincipal.downloadedFrom(link: (publicacion?.imagen)!)
    }
    
    func setViewsDest(){
    
        tfTitulo.text = publicacionDest?.titulo
        tfDescripcion.text = publicacionDest?.descripcion
        if (empresaEditar != nil){
            tfEmpresa.text = empresaEditar?.razonSocial
        }
        imagenPrincipal.downloadedFrom(link: (publicacionDest?.imagen)!)
        imagenStatus = "Cargar Imagen"
        idEmpresaSelected = publicacionDest?.idEmpresa
    }
    
    public func setPublicacion(pubicacionAux: Publicacion){
        self.publicacion = pubicacionAux
        
    }
    
    public func setPublicacionDest(pubicacionAux: PublicacionDest){
        self.publicacionDest = pubicacionAux
        
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
        cropViewController.imageCropFrame = CGRect(x: 0, y: 0, width: 262, height: 466)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.5)! as NSData
        imageBase64 = imageData.base64EncodedString()
        imagenStatus = "Imagen Cargada"
        self.btnCargarImagen.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func createEmpresaPicker(){
        let empresaPicker = UIPickerView()
        empresaPicker.delegate = self
        tfEmpresa.inputView = empresaPicker
    }
    
    @IBAction func tapVerMisPublicaciones(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisPublicaciones") as! MisPublicacionesViewController
        vc.delegate = self
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func tapGuardar(_ sender: Any) {
        if (tfDescripcion.text != "" && tfTitulo.text != "" && imagenStatus != "" && tfEmpresa.text != ""){
            startAnimating()
            if edicion {
                if (destacada == "1"){
                     publicacionesViewModel?.putPublicaciones(id: (publicacionDest?.id)!, destacado: destacada!, titulo: tfTitulo.text!, imagen: "", descripcion: tfDescripcion.text!, idEmpresa: idEmpresaSelected!)
                }else{
                    publicacionesViewModel?.putPublicaciones(id: (idPublicacion)!, destacado: destacada!, titulo: tfTitulo.text!, imagen: "", descripcion: tfDescripcion.text!, idEmpresa: idEmpresaSelected!)
                }
                
            }else{
                idPublicacion = UUID().uuidString
                publicacionesViewModel?.postPublicaciones(id:idPublicacion!, destacada: destacada!, titulo: tfTitulo.text!, imagen: "", descripcion: tfDescripcion.text!, idEmpresa: idEmpresaSelected!)
            }
        }else{
            let alert = UIAlertController(title: "", message: "Por favor complete todos los datos.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapCancelar(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
   
    func finishSendingEmpresa() {
    }
    
    func finishGettingEmpresas(empresas: Empresas) {
        if edicion {
            if !(UserDefaults.standard.bool(forKey: "Invitado")){
                if ((empresasViewModel?.listaEmpresas?.count)! >= 0){
                    var encontrado = false
                    for i in 0 ... (empresasViewModel?.listaEmpresas?.count)! - 1 {
                        if (empresasViewModel?.listaEmpresas?[i].id == idEmpresaSelected){
                            encontrado = true
                        }
                    }
                    if !encontrado {
                        btnGuardar.isHidden = true
                        btnCancelar.isHidden = true
                        tfEmpresa.isEnabled = false
                        tfTitulo.isEnabled = false
                        tfDescripcion.isEnabled = false
                        btnCargarImagen.isEnabled = false
                    }
                }
            }
        }
    }
    
    func finishGettingEmpresasById() {
        stopAnimating()
        if ((empresasViewModel?.listaEmpresas!.count)! >= 1){
            empresaEditar = empresasViewModel?.listaEmpresas![0]
            setViewsDest()
        }
        empresasViewModel?.recibir()
    }
    func finishGettingImagenes() {
    }
    
    func finishSendingImagenEmpresa() {
        
    }
    
    func finishSendingPublicaciones() {
        
        if (edicion && imagenStatus == "Imagen Cargada"){
            publicacionesViewModel?.putImagenPublicaciones(id: idPublicacion!, imagen:imageBase64!)
        }else if (!edicion && imagenStatus == "Imagen Cargada"){
            publicacionesViewModel?.postImagenPublicaciones(id: idPublicacion!, imagen:imageBase64!)
        }else{
            stopAnimating()
            permisosViewModel.getPaquetes()
            let alert = UIAlertController(title: "", message: "Publicacion guardada correctamente.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func finishSendingImagenPublicaciones() {
        stopAnimating()
        permisosViewModel.getPaquetes()
        let alert = UIAlertController(title: "", message: "Publicacion guardada correctamente.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func finishedGettingPublicaciones(titulo: String, descripcion: String, id: String, destacada: String, idEmpresa: String, razonSocial: String, imagen: String) {
        tfTitulo.text = titulo
        tfEmpresa.text = razonSocial
        tfDescripcion.text = descripcion
        imagenStatus = "Cargar Imagen"
        idEmpresaSelected = idEmpresa
        idPublicacion = id
        imagenPrincipal.downloadedFrom(link: (imagen))
        edicion = true
        self.destacada = destacada
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

extension EditarPublicacionViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.empresasViewModel?.empresas?.empresas.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.empresasViewModel?.empresas?.empresas[row].razonSocial
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(true)
        self.tfEmpresa.text = empresasViewModel?.empresas?.empresas[row].razonSocial
        self.idEmpresaSelected = empresasViewModel?.empresas?.empresas[row].id
    }
    
}

extension EditarPublicacionViewController {
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


// Inspectable image content mode
extension UIButton {
    /// 0 => .ScaleToFill
    /// 1 => .ScaleAspectFit
    /// 2 => .ScaleAspectFill
    @IBInspectable
    var imageContentMode: Int {
        get {
            return self.imageView?.contentMode.rawValue ?? 0
        }
        set {
            if let mode = UIViewContentMode(rawValue: newValue),
                self.imageView != nil {
                self.imageView?.contentMode = mode
            }
        }
    }
}
