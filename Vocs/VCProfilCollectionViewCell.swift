//
//  ProfilCollectionViewCell.swift
//  Vocs
//
//  Created by Mathis Delaunay on 08/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCProfilCollectionViewCell: VCCollectionViewCell {
    
    let imageEdit : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "edit")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.white
        setupImage()
        
    }
    
    func setupImage() {
        self.addSubview(imageEdit)
        
        imageEdit.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageEdit.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        imageEdit.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageEdit.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
