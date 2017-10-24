//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCHeaderListeCell : UITableViewHeaderFooterView {
    
    var textHeader : String? {
        didSet {
            self.headerView.titleText = textHeader
        }
    }
    
    let headerView = VCHeaderListe(text: "Example")


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(headerView)
        NSLayoutConstraint.activate([
            self.headerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.headerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.headerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
