//
//  VCLoadingControlle.swift
//  Vocs
//
//  Created by Mathis Delaunay on 27/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Lottie


class VCLoadingController : UIViewController {

    var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: 0x656565)
        view.layer.opacity = 0.8
        view.layer.cornerRadius = 20
        return view
    }()
    
    
    var animationView : LOTAnimationView = {
        let animationView = LOTAnimationView(name: "spinner")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopAnimation = true
        return animationView
    }()
    
    //permet de recouvrir la vue actuelle
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.isOpaque = false
        self.view.layer.opacity = 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
        _ = PrononcationMots.loadInstance()
    }
    
    func setupViews() {
        self.view.addSubview(contentView)
        self.contentView.addSubview(animationView)
        
        contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant : 110).isActive = true
        contentView.heightAnchor.constraint(equalToConstant : 110).isActive = true
        
        animationView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    
}


