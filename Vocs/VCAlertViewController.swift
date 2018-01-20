//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/12/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

public class VCAlertViewController : UIViewController {

    let container : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: -1)
        view.layer.shadowRadius = 2
        view.backgroundColor = .white
        return view
    }()
    
    var delegate : VDelegateReload?
    
    var titleText : String? {
        didSet {
            titleLabel.text = self.titleText
        }
    }
    
    var wordIncorrect : String = ""
    
    var word : ListMot? {
        didSet {
            if isWordToTranslateFrench {
                self.changeMauvaiseTraduction(word1: word!.word!.content!, word2: word!.trad!.content!)
            } else {
                self.changeMauvaiseTraduction(word1: word!.trad!.content!, word2: word!.word!.content!)
            }
        }
    }
    
    var isWordToTranslateFrench = true
    
    var contentText : String? {
        didSet {
            let attributedString = NSMutableAttributedString(string: contentText!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineSpacing = 11
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            contentLabel.attributedText = attributedString
        }
    }
    
    var titleButtonTop : String? {
        didSet {
            self.buttonTop.setTitle(titleButtonTop, for: .normal)
        }
    }
    
    var titleButtonBottom : String? {
        didSet {
            self.buttonBottom.setTitle(titleButtonBottom, for: .normal)
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Titre alerte"
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0x5E5E5E)
        label.font = UIFont(name: "Helvetica", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0x5E5E5E)
        label.font = UIFont(name: "Helvetica-Light", size: 20)
        let attributedString = NSMutableAttributedString(string: "Contenu\n se traduit par \n text view")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 11
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonBottom : UIButton = {
        let button = UIButton()
        button.setTitle("Continuer", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: 0x277CC0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Entrer un mot ..."
        tf.textColor = .black
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 10
        tf.borderColor = UIColor(hex: 0x999999)
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let buttonTop : UIButton = {
        let button = UIButton()
        button.setTitle("Signaler", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: 0x999999)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonQuit : UIButton = {
        let button = UIButton()
        button.imageForNormal = #imageLiteral(resourceName: "close")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //permet de recouvrir la vue actuelle
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
        self.view.isOpaque = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        hideKeyboardWhenTappedAround()
        buttonTop.addTarget(self, action: #selector(handleSignaler), for: .touchUpInside)
        buttonQuit.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        buttonBottom.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    //Quand l'utilisateur veut signaler un mot
    @objc func handleSignaler() {
        if (isWordToTranslateFrench) {
            if self.word?.word?.content != nil {
                changeSignaler(word: self.word!.word!.content!,trad : wordIncorrect)
            }
        } else {
            if self.word?.trad?.content != nil {
                changeSignaler(word: self.word!.trad!.content!,trad : wordIncorrect)
            }
        }
    }
    
    //Mettre l'alerte de base ( avec les deux boutons )
    func changeMauvaiseTraduction(word1: String, word2 : String) {
        self.buttonTop.isHidden = false
        self.textField.isHidden = true
        self.titleText = "\(self.wordIncorrect.capitalizingFirstLetter()) est faux !"
        self.contentText = "\(word1.capitalizingFirstLetter())\nse traduit par\n\(word2.capitalizingFirstLetter())"
        buttonBottom.removeTarget(self, action: #selector(handleValidate), for: .touchUpInside)
        buttonBottom.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    //Quand l'utilisateur veut valider pour envoie son synonyme
    @objc func handleValidate() {
        guard let fr = self.word?.word?.content, let en = self.word?.trad?.content, let synonym = self.textField.text else {
            self.handleDismiss()
            return
        }
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        //Si le mot a traduire est en francais, le synonyme est en anglais
        if isWordToTranslateFrench {
            DemandWord.sharedInstance().envoyerDemand(french: fr.capitalizingFirstLetter(), english: synonym.capitalizingFirstLetter()) { (sended) in
                self.handleDismiss()
            }
        } else {
            DemandWord.sharedInstance().envoyerDemand(french: synonym.capitalizingFirstLetter(), english: en.capitalizingFirstLetter()) { (sended) in
                self.handleDismiss()
            }
        }
    }
    
    //Permet de changer l'alerte pour entrer la tradution
    func changeSignaler(word:String,trad: String) {
        self.buttonTop.isHidden = true
        self.textField.isHidden = false
        self.titleButtonBottom = "Faire valider"
        self.titleText = "Proposition synonyme"
        self.textField.text = trad.capitalizingFirstLetter()
        self.contentText = "\(word.capitalizingFirstLetter())\npeut se traduire par :\n"
        buttonBottom.removeTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        buttonBottom.addTarget(self, action: #selector(handleValidate), for: .touchUpInside)
    }
    
    @objc func handleDismiss() {
        delegate?.reloadData()
        self.dismiss(animated: false, completion: nil)
    }
    
    fileprivate func setupViews() {
        self.view.addSubview(container)
        self.container.addSubviews([titleLabel,buttonBottom,contentLabel,buttonTop,textField,buttonQuit])
        container.setConstraintsXYWH(centerX: self.view.centerXAnchor, constantX: 0, centerY: self.view.centerYAnchor, constantY: 0, width: self.view.widthAnchor, multiplierWidth: 9/10, constantWidth: 0, height: self.view.heightAnchor, multiplierHeight: 4/10, constantHeight: 0)
        
        titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 0).isActive = true
        contentLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        contentLabel.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        contentLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        buttonQuit.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -10).isActive = true
        buttonQuit.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 10).isActive = true
        buttonQuit.widthAnchor.constraint(equalToConstant: 15).isActive = true
        buttonQuit.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        buttonBottom.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
        buttonBottom.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        buttonBottom.widthAnchor.constraint(equalTo: container.widthAnchor,multiplier: 9/10).isActive = true
        buttonBottom.heightAnchor.constraint(equalToConstant: 45).isActive = true
    
        buttonTop.bottomAnchor.constraint(equalTo: buttonBottom.topAnchor, constant: -7).isActive = true
        buttonTop.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        buttonTop.widthAnchor.constraint(equalTo: container.widthAnchor,multiplier: 9/10).isActive = true
        buttonTop.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        textField.centerYAnchor.constraint(equalTo: buttonTop.centerYAnchor).isActive = true
        textField.centerXAnchor.constraint(equalTo: buttonTop.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: buttonTop.widthAnchor,multiplier : 10/10).isActive = true
        textField.heightAnchor.constraint(equalTo: buttonTop.heightAnchor).isActive = true
        //de base, on cache le textField
        textField.isHidden = true
    }
    
}
