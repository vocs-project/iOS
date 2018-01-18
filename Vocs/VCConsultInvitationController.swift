//
//  VCViewInvitationController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 03/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCConsultInvitationController : UIViewController {
    
    let buttonRefuse = VCButtonExercice("Refuser", color: UIColor(rgb: 0xF27171))
    let buttonValidate = VCButtonExercice("Accepter", color: UIColor(rgb: 0x1ABC9C))
    let headerTitle = VCHeaderListe(text: "Titre")
    
    var labelFrom = VCLabelMenu(text: "De : ", size: 16, textAlignement: .left)
    var labelOne = VCLabelMenu(text: "Premier : ", size: 16, textAlignement: .left)
    var labelTwo = VCLabelMenu(text: "Deuxieme : ", size: 16, textAlignement: .left)
    var labelThree = VCLabelMenu(text: "Troiseme : ", size: 16, textAlignement: .left)
    
    var delegateUserChangeClass : VCUserChangeClass?
    var delegateUpdateMessage : VCDelegateDemands?
    var demand : Demand? {
        didSet {
            setupTexts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelFrom.textAlignment = .left
        labelOne.textAlignment = .left
        labelTwo.textAlignment = .left
        labelThree.textAlignment = .left
        setupViews()
        self.view.backgroundColor = .white
        buttonRefuse.addTarget(self, action: #selector(handleRefuser), for: .touchUpInside)
        buttonValidate.addTarget(self, action: #selector(handleAccepter), for: .touchUpInside)
    }
    
    func setupTexts() {
        guard let demand = self.demand, let userWhoSent = demand.userSend else {
            return
        }
        guard let firstname = userWhoSent.firstName, let surname = userWhoSent.name else {
            return
        }
        labelFrom.text = "De : \(surname.uppercased()) \(firstname.lowercased().capitalizingFirstLetter())"
        if demand is DemandClasse {
            guard let classe = (demand as! DemandClasse).classe, let classeName = classe.name else {
                return
            }
            headerTitle.titleText = "Classe"
            labelOne.text = "Ecole : Non renseignée"
            labelTwo.text = "Classe : \(classeName)"
            labelThree.text = ""
        } else if demand is DemandList {
            guard let list = (demand as! DemandList).list, let listName = list.name else {
                return
            }
            headerTitle.titleText = "Liste"
            labelOne.text = "Liste : \(listName)"
            labelTwo.text = ""
            labelThree.text = ""
        } else if demand is DemandWord {
            guard let wordTrad = (demand as! DemandWord).wordTrad, let word = wordTrad.word?.content, let trad = wordTrad.trad?.content else {
                return
            }
            headerTitle.titleText = "Mot"
            labelOne.text = "Cette traduction est-elle correcte ?"
            labelTwo.text = "Mot : \(word)"
            labelThree.text = "Traduction : \(trad)"
        }
    }
    
    @objc func handleRefuser() {
        guard let demand = self.demand else {
            self.presentError(title: "Erreur", message: "Erreur de chargement")
            self.navigationController?.popViewController()
            return
        }
        demand.refuseDemand { (deleted) in
            if !deleted {
                self.presentError(title: "Erreur", message: "Erreur lors de la connexion")
            } else {
                self.delegateUpdateMessage?.updateMessages()
                self.navigationController?.popViewController()
            }
        }
    }
    
    @objc func handleAccepter() {
        guard let demand = self.demand else {
            return
        }
        if let uid = Auth().currentUserId {
            User.loadUser(userId: uid, completion: { (user) in
                if user == nil {
                    return
                }
                demand.accepterDemand(completion: { (joined) in
                    if joined {
                        self.navigationController?.popViewController()
                    } else {
                        self.presentError(title: "Erreur", message: "Une erreur de connexion est survenue")
                        self.navigationController?.popViewController()
                    }
                    self.delegateUpdateMessage?.updateMessages()
                })
            })
        }
    }
    
    func setupViews() {
        self.view.addSubview(buttonRefuse)
        self.view.addSubview(buttonValidate)
        self.view.addSubview(headerTitle)
        self.view.addSubview(labelFrom)
        self.view.addSubview(labelOne)
        self.view.addSubview(labelTwo)
        self.view.addSubview(labelThree)
        
        NSLayoutConstraint.activate([
            
            headerTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            headerTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            headerTitle.heightAnchor.constraint(equalToConstant: 40),
            headerTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            
            labelFrom.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            labelFrom.heightAnchor.constraint(equalToConstant: 40),
            labelFrom.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            labelFrom.topAnchor.constraint(equalTo: self.headerTitle.bottomAnchor, constant: 10),
            
            labelOne.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            labelOne.heightAnchor.constraint(equalToConstant: 40),
            labelOne.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            labelOne.topAnchor.constraint(equalTo: self.labelFrom.bottomAnchor, constant: 10),
            
            labelTwo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            labelTwo.heightAnchor.constraint(equalToConstant: 40),
            labelTwo.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            labelTwo.topAnchor.constraint(equalTo: self.labelOne.bottomAnchor, constant: 10),
            
            labelThree.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            labelThree.heightAnchor.constraint(equalToConstant: 40),
            labelThree.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            labelThree.topAnchor.constraint(equalTo: self.labelTwo.bottomAnchor, constant: 10),
            
            buttonValidate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonValidate.topAnchor.constraint(equalTo: self.labelThree.bottomAnchor, constant : 20),
            buttonValidate.heightAnchor.constraint(equalToConstant: 60),
            buttonValidate.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            
            buttonRefuse.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonRefuse.topAnchor.constraint(equalTo: self.buttonValidate.bottomAnchor, constant : 15),
            buttonRefuse.heightAnchor.constraint(equalToConstant: 60),
            buttonRefuse.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
        ])
    }
}


