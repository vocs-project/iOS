//
//  VCRegisterInformations.swift
//  Vocs
//
//  Created by Mathis Delaunay on 16/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCRegisterInformations: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let prenomTextfield = VCTextfieldInformations(placeholder: "Prenom")
    let nomTextfield = VCTextfieldInformations(placeholder: "Nom")
    let statusTextfield = VCTextfieldInformations(placeholder: "Status")
    let levelTextfield = VCTextfieldInformations(placeholder: "Niveau")
    let codeTextfield = VCTextfieldInformations(placeholder: "Code postal")
    let cityTextfield = VCTextfieldInformations(placeholder: "Ville")
    let schoolNameTextfield = VCTextfieldInformations(placeholder: "Nom de l'école")
    let buttonNext = VCButtonRegister()
    
    var selectedTextfield = UITextField()
    
    let status = ["Étudiant","Professeur","Libre"]
    let levels = ["Bac","DUT","BTS","Prépa"]
    var cities : [String] = []  {
        didSet {
            self.pickerViewCities.reloadAllComponents()
        }
    }

    var pickerViewNiveau = UIPickerView()
    var pickerViewStatus = UIPickerView()
    var pickerViewCities = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "BackgroundConnexion"))
        self.hideKeyboardWhenTappedAround()
        setupTextFields()
        buttonNext.text = "Terminer"
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let table = getTableFromPickerView(pickerView: pickerView) else {return 0}
        return table.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let table = getTableFromPickerView(pickerView: pickerView) else {return nil}
        return table[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let table = getTableFromPickerView(pickerView: pickerView) else {return}
        selectedTextfield.text = table[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getTableFromPickerView(pickerView : UIPickerView) -> [String]? {
        switch pickerView {
        case pickerViewCities:
            return self.cities
        case pickerViewNiveau:
            return self.levels
        case pickerViewStatus:
            return self.status
        default:
            return nil
        }
    }
    
    func handleNext() {
        self.present(VCThanksJoinUs(), animated: true, completion: nil)
    }
    
    func setupTextFields() {
        let heightOfTextField : CGFloat = 45
        
        self.view.addSubviews([prenomTextfield,nomTextfield,statusTextfield,levelTextfield,codeTextfield,cityTextfield,schoolNameTextfield,buttonNext])
        
        NSLayoutConstraint.activate([
            prenomTextfield.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            prenomTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            prenomTextfield.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            prenomTextfield.heightAnchor.constraint(equalToConstant: heightOfTextField),
            
            nomTextfield.topAnchor.constraint(equalTo: self.prenomTextfield.bottomAnchor, constant: 20),
            nomTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nomTextfield.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            nomTextfield.heightAnchor.constraint(equalToConstant: heightOfTextField),
            
            statusTextfield.topAnchor.constraint(equalTo: self.nomTextfield.bottomAnchor, constant: 20),
            statusTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            statusTextfield.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            statusTextfield.heightAnchor.constraint(equalToConstant: heightOfTextField),
            
            levelTextfield.topAnchor.constraint(equalTo: self.statusTextfield.bottomAnchor, constant: 20),
            levelTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            levelTextfield.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            levelTextfield.heightAnchor.constraint(equalToConstant: heightOfTextField),
            
            codeTextfield.topAnchor.constraint(equalTo: self.levelTextfield.bottomAnchor, constant: 20),
            codeTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            codeTextfield.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            codeTextfield.heightAnchor.constraint(equalToConstant: heightOfTextField),
            
            cityTextfield.topAnchor.constraint(equalTo: self.codeTextfield.bottomAnchor, constant: 20),
            cityTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cityTextfield.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            cityTextfield.heightAnchor.constraint(equalToConstant: heightOfTextField),
            
            schoolNameTextfield.topAnchor.constraint(equalTo: self.cityTextfield.bottomAnchor, constant: 20),
            schoolNameTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            schoolNameTextfield.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            schoolNameTextfield.heightAnchor.constraint(equalToConstant: heightOfTextField),
            
            buttonNext.topAnchor.constraint(equalTo: self.schoolNameTextfield.bottomAnchor, constant: 20),
            buttonNext.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonNext.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            buttonNext.heightAnchor.constraint(equalToConstant: heightOfTextField)
            ])
        
        buttonNext.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        cityTextfield.textField.inputView = pickerViewCities
        levelTextfield.textField.inputView = pickerViewNiveau
        statusTextfield.textField.inputView = pickerViewStatus
        
        prenomTextfield.textField.delegate = self
        nomTextfield.textField.delegate = self
        statusTextfield.textField.delegate = self
        levelTextfield.textField.delegate = self
        codeTextfield.textField.delegate = self
        cityTextfield.textField.delegate = self
        schoolNameTextfield.textField.delegate = self
        
        pickerViewStatus.dataSource = self
        pickerViewStatus.delegate = self
        pickerViewNiveau.dataSource = self
        pickerViewNiveau.delegate = self
        pickerViewCities.dataSource = self
        pickerViewCities.delegate = self
        
        codeTextfield.textField.keyboardType = .decimalPad
    }
}

extension VCRegisterInformations : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextfield = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.codeTextfield.textField {
            guard let code = textField.text else {return}
            if !code.isNumeric || code.characters.count > 5 {
                textField.shake()
                self.cityTextfield.textField.text = ""
                return
            }
            City.loadCityFrom(code: code) { cities in
                self.cityTextfield.textField.text = ""
                self.cities = cities
            }
        }
    }
}
