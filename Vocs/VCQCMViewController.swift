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
    let nextButton = VCButtonExercice("Vérifier", color: UIColor(rgb: 0x696969))
    var wordChoices = [VCRowQCM(),VCRowQCM(),VCRowQCM(),VCRowQCM()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "QCM"
        nextButton.addTarget(self, action: #selector(handleVerifier), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        setupViews()
        unSelectAll()
        giveAWordPlace()
        randomLanguage()
        loadWordToTranslate()
        self.loadRandomsWordsQCM()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "QCM"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Afficher le mot a traduire et reset les couleurs et les select
    @objc func loadWordToTranslate() {
        self.nextButton.backgroundColor = UIColor(rgb: 0x696969)
        unSelectAll()
        self.loadRandomsWordsQCM()
        if (isFrenchToEnglish) {
            self.labelMot.text = self.mots[self.motActuelIndex].trad?.content?.capitalizingFirstLetter()
        } else {
            self.labelMot.text = self.mots[self.motActuelIndex].word?.content?.capitalizingFirstLetter()
        }
    }
    
    //Charge differents mots au hasard
    @objc func loadRandomsWordsQCM() {
        let answers = super.loadRandomsWords()
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
    
    @objc func nextMot() {
        nextButton.removeTarget(self, action: #selector(nextMot), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleVerifier), for: .touchUpInside)
        self.nextButton.setTitle("Vérifier", for: .normal)
        loadWordToTranslate()
        _  = loadRandomWords()
    }
    
    //Passe au prochain mot
    func prochainMot(gagne : Bool) {
        if compteur + 1 >= NBR_MOTS_MAX || compteur + 1 >= self.mots.count {
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(finir), userInfo: nil, repeats: false)
            return
        }
        compteur += 1;
        giveAWordPlace()
        randomLanguage()
        if (gagne) {
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(nextMot), userInfo: nil, repeats: false)
        } else {
            self.nextButton.setTitle("Suivant", for: .normal)
            nextButton.removeTarget(self, action: #selector(handleVerifier), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(nextMot), for: .touchUpInside)
        }
    }
    
    //Quand l'utilisateur appuie sur suivant
    @objc func handleVerifier() {
        let index = giveSelectedIndex()
        if index == -1 {
            let alertController = UIAlertController(title: "Attention", message:
                "Vous devez selectionner un mot", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Retour", style: UIAlertActionStyle.cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let wordChoosen = wordChoices[index].word
            if isFrenchToEnglish {
                guard let word = self.mots[motActuelIndex].word?.content else {return}
                if word == wordChoosen {
                    nbrReussi += 1
                    colorerMots(perdu: false, word: word)
                    prochainMot(gagne: true)
                }else {
                    colorerMots(perdu: false, word: word)
                    colorerMots(perdu: true, word: wordChoosen)
                    prochainMot(gagne: false)
                }
            } else {
                guard let trad = self.mots[motActuelIndex].trad?.content else {return}
                if trad == wordChoosen {
                    nbrReussi += 1
                    colorerMots(perdu: false, word: trad)
                    prochainMot(gagne: true)
                } else {
                    colorerMots(perdu: false, word: trad)
                    colorerMots(perdu: true, word: wordChoosen)
                    prochainMot(gagne: false)
                }
            }
        }
    }
    
    //Colorer le bon mot ( et mettre en rouge si il a perdu )
    func colorerMots(perdu : Bool, word : String) {
        for wordChoice in wordChoices {
            if ( wordChoice.word == word) {
                wordChoice.wordLabel.textColor = perdu ? UIColor(hex: 0xF27171) : UIColor(hex : 0x1ABC9C)
            }
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
    
    @objc func handleCheck(_ sender : VCButtonValidate) {
        unSelectAll()
        guard let wordChoice = findWordChoiceWithButton(button : sender) else {return}
        wordChoice.isSelected = true
    }
    
    //Enlever la selection de tous les mots
    func unSelectAll() {
        for wordChoice in wordChoices {
            wordChoice.wordLabel.textColor = UIColor(rgb: 0x696969)
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
