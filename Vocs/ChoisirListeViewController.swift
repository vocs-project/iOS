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
    let reuseIdentifierHeader = "listCellheader"
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
    var hardList : List? {
        didSet {
            self.checkVide()
            self.listesTableView.reloadData()
        }
    }
    var listsClass : [List] = [] {
        didSet {
            self.checkVide()
            self.listesTableView.reloadData()
        }
    }
    var dejaCharge = false
    var gameMode : VCGameMode?
    
//    let headerTableView = VCHeaderListe(text: "Choisir une liste")
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
        listesTableView.register(VCHeaderListeWithButtonCell.self, forHeaderFooterViewReuseIdentifier: reuseIdentifierHeader)
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
            case .matching:
                title = "Matching"
            case .timeAttack:
                title = "Time attack"
        }
        self.navigationItem.title = title
    }
    
    func checkVide() {
        if (self.lists.isEmpty && self.listsClass.isEmpty){
            messageVide()
        } else {
            labelIndispobible.removeFromSuperview()
        }
    }
    
    //Charge les listes depuis l'API
    func chargerLesListes() {
        guard let user = user, let userId = user.id else {return}
        guard let userLists = user.lists else {
            let loading = VCLoadingController()
            self.present(loading, animated: true, completion: {
                List.loadLists(forUserId: userId, completion: { (lists) in
                    if (lists.count == 0){
                        self.messageVide()
                    }
                    self.lists = lists
                })
                List.loadCurrentHardList(completion: { (hardList) in
                    self.hardList = hardList
                })
                user.loadClasse(completion: { (group) in
                    guard let idClasse = group?.id else {
                        loading.dismiss(animated: true, completion: nil)
                        return
                    }
                    Group.loadGroup(idClasse: idClasse, completion: { (group) in
                        if group != nil {
                            if group!.lists != nil {
                                self.listsClass = group!.lists!
                                self.checkVide()
                            }
                        }
                        loading.dismiss(animated: true, completion: nil)
                    })
                })
            })
            return
        }
        self.lists = userLists
    }
    func setupViews() {
        self.view.addSubview(listesTableView)
        
        listesTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 10).isActive = true
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
    
    func listeEstVide(indexPath : IndexPath) -> Bool {
        
        //on est dans les listes personnelles
        if indexPath.section == 0 {
            if lists[indexPath.row].estVide() {
                return true
            } else {
                return false
            }
        } else if indexPath.section == 1 {
            if listsClass[indexPath.row].estVide() {
                return true
            } else {
                return false
            }
        } else {
            if hardList != nil {
                return hardList!.estVide()
            } else {
                return true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.lists.count
        } else if section == 1 {
            return self.listsClass.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VCListeCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! VCListeCell
        if (indexPath.section == 0) {
            cell.setText(text: lists[indexPath.row].name!)
        } else if indexPath.section == 1 {
            cell.setText(text: listsClass[indexPath.row].name!)
        } else {
            cell.setText(text: "Utiliser ma hard liste")
        }
        return cell
        
    }
    
    //Deux sections 1 => Personnelles et 2 => Classes et 3 => Hard liste
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    //il n'y a que deux types de listes : Personnelles ou Classes
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifierHeader) as! VCHeaderListeWithButtonCell
        if section == 0 {
            headerCell.textHeader = "Personnelles"
        } else if section == 1 {
            headerCell.textHeader = " Classe "
        } else {
            headerCell.textHeader = "Ma hard liste"
        }
        headerCell.buttonAjouter.layer.opacity = 0
        headerCell.buttonAjouter.isEnabled = false
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var gameController : VCGameViewController!
        guard let gameMode = gameMode else {return}
        switch gameMode {
            case .traduction :
                gameController = VCTraductionViewController()
            case .qcm :
                gameController = VCQCMViewController()
            case .matching :
                gameController = VCMatchingViewController()
            case .timeAttack :
                gameController = VCTimeAttackController()
        }
        gameController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        let navController = UINavigationController(rootViewController: gameController)
        //liste de classes => Il faut charger les mots
        if indexPath.section == 1 {
            let loading = VCLoadingController()
            guard let idList =  self.listsClass[indexPath.row].id_list, let uid = Auth().currentUserId else {return}
            self.present(loading, animated: true) {
                List.loadWords(fromListId: idList,userId : uid, completion: { (mots) in
                    gameController.mots = mots
                    loading.dismiss(animated: true, completion: nil)
                    if mots.count == 0 {
                        self.presentError(title: "Problème de liste", message: "\(self.listsClass[indexPath.row].name!) est vide")
                    } else if gameMode == .qcm && mots.count < 4 {
                        self.presentError(title: "Problème de liste", message: "\(self.listsClass[indexPath.row].name!) doit comporter au moins 4 mots pour faire le QCM")
                    } else {
                        self.present(navController, animated: true, completion: nil)
                    }
                })
            }
        } else if indexPath.section == 0 { //listes personnelles les mots sont déjà chargés
            if lists[indexPath.row].words?.count == 0 {
                self.presentError(title: "Problème de liste", message: "\(lists[indexPath.row].name!) est vide")
            } else if gameMode == .qcm && (lists[indexPath.row].words?.count)! < 4 {
                self.presentError(title: "Problème de liste", message: "\(self.lists[indexPath.row].name!) doit comporter au moins 4 mots pour faire le QCM")
            } else {
                if lists[indexPath.row].words != nil {
                    gameController.mots =  lists[indexPath.row].words!
                }
                
                present(navController, animated: true, completion: nil)
            }
        } else {
            if hardList?.words?.count == 0 {
                self.presentError(title: "Problème de liste", message: "Votre hard liste est vide")
            } else if gameMode == .qcm && (hardList?.words?.count)! < 4 {
                self.presentError(title: "Problème de liste", message: "Votre hard liste doit comporter au moins 4 mots pour faire le QCM")
            } else {
                if hardList?.words != nil {
                    gameController.mots =  hardList!.words!
                }
                present(navController, animated: true, completion: nil)
            }
        }
    }
}
