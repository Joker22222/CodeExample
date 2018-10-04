//
//  DetalleCuentaViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 18/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class DetalleCuentaViewController: UIViewController {
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var lblDias: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var imgImagen: UIImageView!
    var paquete: Paquete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    public func setPaquete (paquete: Paquete){
        self.paquete = paquete
    }
    
    @IBAction func tapObtenerPremios(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pagar") as! PagarViewController
        vc.setIdPaquete(paquete: (paquete?.id)!)
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapBack(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setUpViews(){
        lblTitulo.text = paquete?.nombre
        lblDescripcion.text = paquete?.descripcion
        lblPrecio.text = "$"+(paquete?.costo)!
        lblDias.text = paquete?.duracion
        imgImagen.downloadedFrom(link: (paquete?.imagen)!)
    }
   
}
