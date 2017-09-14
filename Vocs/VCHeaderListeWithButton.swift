
//
//  HeaderListe.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCHeaderListeWithButton: VCHeaderListe {
    let buttonAjouter : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "Ajouter"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        return button
    }()
    
    override init (text : String) {
        super.init(text : text)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.labelListe.text = text
        setupButton()
    }
    
    func setupButton() {
        self.addSubview(buttonAjouter)
        
        buttonAjouter.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonAjouter.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonAjouter.widthAnchor.constraint(equalToConstant : 30).isActive = true
        buttonAjouter.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



