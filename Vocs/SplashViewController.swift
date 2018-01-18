//
//  SplashViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 02/06/2017.
//  Copyright © 2017 Wathis. All rights reserved.

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let animatonView = LOTAnimationView(name: "spinner")
        animatonView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(animatonView)
        animatonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        animatonView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        animatonView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        animatonView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        animatonView.loopAnimation = true
        animatonView.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFirstScreen()
    }
    
    func loadFirstScreen() {
        Auth().loadUserConnected { (user) in
            if user != nil {
                if (user!.isProfessor()){
                    self.goToVocs(isProfessor: true)
                } else {
                    self.goToVocs(isProfessor: false)
                }
            } else {
                self.goToVocs(isProfessor: false)
            }
        }
    }
    
    func goToVocs(isProfessor: Bool) {
        if Auth().userIsConnected()  {
            let controller = TabBarController()
            controller.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            present(controller, animated: true, completion: nil)
            return
        } else {
            let controller = VCConnectionViewController()
            controller.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            present(controller, animated: true, completion: nil)
        }
    }

    
}
