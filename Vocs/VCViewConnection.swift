//
//  VCViewConnection.swift
//  Vocs
//
//  Created by Mathis Delaunay on 16/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCViewConnecton : UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.opacity = 0.58
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.2
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

