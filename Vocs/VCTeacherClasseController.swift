//
//  VCTeacherClasseController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 31/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit


class VCTeacherClasseController: UICollectionViewController, UICollectionViewDelegateFlowLayout, VCSelectDelegate,VCDelegateKickUser  {
    
    let reuseIdentifierClassesCell = "classCells"
    let headerReuseIdentifier = "headerCell"
    let footerReuseIdentifier = "footerCell"
    let headerTwoReuseIdentifier = "headerTwoReuseIdentifier"
    var delegateSupprimer : VCDelegateSupprimerClasse?
    
    var lists  : [List] = []
    var user : User?
    var group: Group? {
        didSet {
            self.navigationItem.title = self.group?.name
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewLayout()
        Auth().loadUserConnected { (user) in
            self.user = user
        }
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(VCClassesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierClassesCell)
        self.collectionView?.register(VCHeaderNoClasseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerTwoReuseIdentifier)
        self.collectionView?.register(VCHeaderClasseView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        self.collectionView?.register(VCFooterClasseStudentCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
        
        loadClasse()
    }
    
    let loading = VCLoadingController()
    
    //Charger la classe de l'élève
    @objc func loadClasse() {
        guard let idClasse = self.group?.id else {return}
            Group.loadGroup(idClasse: idClasse, completion: { (group) in
                if group == nil {
                    self.group = nil
                } else {
                    self.group = group
                    if group!.lists != nil {
                        self.lists = group!.lists!
                    }
                }
                self.setupCollectionViewLayout()
                self.collectionView?.reloadData()
            })
    }
    
    func setupCollectionViewLayout() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: 35)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.scrollDirection = .vertical
        self.collectionView?.setCollectionViewLayout(collectionViewLayout, animated: true)
    }
    
    func envoyerLists(lists: [List]) {
        self.lists = lists
        self.collectionView?.reloadData()
    }
    
    //Quitter la classe
    @objc func handleSupprimerClasse() {
        guard let className = self.group?.name else {return}
        self.presentConfirmation(title: "Confirmation", message: "Voulez-vous vraiment supprimer la classe \(className)", handleConfirm: {
            self.group?.supprimerLaClasse(completion: { (group, deleted) in
                if deleted {
                    guard let id = group.id else {
                        return
                    }
                    self.delegateSupprimer?.envoyerGroup(groupId: id)
                    self.navigationController?.popViewController()
                } else {
                    self.presentError(title: "Erreur", message: "Erreur dans la suppression de la classe")
                }
            })
        })
    }
    
    //Ajouter des listes
    @objc func handleAjouter() {
        let controller = VCSelectClasseListController()
        controller.group = self.group
        controller.delegate = self
        controller.listsClasse = self.lists
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    //Voir les messages
    @objc func handleLetter() {
        let controller = VCMessageController()
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    var pasDeClasse = false
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            if (self.lists.count == 0) {
                //+ 1 pour le titre "liste de classe"
                pasDeClasse = true
                return 1
            } else {
                return self.lists.count + 1
            }
        } else {
            //Pour gérer ma classe ( une seule option + le titre )
            return 2
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            return CGSize(width: self.view.frame.width, height: 130)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: self.view.frame.width * 0.9, height: 60)
        } else {
            return CGSize(width: self.view.frame.width * 0.9, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if (section == 1) {
            return CGSize(width: self.view.frame.width, height: 200)
        } else {
            return CGSize.zero
        }
    }
    
    //Permet de gerer le header et le footer
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! VCHeaderClasseView
            cell.labelTitle.text = self.group?.name
            cell.labelSubtitle.text = self.group?.school
            return cell
        case UICollectionElementKindSectionFooter:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! VCFooterClasseStudentCollectionReusableView
            cell.titleButton = "Supprimer la classe"
            cell.quitButton.addTarget(self, action: #selector(handleSupprimerClasse), for: .touchUpInside)
            return cell
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierClassesCell, for: indexPath) as! VCClassesCollectionViewCell
        //la premiere section correspond tout simplement aux listes
        //La deuxieme correspond aux options pour gerer la classe
        if indexPath.section == 0 {
            //SECTION 1
            if (indexPath.row == 0) {
                //METTRE LE TITRE
                cell.showSectionListes()
                cell.headerListes.buttonAjouter.addTarget(self, action: #selector(handleAjouter), for: .touchUpInside)
            } else {
                cell.showNormalCell()
                cell.label.text = self.lists[indexPath.row - 1].name
            }
        } else {
            //SECTION 2
            if (indexPath.row == 0) {
                //METTRE LE TITRE
                cell.showSectionGerer()
            } else {
                cell.showNormalCell()
                cell.label.text = "Voir les élèves"
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (indexPath.row > 0) {
                let controller = MotsViewController()
                controller.navigationItem.title = lists[indexPath.row - 1].name!
                controller.list = lists[indexPath.row - 1]
                controller.canShare = true
                controller.enableEditing = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            if (indexPath.row > 0) {
                let controller = VCManageStudentsController()
                controller.navigationItem.title = self.group?.name
                controller.group = self.group
                controller.delegateUsers = self
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func kickUserFromClass(indexPath: IndexPath) {
        self.group?.users?.remove(at: indexPath.row)
    }
    
    
}
