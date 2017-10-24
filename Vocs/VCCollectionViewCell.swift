//
//  VCCollectionViewCell.swift
//  Vocs
//
//  Created by Mathis Delaunay on 08/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCCollectionViewCell: UICollectionViewCell {
    
    var label : UILabel = {
        let label = UILabel()
        label.text = "label"
        label.font = UIFont(name: "Helvetica-Light", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x95989A)
        view.alpha = 0.5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.white
        setupViews()
        
    }
    
    func setText(text : String) {
        label.text = text
    }
    
    func setupViews() {
        
        self.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        self.addSubview(separatorLine)
        
        separatorLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant : 1).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
