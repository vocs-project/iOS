//
//  VCHeaderNoClasseCollectionReusableView.swift
//  Vocs
//
//  Created by Mathis Delaunay on 29/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

import UIKit

class VCHeaderNoClasseCollectionReusableView: UICollectionReusableView {
    
    var labelTitle : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textColor = UIColor(rgb: 0x6D6E71)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vous n'avez pas de classe"
        return label
    }()
    
    var imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "rejoindreClasse")
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(labelTitle)
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            labelTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),
            labelTitle.heightAnchor.constraint(equalToConstant: 40),
            labelTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            
            imageView.topAnchor.constraint(equalTo: self.labelTitle.bottomAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier : 7/10),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
