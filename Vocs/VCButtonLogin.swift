//
//  VCTextfieldLogin.swift
//  
//
//  Created by Mathis Delaunay on 14/09/2017.
//
//

import UIKit

class VCButtonLogin : UIButton {
    
    var text : String? {
        didSet {
            self.setAttributedTitle(NSAttributedString(string: text!, attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Light",size : 20 ) as Any, NSAttributedStringKey.foregroundColor : UIColor.black as Any]), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.layer.opacity = 0.50
        self.setAttributedTitle(NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Light",size : 20 ) as Any, NSAttributedStringKey.foregroundColor : UIColor.black as Any]), for: .normal)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
