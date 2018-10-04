//
//  categoriaEventos.swift
//  GuiApp
//
//  Created by Fernando Garay on 07/07/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoriaEventos {
    
    let categoriaEventos : [CategoriaEvento]
    
    init (json: JSON){
        
        var auxCategoriaEventos = [CategoriaEvento]()
        
        for (_,subjson):(String, JSON) in json[]{
            var categoriaEvento : CategoriaEvento
            categoriaEvento = CategoriaEvento(json: subjson)
            auxCategoriaEventos.append(categoriaEvento)
        }
        categoriaEventos = auxCategoriaEventos
    }
    
    
    
}
