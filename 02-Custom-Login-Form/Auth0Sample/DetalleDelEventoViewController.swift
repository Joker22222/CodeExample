//
//  DetalleDelEventoViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 07/07/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class DetalleDelEventoViewController: Base, EventosBusquedaViewModelDelegate {
   
    @IBOutlet weak var btnEditar: UIButton!
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var imgImagen: UIImageView!
    @IBOutlet weak var lblCategoria: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblLugar: UILabel!
    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    var evento : Evento?
    var base: BaseController = BaseController()
    var viewModel : EventosViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
        let idCuenta = UserDefaults.standard.string(forKey: "Mail")
        var base64URL = "0"
        if let idCuentabase64 = idCuenta?.base64Encoded() {
            base64URL = base64ToBase64url(base64: idCuentabase64)
        }
        let idCuentaBase64URL = base64URL
        viewModel = EventosViewModel()
        viewModel?.delegate = self
        if (UserDefaults.standard.bool(forKey: "Invitado")){
            btnEditar.isHidden = true
        } else {
            if (idCuentaBase64URL == evento?.idCuenta){
                btnEditar.isHidden = false
            }else{
                btnEditar.isHidden = true
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let ev = evento {
            startAnimating()
            viewModel?.getEventosById(id: ev.id)
        }
    }
    public func setEvento(evento: Evento) {
        self.evento = evento
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    @IBAction func tapVolver(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tapEditar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EdicionEvento") as! EdicionDeEventoViewController
        vc.setEvento(evento: evento!)
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    func setUpViews() {
        if lblTitulo != nil {
            imgImagen.downloadedFrom(link: (evento?.imagen)!)
            lblCategoria.text = evento?.tipo
            lblLugar.text = evento?.ubicacion
            lblFecha.text = evento?.fechaInicio
            lblHora.text = evento?.horaInicio
            lblDescripcion.text = evento?.descripcion
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
    
    func finishGetingMisEventos() {
        evento = viewModel?.listaEventos![0]
        setUpViews()
        stopAnimating()
    }
    
    func finishGetingCategorias() {
        
    }
    
    func finishSendingEventos() {
        
    }
    
    func finishSendingImagenEvento() {
        
    }
}
