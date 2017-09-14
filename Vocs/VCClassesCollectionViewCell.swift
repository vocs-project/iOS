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
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.white
        setupImage()
        
    }
    
    func setupImage() {
        self.addSubview(imageMore)
        
        imageMore.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageMore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        imageMore.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageMore.heightAnchor.constraint(equalToConstant: 15).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
