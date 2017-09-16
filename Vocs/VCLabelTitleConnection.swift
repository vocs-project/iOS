//
//  VCLabelTitleConnection.swift
//  Vocs
//
//  Created by Mathis Delaunay on 16/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCLabelTitleConnection : UILabel {
    
    init(text : String, size : Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        settings(text: text, size: size)
    }
    
    func settings(text : String, size : Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "PingFangHK-Thin", size: CGFloat(size))
        self.text = text
        self.textAlignment = .center
        self.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
