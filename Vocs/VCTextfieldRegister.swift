//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 15/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCTextfieldInformations : UIView {
    
    let viewContainer = VCViewConnecton()
    let textField = UITextField()
    
    let imageMore : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "More")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func setupTextfield() {
        setupViews()
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        textField.textColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
        self.viewContainer.layer.cornerRadius = 15
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextfield()
    }
    
    convenience init(placeholder : String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.textField.placeholder = placeholder
    }
    
    func setupViews() {
        self.addSubview(viewContainer)
        viewContainer.addSubview(imageMore)
        textField.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(textField)
        
        NSLayoutConstraint.activate([
            viewContainer.widthAnchor.constraint(equalTo: self.widthAnchor),
            viewContainer.heightAnchor.constraint(equalTo: self.heightAnchor),
            viewContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            viewContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            textField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier : 9/10),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor),
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            imageMore.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageMore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            imageMore.widthAnchor.constraint(equalToConstant: 15),
            imageMore.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
