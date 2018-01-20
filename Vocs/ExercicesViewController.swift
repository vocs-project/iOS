//
//  GameViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import AVFoundation

class ExercicesViewController: UIViewController {
    
    var labelBienvenue = VCLabelMenu(text: "Bienvenue sur Vocs",size: 25)
    var boutonTraduction = VCButtonExercice("Traduction",color : UIColor(rgb: 0xEFA630))
    var buttonQCM = VCButtonExercice("QCM",color : UIColor(rgb: 0x1C7FBD))
    var buttonMatching = VCButtonExercice("Matching",color : UIColor(rgb: 0x1ABC9C))
    var buttonTimeAttack = VCButtonExercice("Time attack",color : UIColor(rgb: 0xF27171))
    var user : User?
    var group : Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Exercices"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Parametres"), style: .plain, target: self, action: #selector(handleParametres))
        buttonQCM.addTarget(self, action: #selector(handleQCM), for: .touchUpInside)
        boutonTraduction.addTarget(self, action: #selector(handleTraduction), for: .touchUpInside)
        buttonMatching.addTarget(self, action: #selector(handleMatching), for: .touchUpInside)
        buttonTimeAttack.addTarget(self, action: #selector(handleTimeAttack), for: .touchUpInside)
        setupViews()
        setupAnimations()
        Auth().loadUserConnected { (user) in
            self.user = user
            if user != nil {
                if !user!.isProfessor() {
                    self.loadClasse()
                }
            }
        }
    }
    
    //Charger la classe de l'élève
    func loadClasse() {
        self.user?.loadClasse(completion: { (group) in
            self.group = group
        })
    }
    
    //Create animations for buttons
    func setupAnimations() {
        let viewWidth = self.view.frame.width
        self.labelBienvenue.layer.opacity = 0
        self.buttonQCM.transform = CGAffineTransform(translationX: -viewWidth, y: 0)
        self.boutonTraduction.transform = CGAffineTransform(translationX: viewWidth, y: 0)
        self.buttonMatching.transform = CGAffineTransform(translationX: viewWidth, y: 0)
        self.buttonTimeAttack.transform = CGAffineTransform(translationX: -viewWidth, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.buttonQCM.transform = CGAffineTransform(translationX: 0, y: 0)
            self.boutonTraduction.transform = CGAffineTransform(translationX: 0, y: 0)
            self.buttonMatching.transform = CGAffineTransform(translationX: 0, y: 0)
            self.buttonTimeAttack.transform = CGAffineTransform(translationX: 0, y: 0)
            self.labelBienvenue.layer.opacity = 1
        }, completion: nil)
    }
    
    func setupViews() {
        self.view.addSubview(labelBienvenue)
        labelBienvenue.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        labelBienvenue.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        labelBienvenue.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelBienvenue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.view.addSubview(buttonQCM)
        buttonQCM.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -100).isActive = true
        buttonQCM.widthAnchor.constraint(equalToConstant : 200).isActive = true
        buttonQCM.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buttonQCM.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.view.addSubview(buttonMatching)
        buttonMatching.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -30).isActive = true
        buttonMatching.widthAnchor.constraint(equalToConstant : 200).isActive = true
        buttonMatching.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buttonMatching.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.view.addSubview(boutonTraduction)
        boutonTraduction.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 40).isActive = true
        boutonTraduction.widthAnchor.constraint(equalToConstant : 200).isActive = true
        boutonTraduction.heightAnchor.constraint(equalToConstant: 60).isActive = true
        boutonTraduction.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.view.addSubview(buttonTimeAttack)
        buttonTimeAttack.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 110).isActive = true
        buttonTimeAttack.widthAnchor.constraint(equalToConstant : 200).isActive = true
        buttonTimeAttack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buttonTimeAttack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func handleTraduction() {
        let controller = ChoisirListeViewController()
        controller.gameMode = .traduction
        controller.user = self.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleQCM() {
        let controller = ChoisirListeViewController()
        controller.gameMode = .qcm
        controller.user = self.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleMatching() {
        let controller = ChoisirListeViewController()
        controller.gameMode = .matching
        controller.user = self.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleTimeAttack() {
        let controller = ChoisirListeViewController()
        controller.gameMode = .timeAttack
        controller.user = self.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func handleParametres() {
        let profilController = ProfilViewController(collectionViewLayout: UICollectionViewFlowLayout())
        profilController.currentUser = user
        let navReglageController = UINavigationController(rootViewController: profilController)
        present(navReglageController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
