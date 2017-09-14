//
//  File2.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit


class VCScore : UIView {
    
    var imageLine : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Line")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var score : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 40)
        return label
    }()
    
    var maximum : UILabel = {
        let label = UILabel()
        label.text = "5"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 40)
        return label
    }()
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(score)
        score.topAnchor.constraint(equalTo: self.topAnchor,constant : 5).isActive = true
        score.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        score.heightAnchor.constraint(equalToConstant: 40).isActive = true
        score.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(maximum)
        maximum.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant : -5).isActive = true
        maximum.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        maximum.heightAnchor.constraint(equalToConstant: 40).isActive = true
        maximum.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(imageLine)
        
        imageLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageLine.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageLine.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageLine.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
