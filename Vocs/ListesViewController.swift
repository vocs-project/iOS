//
//  ListesViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SQLite

class ListesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, AjouterUneListeDelegate {
    
    let reuseIdentifier = "listeCell"
    let reuseIdentifierHeader = "headerCell"
    
    var user : User? {
        didSet {
            self.chargerLesListes()
        }
    }
    
    var lists : [List] = []
    var listsClass : [List] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Mes listes"
        chargerLesListes()
        listesTableView.register(VCListeCell.self, forCellReuseIdentifier: reuseIdentifier)
        listesTableView.register(VCHeaderListeWithButtonCell.self, forHeaderFooterViewReuseIdentifier: reuseIdentifierHeader)
        setupViews()
        Auth().loadUserConnected { (user) in
            self.user = user
        }
    }
    
    //Permet de recevoir une liste grace au delegate
    func envoyerListe(texte: String) {
        guard let userId = self.user?.id else {
            return
        }
        List.addList(withName: texte, forUser: userId) { (id) in
            guard let idList =  id else {
                return
            }
            self.lists.append(List(id_list: Int(idList),name: texte))
            self.labelIndispobible.removeFromSuperview()
            
            let indexPath = IndexPath(row: self.lists.count - 1, section: 0)
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.insertRow), userInfo: indexPath, repeats: false)
        }
    }
    
    //Charge les listes depuis l'API
    func chargerLesListes() {
        guard let user = user, let userId = user.id else {return}
        guard let userLists = user.lists else {
            List.loadLists(forUserId: userId, completion: { (lists) in
                if (lists.count == 0){
                    self.messageVide()
                }
                self.lists = lists
            })
            return
        }
        self.lists = userLists
    }
    
    func messageVide() {
        self.view.addSubview(labelIndispobible)
        labelIndispobible.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -30).isActive = true
        labelIndispobible.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        labelIndispobible.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelIndispobible.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func handleAjouter() {
        let controller = AjouterListeViewController()
        controller.delegateAjouter = self
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }

    func setupViews() {
        
        self.view.addSubview(listesTableView)
        
        listesTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 10).isActive = true
        listesTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        listesTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10).isActive = true
        listesTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.lists.count : self.listsClass.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VCListeCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! VCListeCell
        if (indexPath.section == 0) {
            cell.setText(text: lists[indexPath.row].name!)
        }
        return cell
        
    }
    
    //Deux sections 1 => Personnelles et 2 => Classes
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    //il n'y a que deux types de listes : Personnelles ou Classes
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifierHeader) as! VCHeaderListeWithButtonCell
        if section == 0 {
            headerCell.textHeader = "Personnelles"
            headerCell.buttonAjouter.addTarget(self, action: #selector(handleAjouter), for: .touchUpInside)
        } else {
            headerCell.textHeader = "Classes"
            headerCell.buttonAjouter.removeFromSuperview()
        }
        return headerCell
    }
    
    
    func insertRow(timer : Timer) {
        listesTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = MotsViewController()
        controller.navigationItem.title = lists[indexPath.row].name!
        controller.list = lists[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Supprimer"
    }
    
    //permet de supprimer une liste quand on glisse vers la gauche
    func deleteList(indexPath : IndexPath){
        guard let idList = lists[indexPath.row].id_list,let idUser = self.user?.id else {return}
        List.deleteList(withId: idList, forUser: idUser) { (added) in
            print("Supprimé")
        }
        lists.remove(at: indexPath.row)
        if (lists.count == 0){
            messageVide()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            deleteList(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}
