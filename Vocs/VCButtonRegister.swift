//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCButtonRegister : UIButton {

    var text : String? {
        didSet {
            self.setAttributedTitle(NSAttributedString(string: text!, attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light",size : 20 ) as Any, NSForegroundColorAttributeName : UIColor.white as Any]), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .black
        self.layer.cornerRadius = 15
        self.layer.opacity = 0.50
        self.setAttributedTitle(NSAttributedString(string: "Register", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light",size : 20 ) as Any, NSForegroundColorAttributeName : UIColor.white as Any]), for: .normal)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
