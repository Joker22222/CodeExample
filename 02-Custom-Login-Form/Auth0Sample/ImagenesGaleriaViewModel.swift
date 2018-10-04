//
//  ImagenesGaleriaViewModel.swift
//  GuiApp
//
//  Created by Fernando Garay on 27/08/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import Alamofire
protocol ImagenesGaleriaDelegate {
    func finishGetingImagenesGaleria()
    func finishSendingImagenesGaleria()
}

class ImagenesGaleriaViewModel{
    
    var delegate : ImagenesGaleriaDelegate?
    var listaImagenesGaleria: [ImagenGaleria]?
    var imagenesGaleria : ImagenesGaleria?
    init(){}
    
    func getImagenesGaleria(idEmpresa: String){
        APIClient.getImagenesGaleria(idEmpresa, completion:{ (result, error) in
            if error == nil {
                self.imagenesGaleria = result
                self.listaImagenesGaleria = self.imagenesGaleria?.imagenesGaleria
                self.delegate?.finishGetingImagenesGaleria()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func enviarImagenGaleria (imagen: String, idEmpresa: String){
        
        let parameters : [String: Any] = [
            "imagen": imagen,
            "idempresa": idEmpresa,
            "url": ""
        ]
        
        APIClient.postImagenGaleria(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingImagenesGaleria()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func editarImagenGaleria(id: String, imagen: String, idEmpresa: String){
        
        let parameters : [String: Any] = [
            "imagen":  imagen,
            "idempresa": idEmpresa,
            "url": ""
            ]
        
        APIClient.putImagenGaleria(id, parametros: parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingImagenesGaleria()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
}
