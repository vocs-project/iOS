//
//  HeaderClasseTeacherCollectionReusableView.swift
//  Vocs
//
//  Created by Mathis Delaunay on 07/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCFooterClasseStudentCollectionReusableView : UICollectionReusableView {
    
    var titleButton : String! {
        didSet {
            self.quitButton.setAttributedTitle(NSAttributedString(string: titleButton, attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Light", size: 18) as Any, NSAttributedStringKey.foregroundColor : UIColor.white]), for: .normal)
        }
    }
    
    let quitButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(rgb: 0xF27171)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Titre", attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Light", size: 18) as Any, NSAttributedStringKey.foregroundColor : UIColor.white]), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(quitButton)
        
        NSLayoutConstraint.activate( [
            quitButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            quitButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            quitButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 81/100),
            quitButton.heightAnchor.constraint(equalToConstant: 45)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
