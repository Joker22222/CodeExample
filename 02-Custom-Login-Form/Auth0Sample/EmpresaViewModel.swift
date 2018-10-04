//
//  EmpresaViewModel.swift
//  GuiApp
//
//  Created by Fernando Garay on 19/04/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation


protocol EmpresaViewModelDelegate {
    func finishSendingEmpresa()
    func finishGettingEmpresas(empresas: Empresas)
    func finishGettingEmpresasById()
    func finishSendingImagenEmpresa()
    func finishGettingImagenes()
}

class EmpresaViewModel{
    var empresas: Empresas?
    var listaEmpresas: [Empresa]?
    var imagenes: Imagenes?
    var listaImagenes: [Imagen]?
    var delegate : EmpresaViewModelDelegate?
    
    init(){
    
    }
    
    func recibir (){
        let idCuenta = UserDefaults.standard.string(forKey: "Mail")
        var base64URL = "0"
        if let idCuentabase64 = idCuenta?.base64Encoded() {
            base64URL = base64ToBase64url(base64: idCuentabase64)
        }
        let idCuentaBase64URL = base64URL
        APIClient.getEmpresas (idCuentaBase64URL, completion: { (result, error) in
            if error == nil {
                self.empresas = result
                self.listaEmpresas = self.empresas?.empresas
                self.delegate?.finishGettingEmpresas(empresas: self.empresas!)
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func guardar (id: String, razonSocial: String, cuit: String, metodoPago:String, estado: String, facebook: String, instagram: String, twitter:String, palabrasClaves: String, categoria: String){
        
        let idCuenta = UserDefaults.standard.string(forKey: "Mail")
        var base64URL = "0"
        if let idCuentabase64 = idCuenta?.base64Encoded() {
            base64URL = base64ToBase64url(base64: idCuentabase64)
        }
        let idCuentaBase64URL = base64URL
        let parameters : [String: Any] = [
            "id":id,
            "razonsocial":razonSocial,
            "cuit":cuit,
            "mediodepago":metodoPago,
            "estado":estado,
            "logo": "",
            "facebook": "www.facebook.com/" + facebook,
            "twitter": "www.twitter.com/" + twitter,
            "instagram": "www.instagram.com/" + instagram,
            "palabrasclave":palabrasClaves,
            "url":"",
            "dirty": "1",
            "idcuenta":idCuentaBase64URL
            ]
        
        APIClient.postEmpresas(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingEmpresa()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func Actualizar (id: String, razonSocial: String, cuit: String, metodoPago:String, estado: String, facebook: String, instagram: String, twitter:String, palabrasClaves: String, categoria: String){
        
        let idCuenta = UserDefaults.standard.string(forKey: "Mail")
        var base64URL = "0"
        if let idCuentabase64 = idCuenta?.base64Encoded() {
            base64URL = base64ToBase64url(base64: idCuentabase64)
        }
        let idCuentaBase64URL = base64URL
        let parameters : [String: Any] = [
            "razonsocial":razonSocial,
            "cuit":cuit,
            "mediodepago":metodoPago,
            "estado":estado,
            "logo": "",
            "facebook":facebook,
            "twitter":twitter,
            "instagram":instagram,
            "palabrasclave":palabrasClaves,
            "web":"",
            "dirty": "1",
            "idcuenta":idCuentaBase64URL
        ]
        
        APIClient.putEmpresas(id, parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingEmpresa()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func recibirPorId (id: String){
        APIClient.getEmpresasById (id, completion: { (result, error) in
            if error == nil {
                self.empresas = result
                self.listaEmpresas = self.empresas?.empresas
                self.delegate?.finishGettingEmpresasById()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func postImagenEmpresa (id: String, imagen: String){
        
        let parameters : [String: Any] = [
            "id":  id,
            "image": imagen,
            ]
        
        APIClient.postImagenEmpresa(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingImagenEmpresa()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func putImagenEmpresa (id: String, imagen: String){
        
        let parameters : [String: Any] = [
            "id":  id,
            "image": imagen,
            ]
        
        APIClient.putImagenEmpresa(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingImagenEmpresa()
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
    
    func recibirImagenes (idEmpresa: String){
        
        APIClient.getImagenes(idEmpresa, completion: { (result, error) in
            if error == nil {
                self.imagenes = result
                self.listaImagenes = self.imagenes?.imagenes
                self.delegate?.finishGettingImagenes()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
}

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    

}
