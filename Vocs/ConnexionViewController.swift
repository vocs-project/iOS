//
//  ConnexionViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 20/06/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ConnexionViewController: UIViewController {
    
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.opacity = 0.58
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewSeparator : UIView = {
        let view = UIView()
        view.layer.opacity = 0.58
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonLogin    = VCButtonLogin()
    let buttonRegister = VCButtonRegister()
    let buttonForgottenPassword = VCButtonForgottenPassword()
    
    @IBOutlet weak var labelVocs: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(viewContainer)
        self.view.addSubview(viewSeparator)
        self.view.addSubview(buttonLogin)
        self.view.addSubview(buttonRegister)
        self.view.addSubview(buttonForgottenPassword)
        
        NSLayoutConstraint.activate([
            viewContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10),
            viewContainer.heightAnchor.constraint(equalToConstant: 120),
            viewContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            viewContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20),
            
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
            buttonForgottenPassword.topAnchor.constraint(equalTo: self.viewContainer.bottomAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
