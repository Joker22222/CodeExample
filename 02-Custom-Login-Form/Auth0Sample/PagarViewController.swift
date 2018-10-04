//
//  PagarViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 18/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit
import WebKit


class PagarViewController: UIViewController, UIWebViewDelegate {
    var idPaquete:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let idCuenta = UserDefaults.standard.string(forKey: "Mail")
        var base64URL = "0"
        if let idCuentabase64 = idCuenta?.base64Encoded() {
            base64URL = base64ToBase64url(base64: idCuentabase64)
        }
        let idCuentaBase64URL = base64URL
        
        let myWebView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40))
        
        self.view.addSubview(myWebView)
        
        myWebView.delegate = self
        
        myWebView.loadRequest(URLRequest(url: URL(string: "http://www.guiappworldwide.com/guiappmp/compra/index.php?idpaq="+idPaquete!+"&extref="+idCuentaBase64URL)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapVolver(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    public func setIdPaquete(paquete:String){
        idPaquete = paquete
    }
    
    func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
}
