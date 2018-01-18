//
//  VCButtonForgottenPassword.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit


class VCButtonForgottenPassword : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setAttributedTitle(NSAttributedString(string: "Mot de passe oublié ?", attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Light", size: 15) as Any, NSAttributedStringKey.foregroundColor : UIColor.white as Any]), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
