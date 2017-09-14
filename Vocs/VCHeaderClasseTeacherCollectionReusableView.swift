//
//  test.swift
//  Vocs
//
//  Created by Mathis Delaunay on 08/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCHeaderClasseTeacherCollectionReusableView: UICollectionReusableView {
    
    let headerTitleClasse = VCHeaderListe(text: "Mes classes")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(headerTitleClasse)
        NSLayoutConstraint.activate([
            headerTitleClasse.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            headerTitleClasse.heightAnchor.constraint(equalToConstant: 20),
            headerTitleClasse.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier : 90/100),
            headerTitleClasse.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
