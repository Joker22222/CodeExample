//
//  DetalleBusquedaViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 12/1/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import Foundation

class DetalleBusquedaViewController: Base, UITableViewDataSource, UITableViewDelegate, EmpresaViewModelDelegate, SucursalesViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagenesGaleriaDelegate {
    
    
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btTwitter: UIButton!
    @IBOutlet weak var btInstagram: UIButton!
    @IBOutlet weak var btFace: UIButton!
    @IBOutlet weak var lbCuit: UILabel!
    @IBOutlet weak var lbRazonSocial: UILabel!
    var idEmpresa: String?
    var empresaViewModel: EmpresaViewModel?
    var sucursalViewModel: SucursalesViewModel?
    var galeriaViewModel: ImagenesGaleriaViewModel?
    
    @IBOutlet weak var table: UITableView!
    let vcDetalle = DetalleSucursal(nibName: "DetalleSucursal", bundle: nil)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "GaleriaViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GaleriaViewCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        empresaViewModel = EmpresaViewModel()
        sucursalViewModel = SucursalesViewModel()
        empresaViewModel?.delegate = self
        sucursalViewModel?.delegate = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        startAnimating()
        empresaViewModel?.recibirPorId(id: idEmpresa!)
        empresaViewModel?.recibirImagenes(idEmpresa: idEmpresa!)
        table.separatorStyle = .none
        galeriaViewModel?.delegate = self
        galeriaViewModel?.getImagenesGaleria(idEmpresa: idEmpresa!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapFace(_ sender: Any) {
        UIApplication.tryURL(urls: [
            (empresaViewModel?.empresas?.empresas[0].facebook)! // Website if app fails
            ])
    }
    @IBAction func tapInstagram(_ sender: Any) {
        UIApplication.tryURL(urls: [
            (empresaViewModel?.empresas?.empresas[0].instagram)! // Website if app fails
            ])
    }
    
    @IBAction func tapTwitter(_ sender: Any) {
        UIApplication.tryURL(urls: [
            (empresaViewModel?.empresas?.empresas[0].twitter)! // Website if app fails
            ])
    }
    @IBAction func backTap(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
        
    }
    public func setIdEmpresa (idEmpresa: String){
        self.idEmpresa = idEmpresa
    }
    
    func setUpViews (){
        if (empresaViewModel?.empresas?.empresas[0].facebook == ""){
            btFace.isHidden = true
        }
        if (empresaViewModel?.empresas?.empresas[0].twitter == ""){
            btTwitter.isHidden = true
        }
        if (empresaViewModel?.empresas?.empresas[0].instagram == ""){
            btInstagram.isHidden = true
        }
        if let cuit = empresaViewModel?.empresas?.empresas[0].cuit {
            lbCuit.text = "CUIT: " + cuit
        }else{
            lbCuit.text = "CUIT: "
        }
        if let razonSocial = empresaViewModel?.empresas?.empresas[0].razonSocial{
            lblTitulo.text = razonSocial
            lbRazonSocial.text = razonSocial
        }else{
            lbRazonSocial.text = ""
        }
    }
    
    func setUpImagenes(){
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sucursalViewModel?.listaSucursales == nil {
            return 0
        }else{
            return (sucursalViewModel?.listaSucursales?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "detalleCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "detalleCell", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        cell.lblSucursal.text = sucursalViewModel?.listaSucursales![indexPath.row].razonSocial
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vcDetalle.setIdSucursal(idSucursal: (sucursalViewModel?.listaSucursales![indexPath.row].id)!)
        self.present(self.vcDetalle, animated: true, completion: nil)
    }
    
    func finishSendingEmpresa() {
        
    }
    
    func finishGettingEmpresas(empresas: Empresas) {
        
    }
    
    func finishSendingImagenEmpresa() {
        
    }
    
    func finishGettingEmpresasById() {
        setUpViews()
        sucursalViewModel?.getSucursales(id: idEmpresa!)
    }
    func finishGettingImagenes() {
        stopAnimating()
        setUpImagenes()
    }
    
    func finishSendingSucursales() {
        
    }
    
    func finishGettingSucursales() {
        table.reloadData()
    }
   
    func finishGettingSucursalesById() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ( galeriaViewModel != nil){
            if (galeriaViewModel?.listaImagenesGaleria?.count == 0){
                return 1
            }else{
                return (galeriaViewModel?.listaImagenesGaleria?.count)!
            }
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GaleriaViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GaleriaViewCollectionViewCell", for: indexPath) as! GaleriaViewCollectionViewCell
        if ((galeriaViewModel?.listaImagenesGaleria?.count)! > 0){
            cell.image.downloadedFrom(link: (galeriaViewModel?.listaImagenesGaleria![indexPath.row].url)!)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 209, height: 149)
    }
   
    func finishGetingImagenesGaleria() {
        collectionView.reloadData()
    }
    
    func finishSendingImagenesGaleria() {
        
    }
    
    
}


extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                //application.openURL(URL(string: url)!)
                if #available(iOS 10.0, *) {
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                return
            }
        }
    }
}
