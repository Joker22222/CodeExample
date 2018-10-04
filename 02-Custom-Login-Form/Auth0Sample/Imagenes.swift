//
//  Imagenes.swift
//  GuiApp
//
//  Created by Fernando Garay on 18/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class Imagenes {
    
    let imagenes : [Imagen]
    
    init (json: JSON){
        
        var auxImagenes = [Imagen]()
        
        for (_,subjson):(String, JSON) in json[]{
            var imagen : Imagen
            imagen = Imagen(json: subjson)
            auxImagenes.append(imagen)
        }
        imagenes = auxImagenes
    }
}
