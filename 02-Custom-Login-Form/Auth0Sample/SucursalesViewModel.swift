//
//  SucursalesViewModel.swift
//  GuiApp
//
//  Created by Fernando Garay on 24/04/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol SucursalesViewModelDelegate {
    func finishSendingSucursales()
    func finishGettingSucursales()
    func finishGettingSucursalesById()
}

class SucursalesViewModel{
    var delegate : SucursalesViewModelDelegate?
    var sucursales: Sucursales?
    var listaSucursales: [Sucursal]?
    init(){
        
}

    func enviarSucursal (idEmpresa: String, direccion: String, latitud: String, longitud: String,  telefono: String, delivery: String, veinticuatroHs: String, diasHorarios: String){
        let id = UUID().uuidString
       
        let parameters : [String: Any] = [
            "id":  id,
            "idempresa":  idEmpresa,
            "direccion": direccion,
            "latitud": latitud,
            "longitud": longitud,
            "telefono": telefono,
            "delivery": delivery,
            "veinticuatrohs": veinticuatroHs,
            "diashorarios": diasHorarios,
            "dirty": "1",
        ]
        
        APIClient.postSucursales(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingSucursales()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func getSucursales(id: String) {
        APIClient.getSucursales(id, completion: { (result, error) in
            if error == nil {
                self.sucursales = result
                self.listaSucursales = self.sucursales?.sucursales
                self.delegate?.finishGettingSucursales()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func getSucursalesById(id: String) {
        APIClient.getSucursalesById(id, completion: { (result, error) in
            if error == nil {
                self.sucursales = result
                self.listaSucursales = self.sucursales?.sucursales
                self.delegate?.finishGettingSucursalesById()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func actualizarSucursal (id: String, idEmpresa: String, direccion: String, latitud: String, longitud: String,  telefono: String, delivery: String, veinticuatroHs: String, diasHorarios: String){
        
        
        let parameters : [String: Any] = [
            "idempresa":  idEmpresa,
            "direccion": direccion,
            "latitud": latitud,
            "longitud": longitud,
            "telefono": telefono,
            "delivery": delivery,
            "veinticuatrohs": veinticuatroHs,
            "diashorarios": diasHorarios,
            "dirty": "1",
            ]
        
        APIClient.putSucursales(id, parametros: parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingSucursales()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
}
