//
//  VCHeaderMotCell.swift
//  Vocs
//
//  Created by Mathis Delaunay on 17/01/2018.
//  Copyright © 2018 Wathis. All rights reserved.
//

import UIKit

class VCHeaderMotCell : UITableViewCell {
    
    var labelListe : UILabel = {
        
        let label = UILabel()
        label.text = "Progression de la liste"
        label.font = UIFont(name: "Helvetica-Light", size: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var progressBar : VCProgressBarView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        progressBar = VCProgressBarView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    fileprivate func setupViews() {
        self.removeSubviews()
        self.addSubviews([labelListe,progressBar])
        
        NSLayoutConstraint.activate([
            labelListe.widthAnchor.constraint(equalTo: self.widthAnchor),
            labelListe.heightAnchor.constraint(equalTo: self.heightAnchor,multiplier : 2/3),
            labelListe.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant : -20),
            labelListe.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            progressBar.widthAnchor.constraint(equalTo: self.widthAnchor),
            progressBar.heightAnchor.constraint(equalTo: self.heightAnchor,multiplier : 1/3),
            progressBar.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant : 20),
            progressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    //Permet de changer les ratios des couleurs de la barre
    func changeProgressBar(ratioGreen: CGFloat, ratioOrange: CGFloat, ratioRed: CGFloat) {
        progressBar.setupViews(ratioGreen: ratioGreen, ratioOrange: ratioOrange, ratioRed: ratioRed)
    }
    
    func changeTitle(text : String) {
        self.labelListe.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
