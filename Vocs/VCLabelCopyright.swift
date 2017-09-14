//
//  VCLabelMenu.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCLabelCopyright : UILabel {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.font = UIFont(name:  "Helvetica Neue", size: 15)
        self.text = "@Copyright Vocs 2017"
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
