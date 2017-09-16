//
//  VCLabelConnection.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCLabelConnection: UILabel {
    
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
        self.font = UIFont(name: "HelveticaNeue-Light", size: CGFloat(size))
        self.text = text
        self.textAlignment = .left
        self.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
