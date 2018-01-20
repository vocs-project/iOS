//
//  VCGameViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 20/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Foundation

class VCGameViewController: UIViewController {
    
    var mots : [ListMot] = []
    var list : List?
    var compteur = 0
    var NBR_MOTS_MAX = 10
    var nbrReussi = 0
    var motActuelIndex = 0
    
    // isFrenchToEnglish = true veut dire que l'on traduit des mot francais ( L'utilisateur ecrit donc en anglais )
    var isFrenchToEnglish = true
    
    func randomLanguage() {
        isFrenchToEnglish = (arc4random_uniform(2) == 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NBR_MOTS_MAX = Parametre.loadInstance().loadExcerciceSize()
        // Do any additional setup after loading the view.
    }
    
    func giveAWordPlace() {
        motActuelIndex = Int(arc4random_uniform(UInt32(self.mots.count)))
    }
    
    //Donne un mot non present dans le tableau des mots
    func giveDifferentWord(of words : [String], isLanguageFrench : Bool) -> String {
        var index = 0
        var contains : Bool
        var wordTest : String?
        repeat {
            index = Int(arc4random_uniform(UInt32(self.mots.count)))
            if isLanguageFrench {
                wordTest = self.mots[index].word?.content
            } else {
                wordTest = self.mots[index].trad?.content
            }
            guard let word = wordTest else {return ""}
            contains = words.contains(word)
        } while (contains)
        guard let word = wordTest else {return "nil"}
        return word
    }
    
    func findTraductionOf(word: String) {
        
    }
    
    //Permet de verfier si le mot (word) est bien la traduction attendue
    // isFrenchToEnglish = true veut dire que l'on traduit des mot francais ( ecrit donc en anglais )
    // La fonction ne renvoie rien mais utilise un callback : (estTraductionAttendue, estSynoyme, traductionAttendue)
    func verifierTraduction(wordTrad : ListMot, word : String,completion : (Bool, Bool, String?) -> Void) {
        //Le mot est mis aussi en minuscule
        let word = word.supprimerParentheseEtEspaces()
        var trads : [Mot] = []
        var optionalTrad : String?
        if (isFrenchToEnglish) {
            //On prend le trad ( Anglais ) pour voir si il est égal au mot word
            optionalTrad = wordTrad.trad?.content
            if wordTrad.word?.trads != nil {
                trads = wordTrad.word!.trads!
            }
        } else {
            optionalTrad = wordTrad.word?.content
            if wordTrad.trad?.trads != nil {
                trads = wordTrad.trad!.trads!
            }
        }
        guard let trad = optionalTrad else {
            completion(false,false,nil)
            return
        }
        if trad.supprimerParentheseEtEspaces().uppercased() == word.uppercased() {
            completion(true,false,nil)
            return
        } else {
            //On verifie quand même si ce n'est pas un synonyme que l'utilisateur a entré
            for oneTrad in trads {
                if let content = oneTrad.content {
                    if content.supprimerParentheseEtEspaces().uppercased() == word.uppercased() {
                        completion(false,true,trad.supprimerParentheseEtEspaces().capitalizingFirstLetter())
                        return
                    }
                }
            }
            completion(false,false,nil)
            return
        }
    }
    
    //Donne une liste aleatoire de 4 traduction
    func loadRandomWords() -> [ListMot] {
        var words = self.mots
        var wordsReturned : [ListMot] = []
        var randomIndex = Int(arc4random_uniform(UInt32(words.count)))
        if (words.count < 4) {
            return []
        }
        for _ in 1...4 {
            wordsReturned.append(words[randomIndex])
            words.remove(at: randomIndex)
            randomIndex = Int(arc4random_uniform(UInt32(words.count)))
        }
        return wordsReturned.shuffled()
    }
    
    //Charge differents mots au hasard
    @objc func loadRandomsWords() -> [String] {
        var answers : [String] = []
        if (isFrenchToEnglish) {
            guard let word = self.mots[self.motActuelIndex].word?.content else {return []}
            answers.append(word)
            for _ in 1...3 {
                answers.append(giveDifferentWord(of: answers,isLanguageFrench: true))
            }
        } else {
            guard let trad = self.mots[self.motActuelIndex].trad?.content else {return []}
            answers.append(trad)
            for _ in 1...3 {
                answers.append(giveDifferentWord(of: answers,isLanguageFrench: false))
            }
        }
        answers.shuffle()
        return answers
    }
    
    @objc func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func finir() {
        let controller = VCScoreViewController()
        controller.myScore.score.text = String(nbrReussi)
        controller.myScore.maximum.text = String(compteur)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

enum VCGameMode {
    case traduction
    case qcm
    case matching
    case timeAttack
}
