//
//  Permiso.swift
//  GuiApp
//
//  Created by Fernando Garay on 19/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class Permiso {
    
    let id : String
    let funcion: String
    let cantidad: String
    let idModulo: String
    let modulo: String
    let limAlcanzado: String
    
    
    init(json: JSON){
        id = json[Constants.Funcion.id].stringValue
        funcion = json[Constants.Funcion.funcion].stringValue
        cantidad = json[Constants.Funcion.cantidad].stringValue
        idModulo = json[Constants.Funcion.idModulo].stringValue
        modulo = json[Constants.Funcion.modulo].stringValue
        limAlcanzado = json[Constants.Funcion.limAlcanzado].stringValue
    }
}
