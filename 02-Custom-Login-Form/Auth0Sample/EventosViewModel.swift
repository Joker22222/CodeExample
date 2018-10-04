//
//  EventosViewModel.swift
//  GuiApp
//
//  Created by Fernando Garay on 07/07/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import Alamofire
protocol EventosBusquedaViewModelDelegate {
    func finishGetingMisEventos()
    func finishGetingCategorias()
    func finishSendingEventos()
    func finishSendingImagenEvento()
}

class EventosViewModel{
    
    var delegate : EventosBusquedaViewModelDelegate?
    var listaEventos: [Evento]?
    var eventos : Eventos?
    var listaCategoriaEventos: [CategoriaEvento]?
    var categoriaEventos : CategoriaEventos?
    init(){}
    
    
    func getEventosById(id: String){
        
        APIClient.getBusquedaEventosById (id, completion: { (result, error) in
            if error == nil {
                self.eventos = result
                self.listaEventos = self.eventos?.eventos
                self.delegate?.finishGetingMisEventos()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func getEventos(fecha: String, tipo:String){
        
        APIClient.getBusquedaEventos (fecha, tipo: tipo, completion: { (result, error) in
            if error == nil {
                self.eventos = result
                self.listaEventos = self.eventos?.eventos
                self.delegate?.finishGetingMisEventos()
            } else {
               //Show error
               //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func getCategoriaEventos(){
        
        APIClient.getCategoriasEventos(completion: { (result, error) in
            if error == nil {
                self.categoriaEventos = result
                self.listaCategoriaEventos = self.categoriaEventos?.categoriaEventos
                self.delegate?.finishGetingCategorias()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func enviarEventos (id: String, nombre: String, descripcion: String, imagen: String, idTipo: String,  ubicacion: String, fecInicio: String, idEmpresa: String, horaInicio: String){
        
        let parameters : [String: Any] = [
            "id": id,
            "nombre":  nombre,
            "descripcion":  descripcion,
            "imagen": "",
            "idtipo": idTipo,
            "ubicacion": ubicacion,
            "fecinicio": fecInicio,
            "fecfin": "",
            "idempresa": idEmpresa,
            "horainicio": horaInicio,
            "horafin": ""
            ]
        
        APIClient.postEventos(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingEventos()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func editarEventos (id: String, nombre: String, descripcion: String, imagen: String, idTipo: String,  ubicacion: String, fecInicio: String, idEmpresa: String, horaInicio: String){
        
        let parameters : [String: Any] = [
            "id":  id,
            "nombre":  nombre,
            "descripcion":  descripcion,
            "imagen": imagen,
            "idtipo": idTipo,
            "ubicacion": ubicacion,
            "fecinicio": fecInicio,
            "fecfin": "",
            "idempresa": idEmpresa,
            "horainicio": horaInicio,
            "horafin": ""
        ]
        
        APIClient.putEventos(id, parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingEventos()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func postImagenEvento (id: String, imagen: String){
        
        let parameters : [String: Any] = [
            "id":  id,
            "image": imagen,
            ]
        
        APIClient.postImagenEvento(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingImagenEvento()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    func putImagenEvento (id: String, imagen: String){
        
        let parameters : [String: Any] = [
            "id":  id,
            "image": imagen,
            ]
        
        APIClient.putImagenEvento(parameters, completion: { (error) in
            if error == nil {
                self.delegate?.finishSendingImagenEvento()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        })
    }
    
    
}
