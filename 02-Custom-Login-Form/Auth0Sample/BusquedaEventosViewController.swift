//
//  BusquedaEventosViewController.swift
//  GuiApp
//
//  Created by Fernando Garay on 03/07/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class BusquedaEventosViewController: Base, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, EventosBusquedaViewModelDelegate {
 
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfTipoEvento: UITextField!
    @IBOutlet weak var btnFechaDeEvento: UIButton!
    @IBOutlet weak var btnBuscarEvento: UIButton!
    @IBOutlet weak var dpkrDatePicker: UIDatePicker!
    @IBOutlet weak var btnOk: UIButton!
    
    var date: String?
    var categoria: String?
    var viewModel : EventosViewModel?
    let categoriaPicker = UIPickerView()
    var vcDetalle : DetalleDelEventoViewController?
    var base: BaseController = BaseController()

    override func viewDidLoad() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        dpkrDatePicker.isHidden = true
        btnOk.isHidden = true
        dpkrDatePicker.backgroundColor = UIColor(red: 146/255.0, green: 53/255.0, blue: 198/255.0, alpha: 1.00)
        dpkrDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        super.viewDidLoad()
        viewModel = EventosViewModel()
        viewModel?.delegate = self
        viewModel?.getCategoriaEventos()
        categoriaPicker.delegate = self
        tfTipoEvento.inputView = categoriaPicker
        vcDetalle = DetalleDelEventoViewController()
        btnEmpresas.addTarget(self, action: #selector(self.menu), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        date = "-1"
        categoria = "-1"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func menu(){
        base.showActionSheet()
    }
    
    @IBAction func tapVolver(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBuscarEvento(_ sender: Any) {
        viewModel?.getEventos(fecha: date!, tipo: categoria!)
    }
    
    @IBAction func tapFechaEvento(_ sender: Any) {
        dpkrDatePicker.isHidden = false
        btnOk.isHidden = false
    }
    
    @IBAction func tapOK(_ sender: Any) {
        dpkrDatePicker.isHidden = true
        btnOk.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.string(from: dpkrDatePicker.date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel?.listaEventos == nil {
            return 0
        }else{
            return (viewModel?.listaEventos?.count)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusquedaEventos", for: indexPath) as! BusquedaEventosTableViewCell
        cell.lblTitulo.text = viewModel?.eventos?.eventos[indexPath.row].nombre
        cell.lblFecha.text = formatDate(dateString: (viewModel?.eventos?.eventos[indexPath.row].fechaInicio)!)
        cell.lblLugar.text = viewModel?.eventos?.eventos[indexPath.row].ubicacion
        cell.lblHorario.text = viewModel?.eventos?.eventos[indexPath.row].horaInicio
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetalleEvento") as! DetalleDelEventoViewController
        vc.setEvento(evento: (viewModel?.eventos?.eventos[indexPath.row])!)
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    func finishGetingMisEventos() {
        tableView.reloadData()
    }
    
    func finishGetingCategorias() {
    }
    
    func finishSendingEventos() {
        
    }
    func finishSendingImagenEvento() {
        
    }
    
    func formatDate (dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "es_AR")
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: dateObj!).uppercased()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (viewModel?.categoriaEventos?.categoriaEventos.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.categoriaEventos?.categoriaEventos[row].tipo
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoria = viewModel?.categoriaEventos?.categoriaEventos[row].id
        self.view.endEditing(true)
    }
}
