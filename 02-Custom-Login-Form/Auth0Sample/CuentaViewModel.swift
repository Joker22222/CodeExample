//
//  CuentaViewModel.swift
//  GuiApp
//
//  Created by Fernando Garay on 17/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import Alamofire
protocol CuentaViewModelDelegate {
    func finishGetingMisPaquetes()
}

class CuentaViewModel{
    
    var delegate : CuentaViewModelDelegate?
    var listaPaquetes: [Paquete]?
    var paquetes : Paquetes?
    init(){}
    
    func getPaquetes(){
    
        APIClient.getPaquetes ({ (result, error) in
            if error == nil {
                self.paquetes = result
                self.listaPaquetes = self.paquetes?.paquetes
                self.delegate?.finishGetingMisPaquetes()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
}

