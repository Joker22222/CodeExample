//
//  HomeViewModel.swift
//  GuiApp
//
//  Created by Fernando  on 2/27/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import UIKit
protocol HomeViewModelDelegate {
    func finishedGettingEventos()
    func finishedGettingPublicaciones()
    func finishedGettingPublicacionesDest()
    func finishedGettingEventosWithError(_ error: NSError)
}

class HomeViewModel{
    
    var delegate: HomeViewModelDelegate?
    var eventos : Eventos?
    var listaEventos : [Evento]?
    var publicaciones : Publicaciones?
    var listaPublicaciones: [Publicacion]?
    var publicacionesDest : PublicacionesDest?
    var listaPublicacionesDest: [PublicacionDest]?
    init(){}
    func getEventos(){
        //Evetos
        APIClient.getEventos { (result, error) in
            if error == nil {
                self.eventos = result
                self.listaEventos = result?.eventos
                self.delegate?.finishedGettingEventos()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        }
    }
    
    func getpublicaciones(){
        //Publicaciones
        APIClient.getPublicaciones { (result, error) in
            if error == nil {
                self.publicaciones = result
                self.listaPublicaciones = result?.publicaciones
                self.delegate?.finishedGettingPublicaciones()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        }
    }
    func getDestacadas(){
        
        //Publicaciones Destacadas
        APIClient.getPublicacionesDest { (result, error) in
            if error == nil {
                self.publicacionesDest = result
                self.listaPublicacionesDest = result?.publicacionesDest
                self.delegate?.finishedGettingPublicacionesDest()
            } else {
                //Show error
                //self.delegate?.finishedGettingProjectsWithError(error!)
            }
        }
    
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
