//
//  Traduction.swift
//  Vocs
//
//  Created by Mathis Delaunay on 05/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

class ListMot {
    
    var id : Int?
    var word : Mot?
    var trad : Mot?
    var statIdWord : Int?
    var level : Int = -1
    var goodRepetitions : Int = -1
    var badRepetitions : Int = -1

    init(id : Int,word : Mot, trad : Mot) {
        self.word = word
        self.id = id
        self.trad = trad
    }
    
    init(id : Int,word : Mot, trad : Mot,statIdWord : Int,level : Int, goodRepetitions : Int, badRepetitions : Int) {
        self.word = word
        self.id = id
        self.trad = trad
        self.statIdWord = statIdWord
        self.level = level
        self.goodRepetitions = goodRepetitions
        self.badRepetitions = badRepetitions
    }
    
    
    init(word : Mot, trad : Mot) {
        self.word = word
        self.trad = trad
    }
    
    //Permet de mettre a jour les statistiques
    fileprivate func updateStats() {
        guard let idStat = statIdWord else {
            return
        }
        let parameters = [
            "level" : level,
            "goodRepetition" : goodRepetitions,
            "badRepetition" : badRepetitions
        ]
        Alamofire.request("\(Auth.URL_API)/wordTradUsers/\(idStat)", method: .patch, parameters: parameters)
    }
    
    //Permet de mettre a jour le compteur de reussite des stats de l'utilisateur
    func userSucceed() {
        if level < 5 {
            level += 1
        }
        goodRepetitions += 1
        if goodRepetitions >= 2 {
            badRepetitions = 0
        }
        updateStats()
    }
    
    //Permet de mettre a jour le compteur d'echec des stats de l'utilisateur
    func userFailed() {
        if level > 0 {
            level -= 1
        }
        goodRepetitions = 0
        badRepetitions += 1
        updateStats()
    }
    
    
    //permet de donner le niveau de maitrise de couleur
    func getLevelColor() -> VCColorWord? {
        if level >= 0 {
            if level < 2 {
                return .red
            } else if level < 4 {
                return .orange
            } else {
                return .green
            }
        } else {
            return nil
        }
    }
    
    func copie() -> ListMot? {
        guard let id = self.id, let word = word, let trad = trad else {
            return nil
        }
        return ListMot(id: id, word: word, trad: trad)
    }
}
