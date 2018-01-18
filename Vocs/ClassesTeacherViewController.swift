//
//  ClassesViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ClasseTeacherController: UICollectionViewController, AjouterClassDelegate, VCDelegateSupprimerClasse {


    let reuseIdentifierClassesCell = "classCells"
    let headerReuseIdentifier = "headerCell"
    
    var classes : [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Classe"
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Créer", style: .plain, target: self, action: #selector(handleCreate)), animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Lettre"), style: .plain, target: self, action: #selector(handleLetter))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image : #imageLiteral(resourceName: "AjouterClass"),style: .plain, target: self, action: #selector(handleCreate))
        var rightBarItems =  [UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(loadClasses)),UIBarButtonItem(image : #imageLiteral(resourceName: "AjouterClass"),style: .plain, target: self, action: #selector(handleCreate))]
        rightBarItems[0].imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        rightBarItems[1].imageInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        self.navigationItem.setRightBarButtonItems(rightBarItems, animated: true)
        setupCollectionViewLayout()
        guard let userId = Auth().currentUserId else {return}
        User.loadClasses(userId: userId) { (groups) in
            self.classes = groups
            self.collectionView?.reloadData()
            self.loading.dismiss(animated: true, completion: nil)
        }
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(VCClassesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierClassesCell)
        self.collectionView?.register(VCHeaderClasseTeacherCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadDemands()
    }
    
    //Chargement des classes du professeur
    let loading = VCLoadingController()
    @objc func loadClasses() {
        self.present(loading, animated: true) {
            guard let userId = Auth().currentUserId else {return}
            User.loadClasses(userId: userId) { (groups) in
                self.classes = groups
                self.collectionView?.reloadData()
                self.loading.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func envoyerGroup(groupId : Int){
        guard let index = findGroupWithId(groupId : groupId) else {
            return
        }
        self.classes.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        self.collectionView?.deleteItems(at: [indexPath])
    }
    
    //Permet de chercher l'index d'un group par son id
    func findGroupWithId(groupId : Int) -> Int? {
        return self.classes.index(where: { (group) -> Bool in
            groupId == group.id
        })
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
    
    func setupCollectionViewLayout() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: 35)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 60)
        collectionViewLayout.scrollDirection = .vertical
        self.collectionView?.setCollectionViewLayout(collectionViewLayout, animated: true)
    }
    
    //Delegate pour creer une classe
    func envoyerClass(name: String, schoolId: Int) {
        guard let id = Auth().currentUserId else {return}
        Group.createNewClass(idUser: id, name: name,schoolId : schoolId) { (group) in
            if group != nil {
                self.ajouterClass(classe : group!)
            }
        }
    }
    
    //Fonction pour ajouter une classe dans le table view
    func ajouterClass(classe : Group) {
        self.classes.append(classe)
        self.collectionView?.reloadData()
    }
    
    //Créer une classe
    @objc func handleCreate(){
        let controller = VCNewClassController()
        controller.delegate = self
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    //Voir les messages
    @objc func handleLetter() {
        let controller = VCMessageController()
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.classes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierClassesCell, for: indexPath) as! VCClassesCollectionViewCell
        cell.label.text = classes[indexPath.row].name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = VCTeacherClasseController(collectionViewLayout: UICollectionViewLayout())
        controller.group = self.classes[indexPath.row]
        controller.delegateSupprimer = self
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
