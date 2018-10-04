//
//  Sucursal.swift
//  GuiApp
//
//  Created by Fernando Garay on 28/04/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON


class Sucursal {
    
    let id : String
    let idEmpresa: String
    let razonSocial: String
    let estado: String
    let direccion: String
    let idPais: String
    let idProvincia: String
    let idLocalidad: String
    let telefono: String
    let delivery: String
    let veinticuatroHs: String
    let diasHorarios: String
    let dirty: String
    let palabrasClave: String
    let latitud: String
    let longitud: String
    
    init(json: JSON){
        
        id = json[Constants.Sucursal.id].stringValue
        idEmpresa = json[Constants.Sucursal.idEmpresa].stringValue
        razonSocial = json[Constants.Sucursal.razonSocial].stringValue
        estado = json[Constants.Sucursal.estado].stringValue
        direccion = json[Constants.Sucursal.direccion].stringValue
        idPais = json[Constants.Sucursal.idPais].stringValue
        idProvincia = json[Constants.Sucursal.idProvincia].stringValue
        idLocalidad = json[Constants.Sucursal.ideLocalidad].stringValue
        telefono = json[Constants.Sucursal.telefono].stringValue
        delivery = json[Constants.Sucursal.delivary].stringValue
        veinticuatroHs = json[Constants.Sucursal.veinticuatroHs].stringValue
        diasHorarios = json[Constants.Sucursal.diasHorarios].stringValue
        dirty = json[Constants.Sucursal.dirty].stringValue
        palabrasClave = json[Constants.Sucursal.palabrasCalve].stringValue
        latitud = json[Constants.Sucursal.latitud].stringValue
        longitud = json[Constants.Sucursal.longitud].stringValue
    }
}
