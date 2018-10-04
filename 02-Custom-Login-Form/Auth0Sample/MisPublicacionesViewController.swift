//
//  MisPublicacionesViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 6/2/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
protocol MisPublicacionesDelegate {
    func finishedGettingPublicaciones(titulo: String, descripcion: String, id: String, destacada:String, idEmpresa: String, razonSocial: String, imagen: String)
}
class MisPublicacionesViewController: Base, UITableViewDataSource, UITableViewDelegate, MisPublicacionesViewModelDelegate {
    var base: BaseController = BaseController()
    
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModel : MisPublicacionesViewModel?
    var delegate:MisPublicacionesDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel = MisPublicacionesViewModel()
        viewModel?.delegate = self
        startAnimating()
        viewModel?.getMisPublicaciones()
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (viewModel?.listaPublicaciones == nil){
            return 0
        }else{
            return (viewModel?.listaPublicaciones?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicacionesCell", for: indexPath) as!MisPublicacionesTableViewCell
        cell.selectionStyle = .none
        cell.imgPubli.downloadedFrom(link: (viewModel?.listaPublicaciones?[indexPath.row].imagen)!)
        cell.titulo.text = viewModel?.listaPublicaciones?[indexPath.row].titulo
        cell.descripcion.text = viewModel?.listaPublicaciones?[indexPath.row].descripcion
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.finishedGettingPublicaciones(titulo: (viewModel?.listaPublicaciones?[indexPath.row].titulo)!,
                                               descripcion: (viewModel?.listaPublicaciones?[indexPath.row].descripcion)!,
                                               id: (viewModel?.listaPublicaciones?[indexPath.row].id)!,
                                               destacada: (viewModel?.listaPublicaciones?[indexPath.row].destacada)!,
                                               idEmpresa: (viewModel?.listaPublicaciones?[indexPath.row].idEmpresa)!,
                                               razonSocial: (viewModel?.listaPublicaciones?[indexPath.row].razonSocial)!,
                                               imagen:(viewModel?.listaPublicaciones?[indexPath.row].imagen)!)
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    @IBAction func tapBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func finishGetingMisPublicaciones() {
        stopAnimating()
        tableView.reloadData()
    }
}
