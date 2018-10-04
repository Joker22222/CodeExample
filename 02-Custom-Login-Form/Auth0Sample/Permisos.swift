//
//  Permisos.swift
//  GuiApp
//
//  Created by Fernando Garay on 19/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class Permisos {
    
    let permisos : [Permiso]
    
    init (json: JSON){
        
        var auxPermisos = [Permiso]()
        
        for (_,subjson):(String, JSON) in json[]{
            var permiso : Permiso
            permiso = Permiso(json: subjson)
            auxPermisos.append(permiso)
        }
        permisos = auxPermisos
    }
}
