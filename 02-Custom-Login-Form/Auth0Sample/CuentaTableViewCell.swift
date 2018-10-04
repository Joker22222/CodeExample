//
//  CuentaTableViewCell.swift
//  GuiApp
//
//  Created by Fernando Garay on 17/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import UIKit

class CuentaTableViewCell: UITableViewCell {
    @IBOutlet weak var imgCuenta: UIImageView!
    @IBOutlet weak var lblDescripcion: UILabel!
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

