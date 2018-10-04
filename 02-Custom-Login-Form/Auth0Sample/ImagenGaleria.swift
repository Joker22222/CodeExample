//
//  imagen.swift
//  GuiApp
//
//  Created by Fernando Garay on 18/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class ImagenGaleria {
    
    let id : String
    let idEmpresa: String
    let url: String
    
    init(json: JSON){
        id = json[Constants.Imagen.id].stringValue
        idEmpresa = json[Constants.Imagen.idEmpresa].stringValue
        url = json[Constants.Imagen.url].stringValue
    }
}

