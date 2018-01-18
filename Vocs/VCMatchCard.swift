//
//  VCMatchCard.swift
//  Vocs
//
//  Created by Mathis Delaunay on 15/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SwifterSwift

class VCMatchCard : UIView {
    
    //Mot placé ( Bouge pas )
    var wordTopLabel = VCLabelMenu(text: "Mot", size: 15)
    
    var wordBottomLabel = VCLabelMenu(text: "Traduction", size: 18)
    
    //Mot à placer ( Qui peut etre déplacé )
    var wordDefaultLabel = VCLabelMenu(text: "A traduire", size: 20)
    
    let COLOR_GRAY = UIColor(hex: 0xA1A1A1)
    let COLOR_BLUE = UIColor(hex: 0x1C7EBC)
    let COLOR_GREEN = UIColor(hex : 0x1ABC9C)
    
    var cardType : VCTypeOfMatchCard! {
        didSet {
            self.setupCard(typeOfCard: cardType)
        }
    }
    
    init(typeOfCard : VCTypeOfMatchCard, wordBottom : String?, wordTop : String?, wordDefault : String?) {
        super.init(frame: .zero)
        self.changeText(wordBottom: wordBottom, wordTop: wordTop, wordDefault: wordDefault)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupViews()
        self.cardType = typeOfCard
        self.setupCard(typeOfCard : typeOfCard)
        self.isUserInteractionEnabled = true
    }
    
    func setVerifier() {
        self.backgroundColor = UIColor(hex: 0x696969)
        self.changeText(wordBottom: nil, wordTop: nil, wordDefault: "Vérifier")
    }
    
    func setNext() {
        self.backgroundColor = UIColor(hex: 0x696969)
        self.changeText(wordBottom: nil, wordTop: nil, wordDefault: "Suivant")
    }
    
    //Changer le text dans les labels
    func changeText(wordBottom : String?, wordTop : String?, wordDefault : String?) {
        self.wordBottomLabel.text = wordBottom
        self.wordTopLabel.text = wordTop
        self.wordDefaultLabel.text = wordDefault
    }
    
    //permet de changer l'apparence de la carte
    func changeTypeCard(newType : VCTypeOfMatchCard) {
        self.cardType = newType
    }
    
    func updateCard(type : VCTypeOfMatchCard, wordBottom : String?, wordTop : String?, wordDefault : String?) {
        self.changeTypeCard(newType: type)
        self.changeText(wordBottom: wordBottom?.capitalizingFirstLetter(), wordTop: wordTop?.capitalizingFirstLetter(), wordDefault: wordDefault?.capitalizingFirstLetter())
    }
    
    //Fait les reglages de la carte
    func setupCard(typeOfCard : VCTypeOfMatchCard) {
        if (typeOfCard == .placed) {
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
            self.backgroundColor = COLOR_BLUE
            self.wordTopLabel.textColor = .white
            self.wordBottomLabel.textColor = .white
            self.wordBottomLabel.isHidden = false
            self.wordTopLabel.isHidden = false
            self.wordDefaultLabel.isHidden = true
        } else if (typeOfCard == .toPlace) {
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
            self.wordDefaultLabel.textColor = .white
            self.wordBottomLabel.isHidden = true
            self.wordTopLabel.isHidden = true
            self.wordDefaultLabel.isHidden = false
            self.backgroundColor = COLOR_BLUE
        } else if (typeOfCard == .toFind) {
            self.layer.borderColor = COLOR_GRAY?.cgColor
            self.layer.borderWidth = 2
            self.backgroundColor = .white
            self.wordDefaultLabel.textColor = COLOR_GRAY
            self.wordBottomLabel.isHidden = true
            self.wordTopLabel.isHidden = true
            self.wordDefaultLabel.isHidden = false
        }
        setupView(typeCard: typeOfCard)
    }
    
    func setupView(typeCard : VCTypeOfMatchCard) {
        self.layer.cornerRadius = 30
        if typeCard == .toFind {
            self.layer.shadowColor = .none
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
        } else {

            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.shadowRadius = 1
            self.layer.shadowOpacity = 0.5
        
        }
    }
    
    func setupViews() {
        self.addSubviews([wordDefaultLabel,wordTopLabel,wordBottomLabel])
        
        NSLayoutConstraint.activate([
            self.wordDefaultLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.wordDefaultLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.wordDefaultLabel.heightAnchor.constraint(equalToConstant: 50),
            self.wordDefaultLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10),
            
            self.wordTopLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.wordTopLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant : -13),
            self.wordTopLabel.heightAnchor.constraint(equalToConstant: 50),
            self.wordTopLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10),
            
            self.wordBottomLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.wordBottomLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant : 13),
            self.wordBottomLabel.heightAnchor.constraint(equalToConstant: 50),
            self.wordBottomLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10)
        ])
    }
    
    func copie() -> VCMatchCard {
        return VCMatchCard(typeOfCard: self.cardType, wordBottom: self.wordBottomLabel.text, wordTop: self.wordTopLabel.text, wordDefault: self.wordDefaultLabel.text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum VCTypeOfMatchCard {
    case toPlace
    case placed
    case toFind
}
