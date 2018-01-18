//
//  Test2.swift
//  Vocs
//
//  Created by Mathis Delaunay on 08/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit


class VCHeaderWithBarCollectionViewCell: VCHeaderWithTitlesCollectionViewCell {
    
    var titleOfBar : String? {
        didSet {
            self.bar.labelListe.text = titleOfBar
        }
    }
    
    let bar = VCHeaderListe(text: "Example")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(bar)
        NSLayoutConstraint.activate([
            bar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            bar.heightAnchor.constraint(equalToConstant: 20),
            bar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier : 90/100),
            bar.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ])
    }
    
}



