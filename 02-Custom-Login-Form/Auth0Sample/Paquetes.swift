//
//  Paquetes.swift
//  GuiApp
//
//  Created by Fernando Garay on 17/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class Paquetes {
    
    let paquetes : [Paquete]
    
    init (json: JSON){
        
        var auxPaquetes = [Paquete]()
        
        for (_,subjson):(String, JSON) in json[]{
            var paquete : Paquete
            paquete = Paquete(json: subjson)
            auxPaquetes.append(paquete)
        }
        paquetes = auxPaquetes
    }
}
