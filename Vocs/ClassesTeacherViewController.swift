//
//  ClassesViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ClasseTeacherController: UICollectionViewController {

    let reuseIdentifierClassesCell = "classCells"
    let headerReuseIdentifier = "headerCell"
    
    let classes = ["TD 1","TD 2","TD 3","BTS Informatique","DUT Informatique"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Classe"
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Créer", style: .plain, target: self, action: #selector(handleCreate)), animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Lettre"), style: .plain, target: self, action: #selector(handleLetter))
        setupCollectionViewLayout()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(VCClassesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierClassesCell)
        self.collectionView?.register(VCHeaderClasseTeacherCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
    }
    
    func setupCollectionViewLayout() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: 35)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 60)
        collectionViewLayout.scrollDirection = .vertical
        self.collectionView?.setCollectionViewLayout(collectionViewLayout, animated: true)
    }
    
    
    //Créer une classe
    func handleCreate(){
        
    }
    
    //Voir les messages
    func handleLetter() {
        
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
        cell.label.text = classes[indexPath.row]
        return cell
    }

}
