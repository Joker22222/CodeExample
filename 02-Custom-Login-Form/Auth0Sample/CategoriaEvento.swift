//
//  categoriaEvento.swift
//  GuiApp
//
//  Created by Fernando Garay on 07/07/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoriaEvento {
    
    let id : String
    let tipo : String
    
    init(json: JSON){
        id = json[Constants.EventosCategoria.id].stringValue
        tipo = json[Constants.EventosCategoria.tipo].stringValue
    }
}
