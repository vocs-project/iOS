//
//  VCChangeProfilController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 22/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit


class VCChangeProfilController : UIViewController {
    
    let labelIndication = VCLabelMenu(text: "",size: 20)
    let textField = VCTextFieldLigneBas(placeholder: "", alignement: .center)
    let buttonConfirm = VCButtonExercice("Mettre à jour", color: UIColor(hex: 0x1ABC9C)!)
    var gameController : VCGameViewController?
    var accountInformationType :  VCProfilCategory?
    var currentUser : User?
    var delegate : VDelegateReload?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.backgroundColor = .white
        loadPlaceholder()
        hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Profil"
        self.buttonConfirm.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
    }
    
    func loadPlaceholder() {
        guard let category  = self.accountInformationType else {
            return
        }
        switch category {
        case .email:
            self.textField.placeholder = "Entrez votre email"
            break
        case .name:
            self.textField.placeholder = "Entrez votre nouveau nom"
            break
        case .firstname:
            self.textField.placeholder = "Entrez votre nouveau prenom"
            break
        case .password:
            self.textField.placeholder = "Entrez votre nouveau mot de passe"
            self.textField.isSecureTextEntry = true
            break
        default:
            break
        }
    }
    
    @objc func handleChange() {
        guard let information = textField.text,let category  = self.accountInformationType else {
            return
        }
        switch category {
        case .email:
            self.currentUser?.email = information
            break
        case .name:
            self.currentUser?.name  = information
            break
        case .firstname:
            self.currentUser?.firstName  = information
            break
        case .password:
            self.currentUser?.changePassword(newPassword : information, completion : { (user) in
                self.currentUser = user
                if user == nil {
                    self.presentError(title: "Erreur", message: "Une erreur est survenue")
                } else {
                    self.delegate?.reloadData()
                    self.navigationController?.popViewController()
                }
            })
            return
        default:
            break
        }
        self.currentUser?.updateProfil(completion: { (user) in
            if user == nil {
                self.presentError(title: "Erreur", message: "Une erreur est survenue")
            } else {
                self.delegate?.reloadData()
                self.navigationController?.popViewController()
            }
            self.currentUser = user
        })
    }
    
    func setupViews() {
        self.view.addSubviews([labelIndication,textField,buttonConfirm])
        
        NSLayoutConstraint.activate([
            self.labelIndication.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.labelIndication.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            self.labelIndication.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            self.labelIndication.heightAnchor.constraint(equalToConstant: 50),
            
            self.textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80),
            self.textField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            self.textField.heightAnchor.constraint(equalToConstant: 50),
            
            self.buttonConfirm.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonConfirm.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60),
            self.buttonConfirm.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            self.buttonConfirm.heightAnchor.constraint(equalToConstant: 60)
            ])
        
    }
}
