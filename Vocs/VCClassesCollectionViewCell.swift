//
//  ClassesCollectionViewCell.swift
//  Vocs
//
//  Created by Mathis Delaunay on 07/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCClassesCollectionViewCell: VCCollectionViewCell {
    
    let imageMore : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "More")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    let headerGererMaClasse = VCHeaderListe(text: "Gérer ma classe")
    let headerListes = VCHeaderListeWithButton(text: "Listes de classe")
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.white
        setupImage()
        
    }
    
    func showSectionGerer() {
        headerListes.isHidden = true
        headerListes.isUserInteractionEnabled = false
        
        headerGererMaClasse.isHidden = false
        headerGererMaClasse.isUserInteractionEnabled = true
        
        self.separatorLine.isHidden = true
        self.label.isHidden = true
        self.label.isEnabled = false
    }
    
    func showSectionListes() {
        headerListes.isHidden = false
        headerListes.isUserInteractionEnabled = true
        
        headerGererMaClasse.isHidden = true
        headerGererMaClasse.isUserInteractionEnabled = false
        
        self.separatorLine.isHidden = true
        self.label.isHidden = true
        self.label.isEnabled = false
    }
    
    func showNormalCell() {
        headerListes.isHidden = true
        headerListes.isUserInteractionEnabled = false
        
        headerGererMaClasse.isHidden = true
        headerGererMaClasse.isUserInteractionEnabled = false
        
        self.separatorLine.isHidden = false
        self.label.isHidden = false
        self.label.isEnabled = true
    }
    
    func setupImage() {
        self.addSubview(imageMore)
        self.addSubview(headerListes)
        self.addSubview(headerGererMaClasse)
        
        headerListes.isHidden = true
        headerListes.isUserInteractionEnabled = false
        
        headerGererMaClasse.isHidden = true
        headerGererMaClasse.isUserInteractionEnabled = false
        
        headerGererMaClasse.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        headerGererMaClasse.heightAnchor.constraint(equalToConstant: 20).isActive = true
        headerGererMaClasse.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerGererMaClasse.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        headerListes.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        headerListes.heightAnchor.constraint(equalToConstant: 20).isActive = true
        headerListes.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerListes.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        imageMore.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageMore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        imageMore.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageMore.heightAnchor.constraint(equalToConstant: 15).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
