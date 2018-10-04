//
//  MisPublicacionesViewModel.swift
//  GuiApp
//
//  Created by Fernando Garay on 15/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import Alamofire
protocol MisPublicacionesViewModelDelegate {
    func finishGetingMisPublicaciones()
}

class MisPublicacionesViewModel{
    
    var delegate : MisPublicacionesViewModelDelegate?
    var listaPublicaciones: [Publicacion]?
    var publicaciones : Publicaciones?
    init(){}
    
    func getMisPublicaciones(){
        let idCuenta = UserDefaults.standard.string(forKey: "Mail")
        var base64URL = "0"
        if let idCuentabase64 = idCuenta?.base64Encoded() {
            base64URL = base64ToBase64url(base64: idCuentabase64)
        }
        let idCuentaBase64URL = base64URL
        APIClient.getPublicacionesByUsuario (idCuentaBase64URL, completion: { (result, error) in
            if error == nil {
                self.publicaciones = result
                self.listaPublicaciones = self.publicaciones?.publicaciones
                self.delegate?.finishGetingMisPublicaciones()
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
    
