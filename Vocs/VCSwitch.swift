//
//  VCSwitch.swift
//  Vocs
//
//  Created by Mathis Delaunay on 31/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCSwitchInCell: UISwitch {
    
    var indexPath : IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Erreur dans le switch")
    }
}
