//
//  BusquedaEventosTableViewCell.swift
//  GuiApp
//
//  Created by Fernando Garay on 03/07/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class BusquedaEventosTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFecha: UILabel!
    
    @IBOutlet weak var lblHorario: UILabel!
    @IBOutlet weak var lblLugar: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
