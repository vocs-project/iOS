//
//  VCHeaderClasseView.swift
//  Vocs
//
//  Created by Mathis Delaunay on 31/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCHeaderClasseView: UICollectionReusableView {
    
    var labelTitle : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 30)
        label.textColor = UIColor(rgb: 0x6D6E71)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nom de classe"
        return label
    }()
    
    var labelSubtitle : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0 membress - 2017"
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x6D6E71)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(labelTitle)
        self.addSubview(labelSubtitle)
        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            labelTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),
            labelTitle.heightAnchor.constraint(equalToConstant: 40),
            labelTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            
            labelSubtitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            labelSubtitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0),
            labelSubtitle.heightAnchor.constraint(equalToConstant: 20),
            labelSubtitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
