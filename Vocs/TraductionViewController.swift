//
//  TraductionViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SQLite

class TraductionViewController: UIViewController {

    var textField = VCTextFieldLigneBas(placeholder :"",alignement : .center)
    var validateButton = VCButtonValidate()
    var labelMot = VCLabelMot(text : "")
    var compteur = 0
    let NBR_MOTS_MAX = 10
    var nbrReussi = 0
    var mots : [Mot] = []
    var list : List?
    var motActuelIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Traduction"
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Revenir", style: .plain, target: self, action: #selector(handleLeave)), animated: true)
        validateButton.addTarget(self, action: #selector(handleCheck), for: .touchUpInside)
        setupViews()
        giveAWordPlace()
        randomBoolForWord()
        loadWords()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    func giveAWordPlace() {
        motActuelIndex = Int(arc4random_uniform(UInt32(self.mots.count)))
    }
    
    func loadWords() {
        guard let idList = self.list?.id_list else {return}
        mots = Mot.loadWords(fromListId : idList)
        loadWordOnScreen()
    }
    
    func handleCheck() {
        if !(self.textField.text?.isEmpty)!{
            if (francaisOuAnglais){
                if let mot = mots[compteur].french?.uppercased() {
                    if (mot.contains((self.textField.text?.uppercased())!)){
                        textField.textColor = UIColor(rgb: 0x1ABC9C)
                        nbrReussi += 1;
                    } else {
                        textField.textColor = UIColor(rgb: 0xD83333)
                    }
                }
            } else {
                if let mot = mots[compteur].english?.uppercased() {
                    if (mot.contains((self.textField.text?.uppercased())!)){
                        textField.textColor = UIColor(rgb: 0x1ABC9C)
                        nbrReussi += 1;
                    } else {
                        textField.textColor = UIColor(rgb: 0xD83333)
                    }
                }
            }
        }
        compteur += 1;
        randomBoolForWord()
        giveAWordPlace()
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadWordOnScreen), userInfo: nil, repeats: false)
        textField.isEnabled = false
        validateButton.isEnabled = false
    }
    
    var francaisOuAnglais = true
    
    func randomBoolForWord() {
        francaisOuAnglais = (arc4random_uniform(2) == 0)
    }
    
    func finir() {
        let controller = ScoreViewController()
        controller.myScore.score.text = String(nbrReussi)
        controller.myScore.maximum.text = String(compteur)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadWordOnScreen(){
        if (compteur == NBR_MOTS_MAX){
            finir()
        }
        if (compteur < mots.count){
            if (francaisOuAnglais){
                self.labelMot.text = mots[compteur].english
            } else {
                self.labelMot.text = mots[compteur].french
            }
            self.textField.textColor = UIColor(rgb: 0x4A4A4A)
            self.textField.text = ""
        } else {
            finir()
        }
        textField.isEnabled = true
        validateButton.isEnabled = true
    }
    
    
    func setupViews() {
        
        self.view.addSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant : -40).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor,constant : -20).isActive = true
        
        self.view.addSubview(validateButton)
        validateButton.leftAnchor.constraint(equalTo: textField.rightAnchor,constant : 10).isActive = true
        validateButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        validateButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        validateButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant : -40).isActive = true
        
        self.view.addSubview(labelMot)
        labelMot.bottomAnchor.constraint(equalTo: textField.topAnchor,constant : -80).isActive = true
        labelMot.heightAnchor.constraint(equalToConstant: 40).isActive = true
        labelMot.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        labelMot.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    func handleLeave () {
        self.dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
}
