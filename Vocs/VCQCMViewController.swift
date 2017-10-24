//
//  VCQCMViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 20/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCQCMViewController: VCGameViewController {

    let labelMot = VCLabelMot(text : "Word")
    let nextButton = VCButtonExercice("Suivant", color: UIColor(rgb: 0x696969))
    var wordChoices = [VCRowQCM(),VCRowQCM(),VCRowQCM(),VCRowQCM()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "QCM"
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        setupViews()
        unSelectAll()
        giveAWordPlace()
        randomLanguage()
        loadWordToTranslate()
        loadRandomsWords()
    }
    
    //Afficher le mot a traduire et reset les couleurs et les select
    func loadWordToTranslate() {
        self.nextButton.backgroundColor = UIColor(rgb: 0x696969)
        unSelectAll()
        if (francaisOuAnglais) {
            self.labelMot.text = self.mots[self.motActuelIndex].trad?.content
            
        } else {
            self.labelMot.text = self.mots[self.motActuelIndex].word?.content
        }
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
    
    //Charge differents mots au hasard
    func loadRandomsWords() {
        var answers : [String] = []
        if (francaisOuAnglais) {
            guard let word = self.mots[self.motActuelIndex].word?.content else {return}
            answers.append(word)
            for _ in 1...3 {
                answers.append(giveDifferentWord(of: answers,isLanguageFrench: true))
            }
        } else {
            guard let trad = self.mots[self.motActuelIndex].trad?.content else {return}
            answers.append(trad)
            for _ in 1...3 {
                answers.append(giveDifferentWord(of: answers,isLanguageFrench: false))
            }
        }
        answers.shuffle()
        var index = 0
        for wordChoice in wordChoices {
            wordChoice.word = answers[index]
            index += 1
        }
    }
    
    //Donne l'index de la case selectionnée, -1 si aucune
    func giveSelectedIndex() -> Int {
        var index = 0
        for wordChoice in wordChoices {
            if wordChoice.isSelected {
                return index
            }
            index += 1
        }
        return -1
    }
    
    //Passe au prochain mot
    func prochainMot() {
        if compteur >= NBR_MOTS_MAX || compteur + 1 >= self.mots.count {
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(finir), userInfo: nil, repeats: false)
        }
        compteur += 1;
        giveAWordPlace()
        randomLanguage()
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadWordToTranslate), userInfo: nil, repeats: false)
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadRandomsWords), userInfo: nil, repeats: false)
    }
    
    //Quand l'utilisateur appuie sur suivant
    func handleNext() {
        let index = giveSelectedIndex()
        if index == -1 {
            let alertController = UIAlertController(title: "Attention", message:
                "Vous devez selectionner un mot", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Retour", style: UIAlertActionStyle.cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let wordChoosen = wordChoices[index].word
            if francaisOuAnglais {
                guard let word = self.mots[motActuelIndex].word?.content else {return}
                if word == wordChoosen {
                    nbrReussi += 1
                    self.nextButton.backgroundColor = UIColor(rgb: 0x1ABC9C)
                }else {
                    self.nextButton.backgroundColor = UIColor(rgb: 0xF27171)
                }
            } else {
                guard let trad = self.mots[motActuelIndex].trad?.content else {return}
                if trad == wordChoosen {
                    nbrReussi += 1
                    self.nextButton.backgroundColor = UIColor(rgb: 0x1ABC9C)
                } else {
                    self.nextButton.backgroundColor = UIColor(rgb: 0xF27171)
                }
            }
            prochainMot()
        }
    }
    
    //Reglages des 4 choix dans la vue
    func setupChoices() {
        var constant : CGFloat = 0
        let heightOfRow : CGFloat = 45
        var i = 0
        for wordChoice in wordChoices {
            constant = heightOfRow * CGFloat(i) + 25 * CGFloat(i + 1)
            self.view.addSubview(wordChoice)
            wordChoice.topAnchor.constraint(equalTo: self.labelMot.bottomAnchor, constant: constant).isActive = true
            wordChoice.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            wordChoice.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10).isActive = true
            wordChoice.heightAnchor.constraint(equalToConstant: heightOfRow).isActive = true
            wordChoice.buttonValidate.addTarget(self, action: #selector(handleCheck(_:)), for: .touchUpInside)
            i += 1
        }
    }
    
    //Trouver dans l'array des mots, lequel a ce button
    func findWordChoiceWithButton(button : VCButtonValidate) -> VCRowQCM? {
        for wordChoice in wordChoices {
            if wordChoice.buttonValidate == button {
                return wordChoice
            }
        }
        return nil
    }
    
    func handleCheck(_ sender : VCButtonValidate) {
        unSelectAll()
        guard let wordChoice = findWordChoiceWithButton(button : sender) else {return}
        wordChoice.isSelected = true
    }
    
    func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Enlever la selection de tous les mots
    func unSelectAll() {
        for wordChoice in wordChoices {
            wordChoice.isSelected = false
        }
    }

    func setupViews() {
        self.view.addSubviews([nextButton,labelMot])
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
            nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 85/100),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            
            labelMot.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25),
            labelMot.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            labelMot.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            labelMot.heightAnchor.constraint(equalToConstant: 40)
        ])
         setupChoices()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
