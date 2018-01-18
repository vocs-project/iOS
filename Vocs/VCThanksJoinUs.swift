//
//  VCThanksJoinUS.swift
//  Vocs
//
//  Created by Mathis Delaunay on 17/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCThanksJoinUs : UIViewController {
    
    let labelThanks = VCLabelTitleConnection(text: "Merci de nous avoir rejoint", size: 45)
    let buttonNext = VCButtonLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "BackgroundConnexion"))
        buttonNext.text =  "Suivant"
        setBackgroundImage()
        buttonNext.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        setupViews()
    }
    
    @objc func handleNext() {
        present(TabBarController(), animated: true, completion: nil)
    }
    
    func setupViews() {
        self.view.addSubviews([labelThanks,buttonNext])
        labelThanks.numberOfLines = 2
        labelThanks.lineBreakMode =  .byWordWrapping
        NSLayoutConstraint.activate([
            buttonNext.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonNext.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 80),
            buttonNext.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            buttonNext.heightAnchor.constraint(equalToConstant: 45),
            
            labelThanks.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            labelThanks.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80),
            labelThanks.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            labelThanks.heightAnchor.constraint(equalToConstant: 200)
            ])
    }
    
}
