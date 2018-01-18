//
//  VCChangeLangueController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 12/01/2018.
//  Copyright © 2018 Wathis. All rights reserved.
//

import UIKit

class VCChangeLangueController : VCChangeProfilController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var prononciationMot : PrononcationMots!
    var idLangue = Parametre.loadInstance().defaultLangId
    var parametres = Parametre.loadInstance()
    let buttonTester = VCButtonExercice("Tester la voix", color: UIColor(hex: 0x1C7FBD)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.inputView = pickerView
        prononciationMot = PrononcationMots.loadInstance()
        //On charge les langues anglaises
        prononciationMot.chargerLangues(code: "en")
        self.navigationItem.title = "Prononciation"
        setupViews()
    }
    
    lazy var pickerView : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    override func loadPlaceholder() {
        self.textField.placeholder = Parametre.loadInstance().loadLangName()
    }
    
    @objc override func handleChange() {
        parametres.setLang(id: idLangue)
        delegate?.reloadData()
        self.navigationController?.popViewController()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prononciationMot.voicesLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let langName = prononciationMot.voicesLanguages[row]["languageName"] as? String,
            let langPerson = prononciationMot.voicesLanguages[row]["languagePerson"] as? String else {
                return nil
        }
        return "\(langName) par \(langPerson)"
    }
    
    var choosenIndex = 0
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = prononciationMot.voicesLanguages[row]["languageName"] as? String
        if let id = prononciationMot.voicesLanguages[row]["languageCode"] as? String {
            self.idLangue = id
        }
        choosenIndex = row
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    let testText = "Hello, my name is"
    //Tester la voix choisie
    @objc func handleTester() {
        if let person = prononciationMot.voicesLanguages[choosenIndex]["languagePerson"] as? String {
            prononciationMot.prononcer(expression: "\(testText) \(person)", codeLangue: idLangue)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(buttonTester)
        self.buttonTester.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.buttonTester.centerYAnchor.constraint(equalTo: self.buttonConfirm.centerYAnchor, constant: 80).isActive = true
        self.buttonTester.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10).isActive = true
        self.buttonTester.heightAnchor.constraint(equalToConstant: 60).isActive = true
        buttonTester.addTarget(self, action: #selector(handleTester), for: .touchUpInside)
    }
}
