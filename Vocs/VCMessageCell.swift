//
//  VCMessageCell.swift
//  Vocs
//
//  Created by Mathis Delaunay on 28/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCMessageCell: UITableViewCell {
    
    var contentLabel : UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum"
        label.font = UIFont(name: "Helvetica-Light", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    var objectLabel : UILabel = {
        let label = UILabel()
        label.text = "Object"
        label.font = UIFont(name: "Helvetica", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 149/255, green: 152/255, blue: 154/255, alpha: 0.5)
        view.alpha = 0.5
        return view
    }()
    
    let imageMore : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "More")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        setupViews()
    }
    
    //Changer le texte du contenu
    func setContentText(text : String) {
        contentLabel.text = text
    }
    
    //Changer l'objet
    func setObjectText(text : String) {
        objectLabel.text = text
    }
    
    func setupViews() {
        self.addSubview(imageMore)
        
        imageMore.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageMore.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        imageMore.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageMore.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.addSubview(objectLabel)
        
        objectLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        objectLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        objectLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant : 10).isActive = true
        objectLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 25/100).isActive = true
        
        self.addSubview(contentLabel)
        
        contentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: objectLabel.rightAnchor).isActive = true
        contentLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: self.imageMore.leftAnchor).isActive = true
        
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
