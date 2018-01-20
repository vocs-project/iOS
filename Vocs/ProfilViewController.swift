//
//  ReglagesViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ProfilViewController: UICollectionViewController , VDelegateReload {
    
    let reuseIdentifierClassesCell = "classCells"
    let headerReuseIdentifier = "headerCell"
    let footerReuseIdentifier = "footerCell"
    
    var currentUser : User? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var group : Group? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var accoutInformations  : [VCProfilCategory] = []
    var pronociationMot : PrononcationMots!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profil"
        setupCollectionViewLayout()
        loadInformationsTypes()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleQuit))
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(VCProfilCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierClassesCell)
        self.collectionView?.register(VCHeaderClasseStudentCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        self.collectionView?.register(VCFooterClasseStudentCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
        if pronociationMot == nil {
            pronociationMot = PrononcationMots.loadInstance()
        }
        langName = Parametre.loadInstance().loadLangName()
    }
    
    //Langue de base
    var langName : String = "" {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    func loadInformationsTypes() {
        if (currentUser != nil ){
            accoutInformations = [.firstname,.name,.password,.email,.role,.languagesPronounciation,.exerciceSize]
        }
    }
    
    var exerciceSize = Parametre.loadInstance().loadExcerciceSize() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    func reloadData() {
        Auth().loadUserConnected { (user) in
            self.currentUser = user
        }
        langName = Parametre.loadInstance().loadLangName()
        exerciceSize = Parametre.loadInstance().loadExcerciceSize()
    }
    
    @objc func handleQuit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupCollectionViewLayout() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: 35)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 250)
        collectionViewLayout.footerReferenceSize = CGSize(width: self.view.frame.width, height: 200)
        collectionViewLayout.scrollDirection = .vertical
        self.collectionView?.setCollectionViewLayout(collectionViewLayout, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accoutInformations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! VCHeaderClasseStudentCollectionReusableView
            cell.headerTitleClasse.labelListe.text = "Mon compte"
            if currentUser?.firstName != nil && currentUser?.name != nil {
                cell.labelTitle.text = "\(currentUser!.firstName!) \(currentUser!.name!)"
            }
            cell.labelSubtitle.text = ""
            return cell
        case UICollectionElementKindSectionFooter:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! VCFooterClasseStudentCollectionReusableView
            cell.titleButton = "Déconnexion"
            cell.quitButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
            return cell
        default:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath)
            return cell
        }
    }
    
    @objc func handleLogout() {
        Auth().logout()
        self.present(VCConnectionViewController(), animated: true, completion: nil)
    }
    
    @objc func handleEdit(_ button : UITapGestureRecognizer) {
        guard let view =  button.view, let cell = view.superview as? VCProfilCollectionViewCell,let indexPath = self.collectionView?.indexPath(for: cell) else {
            return
        }
        let controller = VCChangeProfilController()
        controller.accountInformationType = self.accoutInformations[indexPath.row]
        controller.currentUser = currentUser
        controller.delegate = self
        let alert = UIAlertController(title: "Verifier votre identité", message: "Pour modifier votre profil, vous devez saisir votre mot de passe", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Mot de passe"
            textField.isSecureTextEntry = true
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let password = alert.textFields?.first?.text {
                if self.currentUser?.email != nil {
                    Auth().loginUser(email: self.currentUser!.email!, password: password, completion: { (user) in
                        if user != nil {
                            self.navigationController?.pushViewController(controller)
                        } else {
                            self.present(alert, animated: true)
                        }
                    })
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    @objc func changeLangue() {
        let controller = VCChangeLangueController()
        controller.delegate = self
        self.navigationController?.pushViewController(controller)
    }
    
    @objc func changeExerciceSize() {
        let controller = VCSelectNumberWord()
        controller.delegate = self
        self.navigationController?.pushViewController(controller)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierClassesCell, for: indexPath) as! VCProfilCollectionViewCell
        switch accoutInformations[indexPath.row] {
        case .email:
            cell.label.text = self.currentUser?.email
            cell.imageEdit.isUserInteractionEnabled = true
            cell.imageEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEdit(_:))))
            cell.imageEdit.isHidden = false
            break
        case .city:
            cell.label.text = "TO DO Ville"
            cell.imageEdit.isUserInteractionEnabled = true
            cell.imageEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEdit(_:))))
            cell.imageEdit.isHidden = false
            break
        case .password:
            cell.label.text = "••••••"
            cell.imageEdit.isUserInteractionEnabled = true
            cell.imageEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEdit(_:))))
            cell.imageEdit.isHidden = false
            break
        case .name:
            cell.label.text = self.currentUser?.name
            cell.imageEdit.isUserInteractionEnabled = true
            cell.imageEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEdit(_:))))
            cell.imageEdit.isHidden = false
            break
        case .firstname:
            cell.label.text = self.currentUser?.firstName
            cell.imageEdit.isUserInteractionEnabled = true
            cell.imageEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEdit(_:))))
            cell.imageEdit.isHidden = false
            break
        case .exerciceSize:
            cell.label.text = "Taille des exercices : \(exerciceSize)"
            cell.imageEdit.isUserInteractionEnabled = true
            cell.imageEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeExerciceSize)))
            cell.imageEdit.isHidden = false
            break
        case .role:
            if let user = self.currentUser {
                if (user.isProfessor()) {
                    cell.label.text = "Compte professeur"
                } else if (user.isStudent()) {
                    cell.label.text = "Compte étudiant"
                } else {
                    cell.label.text = "Compte libre"
                }
                cell.imageEdit.isHidden = true
            }
            break
        case .languagesPronounciation:
            cell.label.text = langName
            cell.imageEdit.isUserInteractionEnabled = true
            cell.imageEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeLangue)))
            cell.imageEdit.isHidden = false
            break
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

enum VCProfilCategory {
    case email
    case city
    case name
    case firstname
    case password
    case role
    case languagesPronounciation
    case exerciceSize
}





