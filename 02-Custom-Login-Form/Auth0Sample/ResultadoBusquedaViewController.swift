//
//  ResultadoBusquedaViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 12/1/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class ResultadoBusquedaViewController: Base, UITableViewDataSource, UITableViewDelegate, ResultadoDeBusquedaViewModelDelegate, MapDelegate {
    
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var btnFlecha: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tfBusqueda: UITextField!
    var base: BaseController = BaseController()
    let vcDetalle = DetalleBusquedaViewController(nibName: "DetalleBusquedaViewController", bundle: nil)
    var param: String?
    var latitud: String?
    var longitud: String?
    var cat: String?
    var viewModel: ResultadoDeBusquedaViewModel?
    var resultadosDeBusqueda : ResultadosDeBusqueda?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating()
        viewModel = ResultadoDeBusquedaViewModel(parametro: param!, latitud: latitud!, longitud: longitud!, cat: cat!)
        viewModel?.delegate = self
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    @IBAction func tapMap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mapa") as! MapViewController
        vc.delegate = self
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapBuscar(_ sender: Any) {
        startAnimating()
        view.endEditing(true)
        param = tfBusqueda.text
        viewModel = ResultadoDeBusquedaViewModel(parametro: param!, latitud: latitud!, longitud: longitud!, cat: cat!)
        viewModel?.delegate = self
    }
    
    @IBAction func tapBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (viewModel!.listaResultadosDeBusqueda?.count == nil){
            return 0
        }else{
            return (viewModel!.listaResultadosDeBusqueda?.count)!}
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultadoCell", for: indexPath) as! ResultadoBusquedaTableViewCell
        cell.selectionStyle = .none
        cell.lblnombre.text = viewModel?.listaResultadosDeBusqueda![indexPath.row].razonSocial
        cell.lblDireccion.text = viewModel?.listaResultadosDeBusqueda![indexPath.row].direccion
        cell.lblComentario.text = viewModel?.listaResultadosDeBusqueda![indexPath.row].estado
        if (viewModel?.listaResultadosDeBusqueda![indexPath.row].veinticuatroHs == "1"){
            cell.img24hs.isHidden = false
        }else{
            cell.img24hs.isHidden = true
        }
        if (viewModel?.listaResultadosDeBusqueda![indexPath.row].delivery == "1"){
            cell.imgEnvios.isHidden = false
        }else{
            cell.imgEnvios.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vcDetalle.setIdEmpresa(idEmpresa: (viewModel?.listaResultadosDeBusqueda![indexPath.row].idEmpresa)!)
        self.present(self.vcDetalle, animated: true, completion: nil)
    }
    
    func finishGetingResults() {
        resultadosDeBusqueda = viewModel?.resultadosDeBusqueda!
        table.reloadData()
        stopAnimating()
    }
    func finishedSettingCoodenadas(longitud: String, latitud: String) {
        self.latitud = latitud
        self.longitud = longitud
    }
    
    

}
