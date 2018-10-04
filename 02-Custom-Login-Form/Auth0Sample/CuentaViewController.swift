//
//  CuentaViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 16/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class CuentaViewController: Base, UITableViewDataSource, UITableViewDelegate, CuentaViewModelDelegate {
    
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var lblMail: UILabel!
    @IBOutlet weak var lblNombreDeUsuario: UILabel!
    var viewModel : CuentaViewModel?
    var base: BaseController = BaseController()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        viewModel = CuentaViewModel()
        viewModel?.delegate = self
        startAnimating()
        viewModel?.getPaquetes()
        setUpViews()
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setUpViews(){
        lblMail.text = UserDefaults.standard.string(forKey: "Mail")
        lblNombreDeUsuario.text = UserDefaults.standard.string(forKey: "Name")
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (viewModel?.listaPaquetes != nil){
            return (viewModel?.listaPaquetes?.count)!
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cuentaCell", for: indexPath) as!CuentaTableViewCell
        cell.imgCuenta.downloadedFrom(link: (viewModel?.listaPaquetes![indexPath.row].logo)!)
        cell.selectionStyle = .none
        cell.lblTitulo.text = viewModel?.listaPaquetes![indexPath.row].nombre
        cell.lblDescripcion.text = viewModel?.listaPaquetes![indexPath.row].descripcion
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetalleCuenta") as! DetalleCuentaViewController
        vc.setPaquete(paquete: (viewModel?.listaPaquetes![indexPath.row])!)
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
   
    func finishGetingMisPaquetes() {
        stopAnimating()
        table.reloadData()
    }
    
}
