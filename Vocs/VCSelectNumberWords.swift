//
//  VCSelectNumberWords.swift
//  Vocs
//
//  Created by Mathis Delaunay on 20/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit


class VCSelectNumberWord : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let labelIndication = VCLabelMenu(text: "Choisir la taille de vos exercices",size: 20)
    let textFieldNumberWords = VCTextFieldLigneBas(placeholder: "Choisir une taille", alignement: .center)
    let buttonConfirm = VCButtonExercice("Modifier", color: UIColor(hex: 0x1ABC9C)!)
    
    var delegate : VDelegateReload?
    var numberChoosen = Parametre.loadInstance().loadExcerciceSize()
    
    
    lazy var pickerView : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Taille exercices"
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        self.buttonConfirm.addTarget(self, action: #selector(handleModify), for: .touchUpInside)
        self.textFieldNumberWords.inputView = pickerView
        self.textFieldNumberWords.text = "\(Parametre.loadInstance().loadExcerciceSize())"
    }
    
    @objc func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Changer la taille des exerices
    @objc func handleModify() {
        Parametre.loadInstance().setExerciceSize(size: numberChoosen)
        delegate?.reloadData()
        self.navigationController?.popViewController()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Parametre.loadInstance().NBR_MAX_MOTS
    }
    
    //On retourne row car ce sont des numeros croissants
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (row + 1).string
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldNumberWords.text = (row + 1).string
        numberChoosen = row + 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func setupViews() {
        self.view.addSubviews([labelIndication,textFieldNumberWords,buttonConfirm])
        
        NSLayoutConstraint.activate([
            self.labelIndication.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.labelIndication.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            self.labelIndication.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            self.labelIndication.heightAnchor.constraint(equalToConstant: 50),
            
            self.textFieldNumberWords.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldNumberWords.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -80),
            self.textFieldNumberWords.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            self.textFieldNumberWords.heightAnchor.constraint(equalToConstant: 50),
            
            self.buttonConfirm.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonConfirm.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60),
            self.buttonConfirm.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            self.buttonConfirm.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
}
