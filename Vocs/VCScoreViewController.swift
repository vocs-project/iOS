//
//  ScoreViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCScoreViewController: UIViewController {

    let myScore = VCScore()
    let buttonLeave = VCButtonExercice("Quitter", color: UIColor(rgb: 0x1ABC9C))
    let labelCommentOfTheScore = VCLabelMenu(text: "Bien joué !",size: 35)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        buttonLeave.addTarget(self, action: #selector(handleLeave), for: .touchUpInside)
        setupViews()
        self.navigationItem.title = "Traduction"
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        loadScore()
    }
    
    //Gerer l'affichage du score à l'écran
    
    func loadScore() {
        if let score = myScore.score.text, let max = myScore.maximum.text {
            let ratioScore = Double(score)! / Double(max)!
            if ratioScore > 0.5 && ratioScore != 1{
                labelCommentOfTheScore.text = "Bien joué !"
            } else if ratioScore == 1{
                labelCommentOfTheScore.text = "Parfait !"
            } else if ratioScore <= 0.5 && ratioScore != 0{
                labelCommentOfTheScore.text = "Presque !"
            } else {
                labelCommentOfTheScore.text = "Dommage !"
            }
        } else {
            labelCommentOfTheScore.text = ""
        }
    }
    
    @objc func handleLeave() {
        let controller = TabBarController()
        controller.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        present(controller, animated: true, completion: nil)
    }
    
    func setupViews() {
        self.view.addSubview(myScore)
        
        myScore.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myScore.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant : -50).isActive = true
        myScore.widthAnchor.constraint(equalToConstant : 100).isActive = true
        myScore.heightAnchor.constraint(equalToConstant : 100).isActive = true
        
        self.view.addSubview(labelCommentOfTheScore)
        
        labelCommentOfTheScore.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        labelCommentOfTheScore.bottomAnchor.constraint(equalTo: myScore.topAnchor,constant : -50).isActive = true
        labelCommentOfTheScore.widthAnchor.constraint(equalTo : self.view.widthAnchor).isActive = true
        labelCommentOfTheScore.heightAnchor.constraint(equalToConstant : 50).isActive = true
        
        self.view.addSubview(buttonLeave)
        buttonLeave.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : 100).isActive = true
        buttonLeave.widthAnchor.constraint(equalToConstant : 200).isActive = true
        buttonLeave.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buttonLeave.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
