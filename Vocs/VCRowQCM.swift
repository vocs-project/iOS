//
//  VCRowQCM.swift
//  Vocs
//
//  Created by Mathis Delaunay on 20/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCRowQCM : UIView {
    
    var isSelected : Bool = true {
        didSet {
            if isSelected {
                buttonValidate.setSelected()
            } else {
                buttonValidate.setUnselected()
            }
        }
    }
    
    let buttonValidate = VCButtonValidate()
    let wordLabel = VCLabelMot(text: "Word")
    
    var word : String = "" {
        didSet {
            self.wordLabel.text = word
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .left
        self.isUserInteractionEnabled = true
        self.buttonValidate.isUserInteractionEnabled = true
        setupViews()
    }
    
    func setupViews() {
        self.addSubviews([wordLabel,buttonValidate])
        
        NSLayoutConstraint.activate([
            self.wordLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.wordLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.wordLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 85/100),
            self.wordLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            self.buttonValidate.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.buttonValidate.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.buttonValidate.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 15/100),
            self.buttonValidate.heightAnchor.constraint(equalTo: self.buttonValidate.widthAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Fatal error in VCRowQCM")
    }
    
}

