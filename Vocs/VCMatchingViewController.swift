//
//  VCMatchingController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 12/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SwifterSwift


class VCMatchingViewController: VCGameViewController {
    
    var xFromCenter : CGFloat = 0
    
    var piocheCard = VCMatchCard(typeOfCard: .toPlace, wordBottom: nil, wordTop: nil, wordDefault: nil)
    var cards : [VCMatchCard] = []
    var copieCards : [VCMatchCard] = []
    let triangleGauche = UIImageView(image: #imageLiteral(resourceName: "triangeGauche"), highlightedImage: nil)
    let triangleDroit = UIImageView(image: #imageLiteral(resourceName: "triangleDroit"), highlightedImage: nil)
    //mots de la partie
    var words : [ListMot] = []
    //mot dans la pioche
    var wordDansPioche : [ListMot] = []
    var score = 0
    
    //ListMot correspondant aux cartes
    var wordsInCards : [ListMot?] = [nil,nil,nil,nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Matching"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        compteur = 0
        partieSuivante()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Matching"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Renitialise les cartes a trouver
    func setCardsToFind() {
        for index in 0...3 {
            cards[index].updateCard(type: .toFind, wordBottom: nil, wordTop: nil, wordDefault: nil)
        }
    }
    
    @objc func handleDroit() {
        if (wordDansPioche.count != 0) {
            wordDansPioche.append(wordDansPioche.removeFirst())
            setupPioche()
        }
    }
    
    @objc func handleGauche() {
        if (wordDansPioche.count != 0) {
            if wordDansPioche.count > 1 {
                var newPioche: [ListMot] = []
                newPioche.append(self.wordDansPioche.removeLast())
                for i in 0...wordDansPioche.count - 1 {
                    newPioche.append(wordDansPioche[i])
                }
                wordDansPioche = newPioche
                setupPioche()
            }
        }
    }
    
    func loadRandomsWordsMatching() {
        self.wordDansPioche = super.loadRandomWords()
        var index = 0
        let wordMelange = self.wordDansPioche.shuffled()
        for word in wordMelange {
            if (isFrenchToEnglish) {
                self.cards[index].updateCard(type: .toFind, wordBottom: nil, wordTop: nil, wordDefault: word.word?.content)
            } else {
                self.cards[index].updateCard(type: .toFind, wordBottom: nil, wordTop: nil, wordDefault: word.trad?.content)
            }
            index += 1
        }
        if (isFrenchToEnglish) {
            self.piocheCard.changeText(wordBottom: nil, wordTop: nil, wordDefault: wordDansPioche.first?.trad?.content)
        } else {
            self.piocheCard.changeText(wordBottom: nil, wordTop: nil, wordDefault: wordDansPioche.first?.word?.content)
        }
        //Au debut de partie, la pioche est compelete
        self.words = wordMelange
    }
    
    func partieSuivante() {
        wordsInCards  = [nil,nil,nil,nil]
        cards = []
        copieCards = []
        for _ in 0...3 {
            cards.append(VCMatchCard(typeOfCard: .toFind, wordBottom: nil, wordTop: nil, wordDefault: nil))
        }
        self.view.removeSubviews()
        giveAWordPlace()
        randomLanguage()
        setCardsToFind()
        ajouterGestureRecoginize()
        loadRandomsWordsMatching()
        loadCopies()
        setupCards()
        setupPioche()
    }
    
    //Passer aux mots suivants
    @objc func handleNext() {
        if (compteur >= NBR_MOTS_MAX) {
            presentScore()
        }
        partieSuivante()
    }
    
    //Verifier le placement
    @objc func handleVerifier() {
        //Si le score = 4, il a gagné
        let score = donnerScore()
        self.score += score
        compteur += 1
        self.coloreMauvaisEtBons()
        if (score) == 4 {
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(handleNext), userInfo: nil, repeats: false)
        } else {
            setupButtonNext()
        }
    }
    
    //Presenter le score
    func presentScore() {
        let controller = VCScoreViewController()
        controller.myScore.maximum.text = String(NBR_MOTS_MAX * 4)
        controller.myScore.score.text = String(self.score)
        self.navigationController?.pushViewController(controller)
    }
    
    //Mettre le bouton next ( prochains mots )
    func setupButtonNext() {
        self.piocheCard.setNext()
        self.piocheCard.removeGestureRecognizers()
        self.piocheCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleNext)))
    }
    
    func ajouterGestureRecoginize(){
        var index = 0
        for _ in 0...3 {
            cards[index].removeGestureRecognizers()
            cards[index].addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(cardWasDragged(_:))))
            cards[index].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardWasTouched(_:))))
            index += 1
        }
        piocheCard.removeGestureRecognizers()
        piocheCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(piocheWasDragged(_:))))
        piocheCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(piocheWasTouched(_:))))
        triangleGauche.isUserInteractionEnabled = true
        triangleDroit.isUserInteractionEnabled = true
        triangleGauche.removeGestureRecognizers()
        triangleDroit.removeGestureRecognizers()
        triangleGauche.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGauche)))
        triangleDroit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDroit)))
    }
    
    //Regler la pioche
    func setupPioche() {
        if (wordDansPioche.count == 0) {
            self.piocheCard.setVerifier()
            self.triangleDroit.isHidden = true
            self.triangleGauche.isHidden = true
            self.piocheCard.removeGestureRecognizers()
            self.piocheCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleVerifier)))
        } else {
            self.triangleDroit.isHidden = false
            self.triangleGauche.isHidden = false
            self.piocheCard.changeTypeCard(newType: .toPlace)
            self.piocheCard.removeGestureRecognizers()
            piocheCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(piocheWasDragged(_:))))
            piocheCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(piocheWasTouched(_:))))
            if (isFrenchToEnglish) {
                self.piocheCard.changeText(wordBottom: nil, wordTop: nil, wordDefault: wordDansPioche.first?.trad?.content)
            } else {
                self.piocheCard.changeText(wordBottom: nil, wordTop: nil, wordDefault: wordDansPioche.first?.word?.content)
            }
        }
    }
    
    //Mettre en rouge les non placés
    func coloreMauvaisEtBons() {
        var index = 0
        for word in words {
            if (word.id != wordsInCards[index]?.id) {
                self.cards[index].backgroundColor = UIColor(hex: 0xF27171)
            } else {
                self.cards[index].backgroundColor = UIColor(hex: 0x1ABC9C)
            }
            index += 1
        }
    }
    
    //verifier si la parite est gagnée et renvoie le score sur 4
    func donnerScore() -> Int {
        var score = 0
        var index = 0
        for word in words {
            if (word.id == wordsInCards[index]?.id) {
                score += 1
            }
            index += 1
        }
        return score
    }
    
    
    let heigthCard : CGFloat = 60
    
    //Positioner les cartes
    func setupCards() {
        let constant : CGFloat = 35
        var i :  CGFloat = 0
        for card in cards {
            card.removeFromSuperview()
            self.view.addSubview(card)
            NSLayoutConstraint.activate([
                card.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                card.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
                card.heightAnchor.constraint(equalToConstant: heigthCard),
                card.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constant * i + heigthCard * i + constant)
            ])
            i += 1
        }
        //laod la pioche
        piocheCard.removeFromSuperview()
        self.view.addSubview(piocheCard)
        NSLayoutConstraint.activate([
            piocheCard.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            piocheCard.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant : -constant),
            piocheCard.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            piocheCard.heightAnchor.constraint(equalToConstant: heigthCard)
        ])
        triangleGauche.translatesAutoresizingMaskIntoConstraints = false
        triangleGauche.removeFromSuperview()
        self.view.addSubview(triangleGauche)
        NSLayoutConstraint.activate([
            self.triangleGauche.centerYAnchor.constraint(equalTo: self.piocheCard.centerYAnchor),
            self.triangleGauche.rightAnchor.constraint(equalTo: self.piocheCard.leftAnchor, constant: -5),
            self.triangleGauche.widthAnchor.constraint(equalToConstant: 20),
            self.triangleGauche.heightAnchor.constraint(equalToConstant: 30)
        ])
        triangleDroit.removeFromSuperview()
        triangleDroit.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(triangleDroit)
        NSLayoutConstraint.activate([
            self.triangleDroit.centerYAnchor.constraint(equalTo: self.piocheCard.centerYAnchor),
            self.triangleDroit.leftAnchor.constraint(equalTo: self.piocheCard.rightAnchor, constant: 5),
            self.triangleDroit.widthAnchor.constraint(equalToConstant: 20),
            self.triangleDroit.heightAnchor.constraint(equalToConstant: 30)
            ])
        ajouterGestureRecoginize()
        setupCopies()
    }
    
    //creer les copies en dessous des vraies cartes
    func loadCopies() {
        copieCards.removeAll()
        for card in cards {
            let copie = card.copie()
            self.copieCards.append(copie)
        }
    }
    
    //Positioner les copies (En dessous des vraies)
    func setupCopies() {
        let constant : CGFloat = 35
        var i :  CGFloat = 0
        for copie in copieCards {
            copie.removeFromSuperview()
            self.view.addSubview(copie)
            view.sendSubview(toBack: copie)
            NSLayoutConstraint.activate([
                copie.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                copie.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
                copie.heightAnchor.constraint(equalToConstant: heigthCard),
                copie.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constant * i + heigthCard * i + constant)
                ])
            i += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func indexOfView(view : UIView) -> Int? {
        var index = 0
        for card in cards {
            if (card == view) {
                return index
            }
            index += 1
        }
        return nil
    }
    
    var viewCenter : CGPoint = .zero
    
    @objc func cardWasTouched(_ gesture : UITapGestureRecognizer) {
        let view = gesture.view as! VCMatchCard
        if view.cardType == .placed {
            //Si la carte est déjà placée, on l'enleve
            guard let index = indexOfView(view: view), let listWord = self.wordsInCards[index], let defaultWord = view.wordTopLabel.text else {
                return
            }
            wordDansPioche.append(listWord)
            setupPioche()
            wordsInCards[index] = nil
            view.updateCard(type: .toFind, wordBottom: nil, wordTop: nil, wordDefault: defaultWord )
        } else {
            //Sinon on place la carte du deck
            guard let defaultWord = view.wordDefaultLabel.text ,let piocheWord = self.piocheCard.wordDefaultLabel.text, let index = indexOfView(view: view) else {
                return
            }
            self.wordsInCards[index] = self.wordDansPioche.removeFirst()
            setupPioche()
            view.updateCard(type: .placed, wordBottom: piocheWord, wordTop: defaultWord, wordDefault: nil)
        }
    }
    
    //Quand on appuie sur la pioche pour passer a la carte suivante
    @objc func piocheWasTouched(_ gesture : UITapGestureRecognizer) {
        if (wordDansPioche.count != 0) {
            self.handleDroit()
        }
    }
    
    
    @objc func piocheWasDragged(_ gesture : UIPanGestureRecognizer) {
        //Si la pioche n'est pas vide, on peut deplacer la carte
        if (wordDansPioche.count != 0) {
            let translation = gesture.translation(in: self.view)
            let view = gesture.view as! VCMatchCard
            
            //On sauvegarde la position de depart de la carte
            if gesture.state == .began {
                viewCenter = view.center
                UIView.animate(withDuration: 0.2, animations: {
                    view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
                self.view.bringSubview(toFront: view)
            }
            
            // On bouge le label grace a la translation
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            //On reset la translation
            gesture.setTranslation(.zero, in: self.view)
            
            //Si l'utilisateur a laché
            if gesture.state == .ended {
                var index = 0
                for card in cards {
                    if card.frame.contains(view.center) {
                        if card.cardType == .toFind {
                            //Alors il a glissé la pioche dans la carte card
                            guard let defaultWord = card.wordDefaultLabel.text ,let piocheWord = self.piocheCard.wordDefaultLabel.text else {
                                return
                            }
                            self.wordsInCards[index] = self.wordDansPioche.removeFirst()
                            setupPioche()
                            card.updateCard(type: .placed, wordBottom: piocheWord, wordTop: defaultWord, wordDefault: nil)
                            UIView.animate(withDuration: 0.1,delay: 0, options: .curveEaseInOut, animations: {
                                card.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            }, completion: { (finished) in
                                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                                    card.transform = CGAffineTransform(scaleX: 1, y: 1)
                                })
                            })
                        } else if (card.cardType == .placed) {
                            //Alors il a glissé la pioche dans la carte card qui etait déjà placée
                            //On recupere la carte qui etait deja placée
                            guard let defaultWord = card.wordTopLabel.text ,let piocheWord = self.piocheCard.wordDefaultLabel.text, let cardBefore = self.wordsInCards[index] else {
                                return
                            }
                            self.wordsInCards[index] = self.wordDansPioche.removeFirst()
                            wordDansPioche.append(cardBefore)
                            setupPioche()
                            card.updateCard(type: .placed, wordBottom: piocheWord, wordTop: defaultWord, wordDefault: nil)
                            UIView.animate(withDuration: 0.1,delay: 0, options: .curveEaseInOut, animations: {
                                card.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            }, completion: { (finished) in
                                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                                    card.transform = CGAffineTransform(scaleX: 1, y: 1)
                                })
                            })
                        }
                    }
                    index += 1
                }
                view.center = self.viewCenter
                UIView.animate(withDuration: 0.2, animations: {
                    view.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
    

    var sauvegardeDeLaCarte : VCMatchCard!
    var sauvegardeCenter : CGPoint = .zero
    
    //Si on glisse une carte déjà placée
    @objc func cardWasDragged(_ gesture : UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let view = gesture.view as! VCMatchCard
        //Si la carte est placée, on peut la deplacer
        if view.cardType == .placed {
            if (gesture.state == .began) {
                sauvegardeDeLaCarte = view
                sauvegardeCenter = view.center
                UIView.animate(withDuration: 0.2, animations: {
                    view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
                self.view.bringSubview(toFront: view)
            }
            
            // On bouge la carte grace a la translation
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            //On reset la translation
            gesture.setTranslation(.zero, in: self.view)
            
            if (gesture.state == .ended) {
                var index = 0
                var cardNotFound = true
                for card in cards {
                    if card.frame.contains(view.center) && card != sauvegardeDeLaCarte  {
                        cardNotFound = false
                        if card.cardType == .toFind {
                            //Alors il a gliséé une carte placée sur une a trouver
                            guard let wordATrouve = view.wordBottomLabel.text ,let defaultWordDeplace = view.wordTopLabel.text, let indexDeLaCarteDeplace = indexOfView(view: view), let defaultWord = card.wordDefaultLabel.text else {
                                return
                            }
                            self.wordsInCards[index] = self.wordsInCards[indexDeLaCarteDeplace]
                            card.updateCard(type: .placed, wordBottom: wordATrouve, wordTop: defaultWord, wordDefault: nil)
                            view.updateCard(type: .toFind, wordBottom: nil, wordTop: nil, wordDefault: defaultWordDeplace)
                        } else if (card.cardType == .placed) {
                            // Alors il a gliséé une carte placée sur une déjà placée
                            // Il faut donc les inverser
                            guard let bottomWordDeplacé = view.wordBottomLabel.text, let topWordDeplacé = view.wordTopLabel.text, let bottomWordCiblé = card.wordBottomLabel.text, let topWordCiblé = card.wordTopLabel.text, let indexCarteDeplace = indexOfView(view: view) else {
                                return
                            }
                            //On inverse les deux
                            let tmp = self.wordsInCards[index]?.copie()
                            self.wordsInCards[index] = self.wordsInCards[indexCarteDeplace]
                            self.wordsInCards[indexCarteDeplace] = tmp
                            card.updateCard(type: .placed, wordBottom: bottomWordDeplacé, wordTop: topWordCiblé, wordDefault: nil)
                            view.updateCard(type: .placed, wordBottom: bottomWordCiblé, wordTop: topWordDeplacé, wordDefault: nil)
                        }
                    }
                    index += 1
                }
                if cardNotFound {
                    view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    view.center = sauvegardeCenter
                } else {
                    view.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        }
    }
    
}

