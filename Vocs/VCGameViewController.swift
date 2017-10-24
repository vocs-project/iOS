//
//  VCGameViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 20/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCGameViewController: UIViewController {
    
    var mots : [ListMot] = []
    var list : List?
    var compteur = 0
    let NBR_MOTS_MAX = 10
    var nbrReussi = 0
    var motActuelIndex = 0
    
    var francaisOuAnglais = true
    
    func randomLanguage() {
        francaisOuAnglais = (arc4random_uniform(2) == 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func giveAWordPlace() {
        motActuelIndex = Int(arc4random_uniform(UInt32(self.mots.count)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finir() {
        let controller = ScoreViewController()
        controller.myScore.score.text = String(nbrReussi)
        controller.myScore.maximum.text = String(compteur)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

enum VCGameMode {
    case traduction
    case qcm
}
