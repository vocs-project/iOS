//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCLabelMenu: UILabel {
    
    init(text : String, size : Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        settings(text: text, size: size)
        
    }
    init(text : String, size : Int, textAlignement : NSTextAlignment) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        settings(text : text,size : size)
        self.textAlignment = textAlignment
    }
    
    func settings(text : String, size : Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "HelveticaNeue", size: CGFloat(size))
        self.text = text
        self.textAlignment = .center
        self.textColor = UIColor(rgb: 0x4A4A4A)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
