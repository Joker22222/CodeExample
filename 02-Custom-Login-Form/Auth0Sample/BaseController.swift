//
//  BaseController.swift
//  GuiApp
//
//  Created by Fernando Garay on 24/04/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import UIKit

class BaseController{
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let empresas = UIAlertAction(title: "Empresas", style: .default) { action in
            if (UserDefaults.standard.bool(forKey: "Invitado")){
                let alert = UIAlertController(title: "", message: "Necesita registrarse para poder dar de alta empresas. Cierre la app para volver a intentaro.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "empresas") as! EmpresasViewController
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
        
        let cuenta = UIAlertAction(title: "Premium!", style: .default) { action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Cuenta") as! CuentaViewController
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
        
        let terminosYCondiciones = UIAlertAction(title: "Terminos y condiciones", style: .default) { action in
            
        }
        
        actionSheet.addAction(cuenta)
        actionSheet.addAction(empresas)
        actionSheet.addAction(terminosYCondiciones)
        actionSheet.addAction(cancel)
        
        UIApplication.topViewController()?.present(actionSheet, animated: true, completion: nil)
        
    }
    
}
