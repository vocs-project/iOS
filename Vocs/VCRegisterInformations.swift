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
    let schoolTextField = VCTextfieldInformations(placeholder: "École")
    let buttonNext = VCButtonRegister()
    
    var selectedTextfield = UITextField()
    var email : String?
    var password : String?
    let roles :  [String] = ["Élève","Professeur","Libre"]
    let levels = ["Bac","DUT","BTS","Prépa"]
    var schools : [String] = []  {
        didSet {
            self.pickerViewSchools.reloadAllComponents()
        }
    }

    var pickerViewNiveau = UIPickerView()
    var pickerViewStatus = UIPickerView()
    var pickerViewSchools = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
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
        case pickerViewSchools:
            return schools
        case pickerViewNiveau:
            return self.levels
        case pickerViewStatus:
            return self.roles
        default:
            return nil
        }
    }
    
    @objc func handleNext() {
        guard let prenom = self.prenomTextfield.textField.text, let nom = self.nomTextfield.textField.text, let email = self.email, let password = self.password  , let role = self.statusTextfield.textField.text else {return}
        var roleName : String = "ROLE_USER"
        switch role {
        case "Professeur":
             roleName = "ROLE_PROFESSOR"
            break
        case "Élève":
            roleName = "ROLE_STUDENT"
            break
        default:
             roleName = "ROLE_USER"
        }
        Auth().registerUser(firstname: prenom, surname: nom, email: email, password: password, role : roleName) { (created) in
            if created {
                 self.present(VCThanksJoinUs(), animated: true, completion: nil)
            }
        }
    }
    
    func setupTextFields() {
        let heightOfTextField : CGFloat = 45
        
        self.view.addSubviews([prenomTextfield,nomTextfield,statusTextfield,levelTextfield,codeTextfield,schoolTextField,buttonNext])
        
        NSLayoutConstraint.activate([
            prenomTextfield.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
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
            
            schoolTextField.topAnchor.constraint(equalTo: self.codeTextfield.bottomAnchor, constant: 20),
            schoolTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            schoolTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            schoolTextField.heightAnchor.constraint(equalToConstant: heightOfTextField),
            
            buttonNext.topAnchor.constraint(equalTo: self.schoolTextField.bottomAnchor, constant: 20),
            buttonNext.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            buttonNext.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 8/10),
            buttonNext.heightAnchor.constraint(equalToConstant: heightOfTextField)
            ])
        
        buttonNext.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        schoolTextField.textField.inputView = pickerViewSchools
        levelTextfield.textField.inputView = pickerViewNiveau
        statusTextfield.textField.inputView = pickerViewStatus
        
        prenomTextfield.textField.delegate = self
        nomTextfield.textField.delegate = self
        statusTextfield.textField.delegate = self
        levelTextfield.textField.delegate = self
        codeTextfield.textField.delegate = self
        schoolTextField.textField.delegate = self
        
        pickerViewStatus.dataSource = self
        pickerViewStatus.delegate = self
        pickerViewNiveau.dataSource = self
        pickerViewNiveau.delegate = self
        pickerViewSchools.dataSource = self
        pickerViewSchools.delegate = self
        
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
            if !code.isNumeric || code.count != 5 {
                textField.shake()
                self.schoolTextField.textField.text = ""
                return
            }
            School.loadSchools(cp: code, completion: { (schools) in
                self.schoolTextField.textField.text = ""
                var schoolsString : [String] = []
                for school in schools {
                    guard let name = school.name else {
                        textField.shake()
                        return
                    }
                    schoolsString.append(name)
                }
                self.schoolTextField.textField.text = schoolsString.first
                self.schools = schoolsString
            })
        }
    }
}
