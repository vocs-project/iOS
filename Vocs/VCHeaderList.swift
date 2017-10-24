//
//  VCHeaderList.swift
//  Vocs
//
//  Created by Mathis Delaunay on 16/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//


import UIKit

class VCHeaderListe : UIView {
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 149, g: 152, b: 154)
        return view
    }()
    
    var titleText :  String? {
        didSet {
            self.labelListe.text = titleText
            self.updateSize()
        }
    }
    
    let labelListe : UILabel = {
        let label = UILabel()
        label.text = "Personnelles"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textColor = UIColor(rgb: 0x4A4A4A)
        label.textAlignment = .center
        return label
    }() 
    
    init(text : String ){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.labelListe.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    
    func updateSize() {
        let numberOfCharacters = (self.labelListe.text?.characters.count)! * 10
        widthConstraint?.isActive = false
        widthConstraint?.constant = CGFloat(numberOfCharacters)
        widthConstraint?.isActive = true
        self.updateConstraintsIfNeeded()
    }
    
    var widthConstraint : NSLayoutConstraint?
    
    func setupViews() {
        self.backgroundColor = .white
        self.addSubview(separatorLine)
        
        separatorLine.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(labelListe)
        
        labelListe.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelListe.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        let numberOfCharacters = (self.labelListe.text?.characters.count)! * 11
        widthConstraint = labelListe.widthAnchor.constraint(equalToConstant : CGFloat(numberOfCharacters) )
        widthConstraint?.isActive = true
        labelListe.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

