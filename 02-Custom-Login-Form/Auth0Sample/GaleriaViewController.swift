//
//  GaleriaViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 24/08/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import CropViewController

class GaleriaViewController: Base, UICollectionViewDelegate, UICollectionViewDataSource, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImagenesGaleriaDelegate{
   
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var imageItem: UICollectionView!
    @IBOutlet weak var ImagenPrincipal: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    var selectedImageIndex: Int?
    var image: UIImage?
    var imageBase64: String?
    var images: [UIImage]?
    var imagePicker = UIImagePickerController()
    var galeriaViewModel : ImagenesGaleriaViewModel?
    var idEmpresa: String?
    var editar : Bool?
    var base: BaseController = BaseController()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
        galeriaViewModel = ImagenesGaleriaViewModel()
        galeriaViewModel?.delegate = self
        galeriaViewModel?.getImagenesGaleria(idEmpresa: idEmpresa!)
        collectionView.delegate = self
        collectionView.dataSource = self
        images = [UIImage]()
        imagePicker.delegate = self
        ImagenPrincipal.layer.borderWidth = 1
        ImagenPrincipal.layer.borderColor = UIColor.white.cgColor
        editar = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    @IBAction func tapEditar(_ sender: Any) {
        if((galeriaViewModel?.listaImagenesGaleria?.count)! > 0){
            editar = true
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tapback(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapAddImage(_ sender: Any) {
        editar = false
        if ((galeriaViewModel?.listaImagenesGaleria?.count)! <= 6){
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "", message: "Limite de imagenes alcanzado.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func setEmpresa(idEmpresa: String){
        self.idEmpresa = idEmpresa
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
        cropViewController.imageCropFrame = CGRect(x: 0, y: 0, width: 353, height: 231)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.5)! as NSData
        imageBase64 = imageData.base64EncodedString()
        if editar! {
            self.editImagen()
        }else{
            self.sendImage()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func editImagen(){
        galeriaViewModel?.editarImagenGaleria(id: (galeriaViewModel?.listaImagenesGaleria![selectedImageIndex!].id)!, imagen: imageBase64!, idEmpresa: idEmpresa!)
    }
    
    func sendImage(){
        galeriaViewModel?.enviarImagenGaleria(imagen: imageBase64!, idEmpresa: idEmpresa!)
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellGaleria = collectionView.dequeueReusableCell(withReuseIdentifier: "galeria", for: indexPath) as UICollectionViewCell
        let image = cellGaleria.viewWithTag(1) as! UIImageView
        if (galeriaViewModel?.listaImagenesGaleria != nil){
            if ((galeriaViewModel?.listaImagenesGaleria?.count)! > 0){
                image.downloadedFrom(link: (galeriaViewModel?.listaImagenesGaleria?[indexPath.row].url)!)
                
            }
        }
        return cellGaleria
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (galeriaViewModel?.listaImagenesGaleria?.count == 0 || galeriaViewModel?.listaImagenesGaleria == nil){
            return 1
        }else{
            return (galeriaViewModel?.listaImagenesGaleria?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ((galeriaViewModel?.listaImagenesGaleria?.count)! > 0){
             self.ImagenPrincipal.downloadedFrom(link: (galeriaViewModel?.listaImagenesGaleria?[indexPath.row].url)!)
             selectedImageIndex = indexPath.row
        }
    }
    
    func finishGetingImagenesGaleria() {
        if (galeriaViewModel?.listaImagenesGaleria?.count != 0){
            collectionView.reloadData()
            ImagenPrincipal.downloadedFrom(link: (galeriaViewModel?.listaImagenesGaleria?.last?.url)!)
            selectedImageIndex = (galeriaViewModel?.listaImagenesGaleria?.count)! - 1
        }
    }
    
    func finishSendingImagenesGaleria() {
        galeriaViewModel?.getImagenesGaleria(idEmpresa: idEmpresa!)
        let alert = UIAlertController(title: "", message: "Imagen guardada correctamente.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
