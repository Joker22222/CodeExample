//
//  Paquete.swift
//  GuiApp
//
//  Created by Fernando Garay on 17/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//


import Foundation
import SwiftyJSON


class Paquete {
    
    let id : String
    let imagen:String
    let nombre: String
    let descripcion: String
    let costo: String
    let duracion: String
    let logo: String
    let activo: String
    
    init(json: JSON){
        
        id = json[Constants.Paquete.id].stringValue
        imagen = json[Constants.Paquete.imagen].stringValue
        nombre = json[Constants.Paquete.nombre].stringValue
        descripcion = json[Constants.Paquete.descripcion].stringValue
        costo = json[Constants.Paquete.costo].stringValue
        duracion = json[Constants.Paquete.duracion].stringValue
        logo = json[Constants.Paquete.logo].stringValue
        activo = json[Constants.Paquete.activo].stringValue
    }
}
