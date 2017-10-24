//
//  ChooseListViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 27/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SQLite

class ChoisirListeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    let reuseIdentifier = "listeCell"
    var user : User? {
        didSet {
            self.chargerLesListes()
        }
    }
    
    var lists : [List] = [] {
        didSet {
            self.checkVide()
            self.listesTableView.reloadData()
        }
    }
    var dejaCharge = false
    var gameMode : VCGameMode?
    
    let headerTableView = VCHeaderListe(text: "Choisir une liste")
    var labelIndispobible = VCLabelMenu(text: "Vous n'avez aucune liste",size: 20)
    
    lazy var listesTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        chargerLesListes()
        listesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        self.view.backgroundColor = .white
        loadTitle()
        chargerLesListes()
        listesTableView.register(VCListeCell.self, forCellReuseIdentifier: reuseIdentifier)
        setupViews()
        checkVide()
    }
    
    func loadTitle() {
        guard let gameMode = self.gameMode else {return}
        var title = ""
        switch gameMode {
            case .traduction:
                title = "Traduction"
            case .qcm:
                title = "QCM"
        }
        self.navigationItem.title = title
    }
    
    func checkVide() {
        if (self.lists.isEmpty){
            messageVide()
        } else {
            labelIndispobible.removeFromSuperview()
        }
    }
    
    //Charge les listes depuis l'API
    func chargerLesListes() {
        guard let user = user, let userId = user.id else {return}
        List.loadLists(forUserId: userId, completion: { (lists) in
            self.lists = lists
            self.loadWordsForLists()
        })
    }
    
    func loadWordsForLists() {
        guard let user = user, let userId = user.id else {return}
        for list in lists {
            if let idList = list.id_list {
                List.loadWords(fromUserId: userId,fromListId: idList, completion: { (mots) in
                    list.words = mots
                })
            }
        }
    }
    
    func setupViews() {
        
        self.view.addSubview(headerTableView)
        
        headerTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 10).isActive = true
        headerTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        headerTableView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10).isActive = true
        
        
        self.view.addSubview(listesTableView)
        
        listesTableView.topAnchor.constraint(equalTo: headerTableView.bottomAnchor, constant : 10).isActive = true
        listesTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        listesTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10).isActive = true
        listesTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    func messageVide() {
        self.view.addSubview(labelIndispobible)
        labelIndispobible.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -30).isActive = true
        labelIndispobible.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        labelIndispobible.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelIndispobible.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:VCListeCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! VCListeCell
        cell.setText(text: lists[indexPath.row].name!)
        
        return cell
        
    }
    
    func listeEstVide(indexPath : IndexPath) -> Bool {
        if lists[indexPath.row].estVide() {
            return true
        } else {
            return false
        }
    }
    
    //Il faut que le nombre de mots soit superieur a 4 pour faire un qcm
    func verifierNombreMotsPourQCM(indexPath : IndexPath) -> Bool {
        guard let words = lists[indexPath.row].words else {
            return false
        }
        return words.count > 4 ? true : false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (gameMode == .qcm) {
            if !(verifierNombreMotsPourQCM(indexPath: indexPath)) {
                let alertController = UIAlertController(title: "Problème de liste", message:
                    "\(lists[indexPath.row].name!) doit contenir au moins 4 mots pour faire le QCM", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Retour", style: UIAlertActionStyle.cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        if (!listeEstVide(indexPath: indexPath)){
            var controller : VCGameViewController!
            guard let gameMode = gameMode else {return}
            switch gameMode {
                case .traduction :
                    controller = TraductionViewController()
                case .qcm :
                    controller = VCQCMViewController()
            }
            if lists[indexPath.row].words != nil {
                controller.mots =  lists[indexPath.row].words!
            }
            controller.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            let navController = UINavigationController(rootViewController: controller)
            present(navController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Problème de liste", message:
                "\(lists[indexPath.row].name!) est vide", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Retour", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
