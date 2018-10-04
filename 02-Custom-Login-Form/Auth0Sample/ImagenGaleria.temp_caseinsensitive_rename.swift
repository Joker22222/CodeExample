//
//  imagen.swift
//  GuiApp
//
//  Created by Fernando Garay on 18/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class Imagen {
    
    let id : String
    let idEmpresa: String
    let idPublicacion: String
    let idEvento: String
    let imagen: String
    
    
    init(json: JSON){
        id = json[Constants.Imagen.id].stringValue
        idEmpresa = json[Constants.Imagen.idEmpresa].stringValue
        idPublicacion = json[Constants.Imagen.idPublicacion].stringValue
        idEvento = json[Constants.Imagen.idEvento].stringValue
        imagen = json[Constants.Imagen.imagen].stringValue
    }
}

