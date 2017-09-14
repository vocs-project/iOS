//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCHeaderListe : UIView {
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x95989A)
        return view
    }()
    
    let labelListe : UILabel = {
        let label = UILabel()
        label.text = "Personnelles"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textColor = UIColor(rgb: 0x4A4A4A)
        label.textAlignment = .center
        return label
    }()
    
    init (text : String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        labelListe.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    func setupViews() {
        
        self.addSubview(separatorLine)
        
        separatorLine.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(labelListe)
        
        labelListe.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelListe.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        let numberOfCharacters = (self.labelListe.text?.characters.count)! * 10
        labelListe.widthAnchor.constraint(equalToConstant : CGFloat(numberOfCharacters) ).isActive = true
        labelListe.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
