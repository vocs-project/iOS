//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCButtonExercice: UIButton {
    
    init(_ title : String, color : UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        self.backgroundColor = color
        self.layer.cornerRadius = 30
        self.setAttributedTitle(NSAttributedString(string: title, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium",size : 20 ) as Any, NSForegroundColorAttributeName : UIColor.white as Any]), for: .normal)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
