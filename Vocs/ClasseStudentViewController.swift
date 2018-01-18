//
//  ClasseViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 07/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ClasseStudentController: UICollectionViewController, VCSearchClasseDelegate, VCUserChangeClass {

    let reuseIdentifierClassesCell = "classCells"
    let headerReuseIdentifier = "headerCell"
    let footerReuseIdentifier = "footerCell"
    let headerTwoReuseIdentifier = "headerTwoReuseIdentifier"
    
    var lists  : [List] = []
    var user : User?
    var group: Group? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    var delegateUserChangeClass : VCUserChangeClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Classe"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Lettre"), style: .plain, target: self, action: #selector(handleLetter))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(loadClasse))
        setupCollectionViewLayout()
        Auth().loadUserConnected { (user) in
            self.user = user
            user?.loadClasse(completion: { (group) in
                if group == nil {
                    self.group = nil
                    self.collectionView?.reloadData()
                    self.setupCollectionViewLayout()
                } else {
                    self.group = group
                    guard let groupId = group?.id else {
                        self.collectionView?.reloadData()
                        self.setupCollectionViewLayout()
                        return
                    }
                    Group.loadLists(classId: groupId, completion: { (lists) in
                        self.lists = lists
                        self.collectionView?.reloadData()
                        self.setupCollectionViewLayout()
                    })
                }
            })
        }
        loadClasse()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(VCClassesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierClassesCell)
        self.collectionView?.register(VCHeaderNoClasseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerTwoReuseIdentifier)
        self.collectionView?.register(VCHeaderClasseStudentCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        self.collectionView?.register(VCFooterClasseStudentCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDemands()
    }
    
    func loadDemands() {
        Demand.loadDemandsReceive { (demands) in
            if (demands.count > 0) {
                self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "LettreNew")
            } else {
                self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "Lettre")
            }
        }
    }
    
    func userChangedClass() {
        loadClasseWhithoutLoading()
        delegateUserChangeClass?.userChangedClass()
    }
    
    let loading = VCLoadingController()
    
    //Charger les classes sans l'effet de cahrgement
    func loadClasseWhithoutLoading() {
        self.user?.loadClasse(completion: { (group) in
            if group == nil {
                self.group = nil
                self.lists = []
                self.collectionView?.reloadData()
                self.setupCollectionViewLayout()
            } else {
                self.group = group
                guard let groupId = group?.id else {
                    self.collectionView?.reloadData()
                    self.setupCollectionViewLayout()
                    return
                }
                Group.loadLists(classId: groupId, completion: { (lists) in
                    self.lists = lists
                    self.collectionView?.reloadData()
                    self.setupCollectionViewLayout()
                })
            }
        })
    }
    
    //Charger la classe de l'élève
    @objc func loadClasse() {
        self.present(loading, animated: true, completion: {
            self.user?.loadClasse(completion: { (group) in
                if group == nil {
                    self.group = nil
                    self.lists = []
                    self.collectionView?.reloadData()
                    self.setupCollectionViewLayout()
                    self.loading.dismiss(animated: true, completion: nil)
                } else {
                    self.group = group
                    guard let groupId = group?.id else {
                        self.collectionView?.reloadData()
                        self.setupCollectionViewLayout()
                        self.loading.dismiss(animated: true, completion: nil)
                        return
                    }
                    Group.loadLists(classId: groupId, completion: { (lists) in
                        self.lists = lists
                        self.collectionView?.reloadData()
                        self.setupCollectionViewLayout()
                        self.loading.dismiss(animated: true, completion: nil)
                    })
                }
            })
        })
    }
    
    func setupCollectionViewLayout() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: 35)
        collectionViewLayout.minimumLineSpacing = 10
        if (group != nil) {
              collectionViewLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 180)
        } else {
            collectionViewLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 250)
        }
        collectionViewLayout.footerReferenceSize = CGSize(width: self.view.frame.width, height: 200)
        collectionViewLayout.scrollDirection = .vertical
        self.collectionView?.setCollectionViewLayout(collectionViewLayout, animated: true)
    }
    
    //Rejoindre une classe
    @objc func handleRejoindre(){
        let controller = VCRechercherClasseController()
        controller.delegate = self
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func envoyerClasse(group: Group) {
        self.group = group
        self.collectionView?.reloadData()
        guard let id = Auth().currentUserId else {return}
        group.addNewUser(userId: id) { (added) in
            self.loadClasse()
        }
    }
    
    //Quitter la classe
    @objc func handleQuitter() {
        self.presentConfirmation(title: "Confirmation", message: "Voulez-vous vraiment quitter votre classe", handleConfirm: {
            self.present(self.loading, animated: true, completion: {
                self.delegateUserChangeClass?.userChangedClass()
                self.lists = []
                self.group = nil
                Auth().loadUserConnected(completion: { (user) in
                    if user != nil {
                        user!.quitterLaClasse(completion: { (reussi) in
                            if reussi {
                                self.dismiss(animated: true, completion: nil)
                                self.loadClasse()
                                self.presentError(title: "Reussi", message: "Vous avez quitté votre classe")
                            } else {
                                self.loading.dismiss(animated: true, completion: nil)
                                self.loadClasse()
                                self.presentError(title: "Echec", message: "Problème de connexion")
                            }
                        })
                    } else {
                        self.loading.dismiss(animated: true, completion: nil)
                        self.loadClasse()
                    }
                })
            })
        })
    }
    
    //Voir les messages
    @objc func handleLetter() {
        let controller = VCMessageController()
        controller.delegateUserChangeClass = self
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionElementKindSectionHeader:
                if self.group == nil {
                    let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerTwoReuseIdentifier, for: indexPath) as! VCHeaderNoClasseCollectionReusableView
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! VCHeaderClasseStudentCollectionReusableView
                    cell.labelTitle.text = self.group?.name
                    cell.labelSubtitle.text = self.group?.school
                    cell.headerTitleClasse.isHidden = false
                    return cell
                }
            case UICollectionElementKindSectionFooter:
                    let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! VCFooterClasseStudentCollectionReusableView
                    if self.group == nil {
                        cell.titleButton = "Rechercher une classe"
                        cell.quitButton.removeTarget(self, action: #selector(handleQuitter), for: .touchUpInside)
                        cell.quitButton.addTarget(self, action: #selector(handleRejoindre), for: .touchUpInside)
                    } else {
                        cell.titleButton = "Quitter la classe"
                        cell.quitButton.removeTarget(self, action: #selector(handleRejoindre), for: .touchUpInside)
                        cell.quitButton.addTarget(self, action: #selector(handleQuitter), for: .touchUpInside)
                    }
                    return cell
            default:
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierClassesCell, for: indexPath) as! VCClassesCollectionViewCell
        if self.group != nil {
             cell.label.text = lists[indexPath.row].name
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = MotsViewController()
        controller.navigationItem.title = lists[indexPath.row].name!
        controller.list = lists[indexPath.row]
        controller.navigationItem.rightBarButtonItem  = nil
        self.navigationController?.pushViewController(controller, animated: true)
    }
   
}
