//
//  Imagenes.swift
//  GuiApp
//
//  Created by Fernando Garay on 18/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

class ImagenesGaleria {
    
    let imagenesGaleria : [ImagenGaleria]
    
    init (json: JSON){
        
        var auxImagenesGaleria = [ImagenGaleria]()
        
        for (_,subjson):(String, JSON) in json[]{
            var imagenGaleria : ImagenGaleria
            imagenGaleria = ImagenGaleria(json: subjson)
            auxImagenesGaleria.append(imagenGaleria)
        }
        imagenesGaleria = auxImagenesGaleria
    }
}
