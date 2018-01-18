//
//  MotCell.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCMotCell: UITableViewCell {
    
    var labelListe : UILabel = {
        
        let label = UILabel()
        label.text = "Overflow"
        label.font = UIFont(name: "Helvetica-Light", size: 15)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pastilleIcon : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "PastilleRouge")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let volumeIcon : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "volume")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x95989A)
        view.alpha = 0.5
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        setupViews()
    }
    
    func setText(text : String) {
        labelListe.text = text
    }
    
    func setColor(color : VCColorWord) {
        switch color {
        case .red:
            self.pastilleIcon.image = #imageLiteral(resourceName: "PastilleRouge")
            break
        case .green:
            self.pastilleIcon.image = #imageLiteral(resourceName: "PastilleVerte")
            break
        case .orange:
            self.pastilleIcon.image = #imageLiteral(resourceName: "PastilleOrange")
            break
        }
    }
    
    func setupViews() {
        
        self.addSubview(labelListe)
        
        labelListe.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelListe.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        labelListe.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        labelListe.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        self.addSubview(separatorLine)
        
        separatorLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant : 1).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier : 9/10).isActive = true
        
        self.addSubview(volumeIcon)
        
        volumeIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        volumeIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        volumeIcon.widthAnchor.constraint(equalToConstant: 15).isActive = true
        volumeIcon.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.addSubview(pastilleIcon)
        
        pastilleIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pastilleIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        pastilleIcon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        pastilleIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum VCColorWord {
    
    case red
    case green
    case orange
    
    
}
