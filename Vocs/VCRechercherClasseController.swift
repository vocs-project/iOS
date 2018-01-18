//
//  VCRechercherClasseController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 26/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import UIKit

class VCRechercherClasseController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
 
    var delegate : VCSearchClasseDelegate?
    var delegateUserChangeClass : VCUserChangeClass?
    
    let reuseIdentifier = "cellId"
    
    // Stocke les differentes classes
    var groups : [Group] = []
    var groupsFiltred : [Group] = []
    
    var isSorted = false
    
    //Barre pour rechercher
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.returnKeyType = UIReturnKeyType.done
        sb.delegate = self
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    lazy var myTableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Chercher classe"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleRetour))
        myTableView.canCancelContentTouches = false
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        loadClasses()
        setupViews()
    }
    
    @objc func handleRetour() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupViews() {
        self.view.addSubview(searchBar)
        self.view.addSubview(myTableView)
        searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        myTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        myTableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func loadClasses() {
        //On charge toutes les listes
        Group.loadGroups { (groups) in
            self.groups = groups
            self.myTableView.reloadData()
        }
    }
    
    //Si on est en recherche => On se sert de groupsFiltred
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSorted ? self.groupsFiltred.count : self.groups.count
    }
    
    let loading = VCLoadingController()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSorted {
            self.presentConfirmation(title: "Confirmation", message: "Voulez-vous faire une demande pour rejoindre la classe : \(groupsFiltred[indexPath.row].name!)", handleConfirm: {
                self.sendDemand(group : self.groupsFiltred[indexPath.row])
            })
        } else {
            self.presentConfirmation(title: "Confirmation", message: "Voulez-vous vraiment rejoindre la classe : \(groups[indexPath.row].name!)", handleConfirm: {
                self.sendDemand(group : self.groups[indexPath.row])
            })
        }
    }
    
    func sendDemand(group : Group) {
        self.present(self.loading, animated: false, completion: {
            group.loadAllInformations(completion: { (loaded) in
                if loaded {
                    DemandClasse.sharedInstance().sendDemand(group: group, completion: { (sent) in
                        if sent {
                            self.loading.dismiss(animated: true, completion: nil)
                            self.handleRetour()
                        } else {
                            self.loading.dismiss(animated: true, completion: nil)
                            self.presentError(title: "Erreur", message: "Erreur de connexion")
                        }
                    })
                } else {
                    self.loading.dismiss(animated: true, completion: nil)
                    self.presentError(title: "Erreur", message: "Erreur de connexion")
                }
            })
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if isSorted {
            cell.textLabel?.text = groupsFiltred[indexPath.row].name
        } else {
            cell.textLabel?.text = groups[indexPath.row].name
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSorted = false
            view.endEditing(true)
            self.myTableView.reloadData()
        } else {
            isSorted = true
            //trier en fonction du nom
            self.groupsFiltred = self.groups.filter({ (group) -> Bool in
                (group.name?.uppercased().contains(searchText.uppercased()))!
            })
            self.myTableView.reloadData()
        }
    }
    
}
