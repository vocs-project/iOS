//
//  VCNewCassController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 27/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCNewClassController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : AjouterClassDelegate?
    
    let labelAjouter = VCTitreLabel(text : "Ajouter une classe")
    let textFieldClassName = VCTextFieldLigneBas(placeholder: "Nom classe",alignement : .left)
    let buttonAdd = VCButtonExercice("Ajouter", color: UIColor(rgb: 0x1ABC9C))
    var liste : List?
    let codeTextfield = VCTextFieldLigneBas(placeholder: "Code postal",alignement : .left)
    let schoolTextField = VCTextFieldLigneBas(placeholder: "École",alignement : .left)
    var schoolsString : [String] = []  {
        didSet {
            self.pickerViewSchools.reloadAllComponents()
        }
    }
    var schools : [School] = []
    var pickerViewSchools = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Revenir", style: .plain, target: self, action: #selector(handleRevenir)), animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Ajouter", style: .plain, target: self, action: #selector(handleAjouter)), animated: true)
        self.view.backgroundColor = .white
        self.navigationItem.title = "Classe"
        setupViews()
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func handleAjouter() {
        guard let className = textFieldClassName.text else {
            textFieldClassName.shake()
            return
        }
        guard let _ = codeTextfield.text else {
            codeTextfield.shake()
            return
        }
        guard let school = schoolTextField.text else {
            schoolTextField.shake()
            return
        }
        guard let schoolId = findSchoolIdForName(schoolName: school) else {
            self.presentError(title: "Erreur", message: "Erreur dans les chargement des écoles")
            return
        }
        if (!(className.isEmpty)){
            delegate?.envoyerClass(name : className, schoolId : schoolId)
            dismiss(animated: true, completion: nil)
        } else {
            self.presentError(title: "Erreur", message: "Le nom de classe ne doit pas être vide")
        }
    }
    
    //rechercher l'id de la school par son nom
    func findSchoolIdForName(schoolName : String) -> Int? {
        for school in schools {
            guard let name = school.name else {
                return nil
            }
            if name == schoolName {
                return school.id
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schoolsString.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schoolsString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        schoolTextField.text = schoolsString[row]
    }
    
    func setupViews(){
        self.view.addSubview(labelAjouter)
        labelAjouter.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 30).isActive = true
        labelAjouter.heightAnchor.constraint(equalToConstant: 30).isActive = true
        labelAjouter.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        labelAjouter.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let heigthTextField :CGFloat = 30
        
        self.view.addSubview(textFieldClassName)
        textFieldClassName.topAnchor.constraint(equalTo: labelAjouter.bottomAnchor,constant : 40).isActive = true
        textFieldClassName.heightAnchor.constraint(equalToConstant: heigthTextField).isActive = true
        textFieldClassName.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier : 9 / 10).isActive = true
        textFieldClassName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubviews([codeTextfield,schoolTextField])
        codeTextfield.topAnchor.constraint(equalTo: self.textFieldClassName.bottomAnchor, constant: 30).isActive = true
        codeTextfield.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        codeTextfield.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10).isActive = true
        codeTextfield.heightAnchor.constraint(equalToConstant: heigthTextField).isActive = true
        
        schoolTextField.topAnchor.constraint(equalTo: self.codeTextfield.bottomAnchor, constant: 30).isActive = true
        schoolTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        schoolTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10).isActive = true
        schoolTextField.heightAnchor.constraint(equalToConstant: heigthTextField).isActive = true
        
        self.buttonAdd.layer.cornerRadius = 25
        
        self.view.addSubview(buttonAdd)
        buttonAdd.topAnchor.constraint(equalTo: schoolTextField.bottomAnchor,constant : 50).isActive = true
        buttonAdd.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonAdd.widthAnchor.constraint(equalTo: self.view.widthAnchor,multiplier : 9 / 10).isActive = true
        buttonAdd.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonAdd.addTarget(self, action: #selector(handleAjouter), for: .touchUpInside)
        

        schoolTextField.inputView = pickerViewSchools
        codeTextfield.delegate = self
        schoolTextField.delegate = self

        pickerViewSchools.dataSource = self
        pickerViewSchools.delegate = self
        codeTextfield.keyboardType = .decimalPad
    }
    
    @objc func handleRevenir() {
        dismiss(animated: true, completion: nil)
    }
}

extension VCNewClassController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == codeTextfield {
            guard let code = textField.text else {return}
            if !code.isNumeric || code.count != 5 {
                textField.shake()
                self.schoolTextField.text = ""
                return
            }
            School.loadSchools(cp: code, completion: { (schools) in
                self.schoolTextField.text = ""
                self.schools = schools
                var schoolsString : [String] = []
                for school in schools {
                    guard let name = school.name else {
                        textField.shake()
                        return
                    }
                    schoolsString.append(name)
                }
                self.schoolTextField.text = schoolsString.first
                self.schoolsString = schoolsString
            })
        }
    }
}
