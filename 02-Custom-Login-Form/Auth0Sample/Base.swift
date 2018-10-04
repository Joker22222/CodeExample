//
//  File.swift
//  GuiApp
//
//  Created by Fernando Garay on 19/05/2018.
//  Copyright © 2018 Auth0. All rights reserved.
//

import Foundation
import UIKit

class Base : UIViewController{
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startAnimating(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    
    func stopAnimating(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

