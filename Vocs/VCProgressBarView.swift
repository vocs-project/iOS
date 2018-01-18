//
//  VCViewProgressBar.swift
//  Vocs
//
//  Created by Mathis Delaunay on 17/01/2018.
//  Copyright © 2018 Wathis. All rights reserved.
//

import UIKit

class VCProgressBarView : UIView {

    var orangeView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 250, g: 190, b: 115)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var redView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 250, g: 111, b: 117)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var greenView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 188, b: 158)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupViews(ratioGreen : CGFloat, ratioOrange : CGFloat, ratioRed : CGFloat) {
        let progressBarFrame = self.frame.width
        let widthGreen  = progressBarFrame * ratioGreen
        let widthOrange = progressBarFrame * ratioOrange
        let widthRed    = progressBarFrame * ratioRed
        self.removeSubviews()
        self.addSubviews([greenView,orangeView,redView])
        
        self.greenView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        let widthConstrGreen = self.greenView.widthAnchor.constraint(equalToConstant: 0)
        self.greenView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.greenView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        widthConstrGreen.isActive = true
        
        let widthConstrOrange = self.orangeView.widthAnchor.constraint(equalToConstant: 0)
        self.orangeView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        self.orangeView.leftAnchor.constraint(equalTo: self.greenView.rightAnchor).isActive = true
        self.orangeView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        widthConstrOrange.isActive = true
        
        let widthConstrRed = self.redView.widthAnchor.constraint(equalToConstant: 0)
        self.redView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        self.redView.leftAnchor.constraint(equalTo: self.orangeView.rightAnchor).isActive = true
        self.redView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        widthConstrRed.isActive = true
        
        widthConstrGreen.constant = widthGreen
        widthConstrOrange.constant = widthOrange
        widthConstrRed.constant = widthRed
        
        UIView.animate(withDuration: 1) {
            self.greenView.layoutIfNeeded()
            self.orangeView.layoutIfNeeded()
            self.redView.layoutIfNeeded()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


