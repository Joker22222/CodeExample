//
//  Constants.swift
//  GuiApp
//
//  Created by Fernando  on 2/26/18.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation

struct Constants {
    
    struct URL {
        static let base = "https://guiappworldwide.com/admin/api/"
        //static let base = "http://192.168.1.24/api-guiapp/"
        static let eventosLista = "evento/lista"
        static let eventosBusqueda = "evento/filtered"
        static let eventosCategorias = "eventotipo"
        static let postEventos = "evento"
        static let postImagenEventos = "evento/imagen"
        static let publicacionesLista = "publicacion/regulares"
        static let publicacionesDestLista = "publicacion/destacadas"
        static let resultadoDeBusquedaParam = "empresa/b"
        static let resultadoDeBusquedaCat = "empresa/c2"
        static let publicidad = "publicidad/2"
        static let postEmpresas = "empresa"
        static let postUsuarios = "cuenta"
        static let getEmpresas = "empresa/xcuenta/"
        static let getEmpresasById = "empresa/byid/"
        static let postSucursales = "sucursal"
        static let getSucursales = "sucursal/porempresa/"
        static let getSucursalesById = "sucursal/byid/"
        static let postPublicacion = "/publicacion"
        static let postImagenesPublicacion = "/publicacion/imagen"
        static let getPublicacionesByUsuario = "/publicacion/idcuenta/"
        static let postImagenEmpresa = "/empresa/imagen"
        static let getPaquetes = "/paquete/l"
        static let getImagenes = "/imagen/porempresa/"
        static let getPermisos = "/funcion/getbyidcuenta/"
        static let getImagenesGaleria = "imagen/porempresa/"
        static let postImagenesGaleria = "imagen"
        static let putImagenesGaleria = "imagen/"
    }
    
    struct EventosCategoria {
        static let id = "id"
        static let tipo = "tipo"
    }
    
    struct Publicaciones {
        static let id = "id"
        static let titulo = "titulo"
        static let imagen = "imagen"
        static let descripcion = "descripcion"
        static let idEmpresa = "idempresa"
        static let razonSocial = "razonsocial"
        static let destacada = "destacada"
        static let fechaModificacion = "fecmodificacion"
        static let dirty = "dirty"
    }
   
    struct Eventos {
        static let id = "id"
        static let nombre = "nombre"
        static let descripcion = "descripcion"
        static let imagen = "imagen"
        static let idTipo = "idtipo"
        static let tipo = "tipo"
        static let ubicacion = "ubicacion"
        static let fechaInicio = "fecinicio"
        static let fechaFin = "fecfin"
        static let idEmpresa = "idempresa"
        static let razonSocial = "razonSocial"
        static let horaInicio = "horainicio"
        static let horaFin = "horafin"
        static let idCuenta = "idcuenta"
    }
    
    struct ResultadosDeBusqueda {
        static let id = "id"
        static let idEmpresa = "idempresa"
        static let razonSocial = "razonsocial"
        static let estado = "estado"
        static let idCategoria = "idcategoria"
        static let direccion = "direccion"
        static let idPais = "idpais"
        static let idProvincia = "idprovincia"
        static let idLocalidad = "idlocalidad"
        static let telefono = "telefono"
        static let delivery = "delivery"
        static let veinticuatrohs = "veinticuatrohs"
        static let diasHorarios = "diashorarios"
        static let dirty = "dirty"
        static let palabrasClave = "palabrasClave"
        static let distancia = "distancia"
    }
    
    struct Publicidad {
        static let id = "id"
        static let idSponsor = "idsponsor"
        static let fecInicio = "fecinicio"
        static let fecFin = "fecfin"
        static let imagen = "imagen"
        static let url = "url"
    }
    
    struct Imagen {
        static let id = "id"
        static let idEmpresa = "idempresa"
        static let idPublicacion = "idpublicacion"
        static let idEvento = "idevento"
        static let imagen = "imagen"
        static let url = "url"
    }
    
    struct Funcion {
        static let id = "id"
        static let funcion = "funcion"
        static let cantidad = "cantidad"
        static let idModulo = "idmodulo"
        static let modulo = "modulo"
        static let limAlcanzado = "limalcanzado"
    }
    
    struct Paquete {
        static let id = "id"
        static let imagen = "imagen"
        static let nombre = "nombre"
        static let descripcion = "descripcion"
        static let costo = "costo"
        static let duracion = "duracion"
        static let logo = "logo"
        static let activo = "activo"
    }
    
    struct Empresa {
        static let id = "id"
        static let razonSocial = "razonsocial"
        static let cuit = "cuit"
        static let medioDePago = "mediodepago"
        static let estado = "estado"
        static let logo = "logo"
        static let facebook = "facebook"
        static let instagram = "instagram"
        static let twitter = "twitter"
        static let palabrasclave = "palabrasclave"
        static let dirty = "dirty"
        static let web = "web"
        static let descripcion = "descripcion"
        static let idCuenta = "idcuenta"
    }
    
    struct Sucursal {
        static let id = "id"
        static let idEmpresa = "idempresa"
        static let razonSocial = "razonsocial"
        static let estado = "estado"
        static let direccion = "direccion"
        static let idPais = "idpais"
        static let idProvincia = "idprovincia"
        static let ideLocalidad = "idlocalidad"
        static let telefono = "telefono"
        static let delivary = "delivery"
        static let veinticuatroHs = "veinticuatrohs"
        static let diasHorarios = "diashorarios"
        static let dirty = "dirty"
        static let palabrasCalve = "palabrasclave"
        static let latitud = "latitud"
        static let longitud = "longitud"
    }
}
