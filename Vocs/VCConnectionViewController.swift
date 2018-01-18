//
//  ConnexionViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 20/06/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCConnectionViewController: UIViewController, UITextFieldDelegate {
    
    let viewSeparator : UIView = {
        let view = UIView()
        view.layer.opacity = 0.58
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let labelTitleVocs = VCLabelTitleConnection(text: "Vocs", size: 70)

    let viewContainer = VCViewConnecton()
    let buttonLogin    = VCButtonLogin()
    let buttonRegister = VCButtonRegister()
    let buttonForgottenPassword = VCButtonForgottenPassword()
    let textFieldEmail = VCTextfieldLoginRegister(placeholder: "Email")
    let textFieldPassword = VCTextfieldLoginRegister(placeholder: "Mot de passe")
    let labelLoginRegister = VCLabelConnection(text: "Connexion", size: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.hideKeyboardWhenTappedAround()
        setBackgroundImage()
        self.textFieldPassword.isSecureTextEntry = true
        self.textFieldEmail.autocorrectionType = .no
        self.textFieldEmail.autocapitalizationType = .none
        self.textFieldEmail.spellCheckingType = .no
        self.textFieldEmail.delegate = self
        self.textFieldPassword.delegate = self
        buttonForgottenPassword.addTarget(self, action: #selector(handleForgot), for: .touchUpInside)
        buttonRegister.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        buttonLogin.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    let loading = VCLoadingController()
    
    @objc func handleLogin() {
        guard let email = textFieldEmail.text, let password = textFieldPassword.text else {
            return
        }
        if (textFieldEmail.checkIfNotEmpty() && textFieldPassword.checkIfNotEmpty()){
            self.present(loading, animated: false, completion: {
                Auth().loginUser(email: email, password: password, completion: { (user) in
                    self.loading.dismiss(animated: false, completion: nil)
                    guard let _ = user else {
                        self.textFieldPassword.shake()
                        self.textFieldEmail.shake()
                        return
                    }
                    self.present(TabBarController(), animated: true, completion: nil)
                })
            })
        }
    }
    
    @objc func handleRegister() {
        if (textFieldEmail.checkIfValidEmail() && textFieldPassword.checkIfNotEmpty()){
            let controller = VCRegisterInformations()
            guard let email = textFieldEmail.text, let password = textFieldPassword.text else {return}
            controller.email = email
            controller.password = password
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func handleForgot() {
        
    }
    
    //Setup different views with constraints
    func setupViews() {
        
        //Using my extension
        self.view.addSubviews([viewContainer,viewSeparator,buttonLogin,buttonRegister,buttonForgottenPassword,textFieldEmail,textFieldPassword,labelLoginRegister,labelTitleVocs])
        
        NSLayoutConstraint.activate([
            viewContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            viewContainer.heightAnchor.constraint(equalToConstant: 120),
            viewContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            viewContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            
            labelTitleVocs.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            labelTitleVocs.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            labelTitleVocs.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            labelTitleVocs.heightAnchor.constraint(equalToConstant: 60),
            
            
            viewSeparator.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            viewSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            viewSeparator.centerXAnchor.constraint(equalTo: self.viewContainer.centerXAnchor),
            viewSeparator.centerYAnchor.constraint(equalTo: self.viewContainer.centerYAnchor),
            
            buttonLogin.widthAnchor.constraint(equalToConstant: 130),
            buttonLogin.heightAnchor.constraint(equalToConstant: 45),
            buttonLogin.topAnchor.constraint(equalTo: self.viewContainer.bottomAnchor, constant : 100),
            buttonLogin.centerXAnchor.constraint(equalTo: self.viewContainer.centerXAnchor, constant : -70),
            
            buttonRegister.widthAnchor.constraint(equalToConstant: 130),
            buttonRegister.heightAnchor.constraint(equalToConstant: 45),
            buttonRegister.topAnchor.constraint(equalTo: self.viewContainer.bottomAnchor, constant : 100),
            buttonRegister.centerXAnchor.constraint(equalTo: self.viewContainer.centerXAnchor, constant : 70),
            
            buttonForgottenPassword.widthAnchor.constraint(equalToConstant: 150),
            buttonForgottenPassword.heightAnchor.constraint(equalToConstant: 40),
            buttonForgottenPassword.rightAnchor.constraint(equalTo: self.viewContainer.rightAnchor),
            buttonForgottenPassword.topAnchor.constraint(equalTo: self.viewContainer.bottomAnchor),
            
            textFieldEmail.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 80/100),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 50),
            textFieldEmail.centerXAnchor.constraint(equalTo: self.viewContainer.centerXAnchor),
            textFieldEmail.centerYAnchor.constraint(equalTo: self.viewContainer.centerYAnchor, constant : -30),
            
            textFieldPassword.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 80/100),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 50),
            textFieldPassword.centerXAnchor.constraint(equalTo: self.viewContainer.centerXAnchor),
            textFieldPassword.centerYAnchor.constraint(equalTo: self.viewContainer.centerYAnchor, constant : 30),
            
            labelLoginRegister.widthAnchor.constraint(equalTo: self.viewContainer.widthAnchor),
            labelLoginRegister.heightAnchor.constraint(equalToConstant: 40),
            labelLoginRegister.centerXAnchor.constraint(equalTo: self.viewContainer.centerXAnchor),
            labelLoginRegister.bottomAnchor.constraint(equalTo: self.viewContainer.topAnchor)
        ])
        buttonForgottenPassword.isHidden = true
    }

    //Gerer la touche return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldPassword == textField {
            textFieldPassword.becomeFirstResponder()
        } else {
            textFieldPassword.resignFirstResponder()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
