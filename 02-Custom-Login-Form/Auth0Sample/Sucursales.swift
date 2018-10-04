//
//  Sucursales.swift
//  GuiApp
//
//  Created by Fernando Garay on 28/04/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class Sucursales {
    
    let sucursales : [Sucursal]
    
    init (json: JSON){
        
        var auxSucursales = [Sucursal]()
        
        for (_,subjson):(String, JSON) in json[]{
            var sucursal : Sucursal
            sucursal = Sucursal(json: subjson)
            auxSucursales.append(sucursal)
        }
        sucursales = auxSucursales
    }
}
