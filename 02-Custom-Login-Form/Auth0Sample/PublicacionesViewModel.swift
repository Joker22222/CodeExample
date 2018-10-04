//
//  PublicacionesViewModel.swift
//  GuiApp
//
//  Created by Fernando Garay on 30/04/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol PublicacionesViewModelDelegate {
    func finishSendingPublicaciones()
    func finishSendingImagenPublicaciones()
}

class PublicacionesViewModel{
    var delegate : PublicacionesViewModelDelegate?
    init(){}
    func postPublicaciones (id: String, destacada:String, titulo: String, imagen: String, descripcion: String, idEmpresa: String){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let diasHorarios = formatter.string(from: date)
        let parameters : [String: Any] = [
            "id":  id,
            "titulo":  titulo,
            "imagen": imagen,
            "descripcion": descripcion,
            "idempresa": idEmpresa,
            "dirty": "1",
            "destacada": destacada,
            "fecmodificacion": diasHorarios
            ]
        
        APIClient.postPublicacion(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingPublicaciones()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func postImagenPublicaciones (id: String, imagen: String){
        
        let parameters : [String: Any] = [
            "id":  id,
            "image": imagen,
        ]
        
        APIClient.postImagenPublicacion(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingImagenPublicaciones()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func putPublicaciones (id: String, destacado: String, titulo: String, imagen: String, descripcion: String, idEmpresa: String){
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let diasHorarios = formatter.string(from: date)
        let parameters : [String: Any] = [
            "id":  id,
            "titulo":  titulo,
            "imagen": imagen,
            "descripcion": descripcion,
            "idempresa": idEmpresa,
            "dirty": "1",
            "destacada": destacado,
            "fecmodificacion": diasHorarios
        ]
        
        APIClient.putPublicacion(id, parametros: parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingPublicaciones()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func putImagenPublicaciones (id: String, imagen: String){
        
        let parameters : [String: Any] = [
            "id":  id,
            "image": imagen,
            ]
        
        APIClient.putImagenPublicacion(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingImagenPublicaciones()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
}
