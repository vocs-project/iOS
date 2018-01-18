//
//  TraductionViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SQLite

class VCTraductionViewController: VCGameViewController {

    var textField = VCTextFieldLigneBas(placeholder :"",alignement : .center)
    var validateButton = VCButtonValidate()
    var labelMot = VCLabelMot(text : "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Traduction"
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.textField.spellCheckingType = .no
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Revenir", style: .plain, target: self, action: #selector(handleLeave)), animated: true)
        validateButton.addTarget(self, action: #selector(handleCheck), for: .touchUpInside)
        setupViews()
        giveAWordPlace()
        randomLanguage()
        loadWordOnScreen()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Traduction"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    @objc func handleRevenir () {
        alertInformation.dismiss(animated: false, completion: nil)
    }
    let alertInformation = VCAlertViewController()
    @objc func handleCheck() {
        guard let text = self.textField.text else {
            return
        }
        if !text.isEmpty {
            self.verifierTraduction(wordTrad: mots[motActuelIndex], word: text, completion: { (estTraductionAttendue, estSynonyme, tradAttendu) in
                if (estTraductionAttendue || estSynonyme) {
                    textField.textColor = UIColor(rgb: 0x1ABC9C)
                    nbrReussi += 1;
                    if (estSynonyme && tradAttendu != nil) {
                        alertInformation.buttonBottom.addTarget(self, action: #selector(handleRevenir), for: .touchUpInside)
                        alertInformation.buttonTop.isHidden = true
                        alertInformation.buttonTop.isUserInteractionEnabled = false
                        alertInformation.titleText = "\(text) est correct"
                        alertInformation.contentText = "Mais le mot\nattendu était\n\(tradAttendu!)"
                        self.present(alertInformation, animated: false, completion: nil)
                    }
                } else {
                    //Information sur la bonne traduction du mot
                    if (mots[motActuelIndex].word?.content != nil && mots[motActuelIndex].trad?.content != nil) {
                        alertInformation.buttonBottom.addTarget(self, action: #selector(handleRevenir), for: .touchUpInside)
                        alertInformation.wordIncorrect = text.capitalizingFirstLetter()
                        alertInformation.isWordToTranslateFrench = super.isFrenchToEnglish
                        alertInformation.word = mots[motActuelIndex]
                        self.present(alertInformation, animated: false, completion: nil)
                    }
                    textField.textColor = UIColor(rgb: 0xD83333)
                }
                compteur += 1;
                _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loadWordOnScreen), userInfo: nil, repeats: false)
                textField.isEnabled = false
                validateButton.isEnabled = false
            })
        }
    }
    
    @objc func loadWordOnScreen(){
        //Si le compteur est egal au nombre de mots choisis, on fini
        if (compteur == NBR_MOTS_MAX){
            finir()
            return
        }
        //Sinon on continue et on charge un nouveau mot
        giveAWordPlace()
        randomLanguage()
        if (isFrenchToEnglish){
            self.labelMot.text = mots[motActuelIndex].word?.content?.capitalizingFirstLetter()
        } else {
            self.labelMot.text = mots[motActuelIndex].trad?.content?.capitalizingFirstLetter()
        }
        self.textField.textColor = UIColor(rgb: 0x4A4A4A)
        self.textField.text = ""
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

    @objc func handleLeave () {
        self.dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
}
