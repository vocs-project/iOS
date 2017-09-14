//
//  ReglagesViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ProfilViewController: UICollectionViewController {

    let reuseIdentifierClassesCell = "classCells"
    let headerReuseIdentifier = "headerCell"
    let footerReuseIdentifier = "footerCell"
    
    var account  : [List] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profil"
        setupCollectionViewLayout()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleQuit))
        loadListFromMyClasse()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(VCProfilCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierClassesCell)
        self.collectionView?.register(VCHeaderClasseStudentCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        self.collectionView?.register(VCFooterClasseStudentCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
    }
    
    func handleQuit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadListFromMyClasse() {
        self.account = List.loadLists()
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
    
    
    //Créer une classe
    func handleCreate(){
        
    }
    
    //Voir les messages
    func handleSignOut() {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.account.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! VCHeaderClasseStudentCollectionReusableView
            cell.headerTitleClasse.labelListe.text = "Mon compte"
            cell.labelTitle.text = "Mathis Delaunay"
            cell.labelSubtitle.text = "Inscrit depuis le 10/02/2016"
            return cell
        case UICollectionElementKindSectionFooter:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath) as! VCFooterClasseStudentCollectionReusableView
            cell.titleButton = "Déconnexion"
            cell.quitButton.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
            return cell
        default:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierClassesCell, for: indexPath) as! VCProfilCollectionViewCell
        cell.labelClasse.text = account[indexPath.row].name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

}
