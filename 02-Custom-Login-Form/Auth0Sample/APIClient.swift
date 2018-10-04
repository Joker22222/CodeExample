    //
//  APIClient.swift
//  GuiApp
//
//  Created by Fernando  on 2/27/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    
    class func getImagenesGaleria(_ idEmpresa:String?, completion:@escaping (_ resultArray: ImagenesGaleria?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getImagenesGaleria + idEmpresa!, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let imagenesObject = ImagenesGaleria(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(imagenesObject, nil)
                    })
                    
                case .failure(let error):
                    return
                }
            })
    }
    
    class func postImagenGaleria(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postImagenesGaleria)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
                
        }
    }
    
    class func putImagenGaleria(_ id:String, parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.putImagenesGaleria + id)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    let eventosUrl = Constants.URL.base+Constants.URL.eventosLista

    //EVENTOS
    class func getEventos(completion:@escaping (_ resultArray: Eventos?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.eventosLista, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
            switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let eventosObject = Eventos(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(eventosObject, nil)
                    })
                
                case .failure(let error):
                return
            }
        })
    }
    
    class func getBusquedaEventosById(_ id:String?, completion:@escaping (_ resultArray: Eventos?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.postEventos + "/" + id!, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let eventosObject = Eventos(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(eventosObject, nil)
                    })
                    
                case .failure(let error):
                    return
                }
            })
    }
    
    class func getBusquedaEventos(_ fecha:String?, tipo: String?, completion:@escaping (_ resultArray: Eventos?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.eventosBusqueda + "/" + tipo! + "/" + fecha!, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let eventosObject = Eventos(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(eventosObject, nil)
                    })
                    
                case .failure(let error):
                    return
                }
            })
    }
    
    class func getCategoriasEventos(completion:@escaping (_ resultArray: CategoriaEventos?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.eventosCategorias, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let categoriaEventosObject = CategoriaEventos(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(categoriaEventosObject, nil)
                    })
                    
                case .failure(let error):
                    return
                }
            })
    }
    
    class func postEventos(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postEventos)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func putEventos(_ id:String, _ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postEventos + "/" + id)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        //not parsing group ID here
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func postImagenEvento(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postImagenEventos)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func putImagenEvento(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postImagenEventos)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    //PUBLICACIONES
    class func getPublicaciones(completion:@escaping (_ resultArray: Publicaciones?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.publicacionesLista, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let publicacionObject = Publicaciones(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(publicacionObject, nil)
                    })
                    
                case .failure(let error):
                    return
                }
            })
    }
    
    //PUBLICACIONES Destacadas
    class func getPublicacionesDest(completion:@escaping (_ resultArray: PublicacionesDest?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.publicacionesDestLista, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let publicacionObjectDest = PublicacionesDest(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(publicacionObjectDest, nil)
                    })
                    
                case .failure(let error):
                    return
                }
            })
    }
    
    //BUSQUEDA PARAM
    class func getResultadosDeBusquedaParam(_ parametros:[[String: Any]], completion:@escaping (_ resultArray: ResultadosDeBusqueda?, _ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.resultadoDeBusquedaParam)!)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let publicacionObject = ResultadosDeBusqueda(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(publicacionObject, nil)
                    })
                    
                case .failure(let error):
                    return
                }
            })
    }
    
    //BUSQUEDA CAT
    class func getResultadosDeBusquedaCat(_ parametros:[[String: Any]], completion:@escaping (_ resultArray: ResultadosDeBusqueda?, _ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.resultadoDeBusquedaCat)!)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let publicacionObject = ResultadosDeBusqueda(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(publicacionObject, nil)
                    })
                    
                case .failure(let error):
                    return
                }
            })
    }
    
    //PUBLICIDAD
    class func getPublicidad(completion:@escaping (_ resultArray: Publicidades?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.publicidad, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let publicidadesObject = Publicidades(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(publicidadesObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
    //POST EMPRESAS
    class func postEmpresas(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postEmpresas)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func postUsuarios(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postUsuarios)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        //not parsing group ID here
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func getEmpresas(_ id:String, completion:@escaping (_ resultArray: Empresas?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getEmpresas + id, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let empresasObject = Empresas(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(empresasObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
    class func putEmpresas(_ id:String, _ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postEmpresas + "/" + id)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func postSucursales(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postSucursales)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func getSucursales(_ id:String, completion:@escaping (_ resultArray: Sucursales?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getSucursales + id, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let sucursalesObject = Sucursales(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(sucursalesObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
    class func postPublicacion(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postPublicacion)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func postImagenPublicacion(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postImagenesPublicacion)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func getEmpresasById(_ id:String, completion:@escaping (_ resultArray: Empresas?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getEmpresasById + id, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let empresasObject = Empresas(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(empresasObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
    class func getSucursalesById(_ id:String, completion:@escaping (_ resultArray: Sucursales?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getSucursalesById + id, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let sucursalesObject = Sucursales(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(sucursalesObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
    class func putSucursales(_ id: String, parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postSucursales + "/" + id)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func putPublicacion(_ id: String, parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postPublicacion + "/" + id)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func putImagenPublicacion(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postImagenesPublicacion)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func getPublicacionesByUsuario(_ id:String, completion:@escaping (_ resultArray: Publicaciones?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getPublicacionesByUsuario + id, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let publicacionesObject = Publicaciones(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(publicacionesObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
    class func putImagenEmpresa(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postImagenEmpresa)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func postImagenEmpresa(_ parametros:[String: Any], completion:@escaping (_ error: NSError?)->()){
        
        var request = URLRequest(url: URL(string:Constants.URL.base + Constants.URL.postImagenEmpresa)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametros)
        
        Alamofire.request(request).responseJSON
            { (response:DataResponse<Any>) in
                if let responseStatus = (response.response?.statusCode) {
                    switch responseStatus {
                    case 200 :
                        completion(nil)
                    default :
                        return
                    }
                }
        }
    }
    
    class func getPaquetes(_ completion:@escaping (_ resultArray: Paquetes?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getPaquetes, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let paquetesObject = Paquetes(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(paquetesObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
    class func getImagenes(_ id:String, completion:@escaping (_ resultArray: Imagenes?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getSucursales + id, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let imagenesObject = Imagenes(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(imagenesObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
    class func getPermisos(_ id: String, completion:@escaping (_ resultArray: Permisos?, _ error: NSError?)->()){
        Alamofire.request(Constants.URL.base + Constants.URL.getPermisos + id, method: .get, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) -> Void in
                switch response.result{
                case.success(let value):
                    let json = JSON(value)
                    let permisosObject = Permisos(json: json)
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(permisosObject, nil)
                    })
                case .failure(let error):
                    return
                }
            })
    }
    
}
