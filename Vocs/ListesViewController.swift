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
    var lists : [List] = []
    var labelIndispobible = VCLabelMenu(text: "Vous n'avez aucune liste",size: 20)
    
    let headerTableView = VCHeaderListeWithButton(text: "Personelles")
    
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
        headerTableView.buttonAjouter.addTarget(self, action: #selector(handleAjouter), for: .touchUpInside)
        setupViews()
    }
    
    func envoyerListe(texte: String) {
        guard let idList = List.createList(withTitle: texte) else {return}
        self.lists.append(List(id_list: Int(idList),name: texte))
        self.labelIndispobible.removeFromSuperview()
        
        let indexPath = IndexPath(row: lists.count - 1, section: 0)
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(insertRow), userInfo: indexPath, repeats: false)
    }
    
    func chargerLesListes() {
        lists = List.loadLists()
        if (lists.count == 0){
            messageVide()
        }
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
    
    func deleteList(indexPath : IndexPath){
        lists[indexPath.row].deleteList()
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
