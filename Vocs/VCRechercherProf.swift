//
//  VCRechercherProfController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 03/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCRechercherProfController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var delegate : VCSearchClasseDelegate?
    
    let reuseIdentifier = "cellId"
    var list : List?
    
    // Stocke les differentes classes
    var users : [User] = []
    var usersFiltred : [User] = []
    
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
        self.navigationItem.title = "Partager ma liste"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleRetour))
        myTableView.canCancelContentTouches = false
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        loadUsers()
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
    
    func loadUsers() {
        //On charge tous les users
        User.loadProfessors { (users) in
            self.users = users
            self.myTableView.reloadData()
        }
    }
    
    //Si on est en recherche => On se sert de usersFiltred
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSorted ? self.usersFiltred.count : self.users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let listId = self.list?.id_list else {
            return
        }
        if isSorted {
            self.presentConfirmation(title: "Confirmation", message: "Voulez-vous partager votre liste à \(usersFiltred[indexPath.row].name!.capitalizingFirstLetter()) \(usersFiltred[indexPath.row].firstName!.uppercased()) ", handleConfirm: {
                DemandList.sharedInstance().envoyerDemand(toUserId: self.usersFiltred[indexPath.row].id!, forList: listId, completion: { (sent) -> Void in
                    if (sent) {
                        self.presentError(title: "Envoyé", message: "Le partage a bien été effectué")
                    } else {
                        self.presentError(title: "Erreur", message: "Une erreur est survenue lors de l'envoi")
                    }
                })
            })
        } else {
            self.presentConfirmation(title: "Confirmation", message: "Voulez-vous partager votre liste à \(users[indexPath.row].name!.capitalizingFirstLetter()) \(users[indexPath.row].firstName!.uppercased()) ", handleConfirm: {
                //Envoyer une liste a un professeur
                DemandList.sharedInstance().envoyerDemand(toUserId: self.users[indexPath.row].id!, forList: listId, completion: { (sent) -> Void in
                    if (sent) {
                        self.presentError(title: "Envoyé", message: "Le partage a bien été effectué")
                    } else {
                        self.presentError(title: "Erreur", message: "Une erreur est survenue lors de l'envoi")
                    }
                })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var name = ""
        var firstname = ""
        if isSorted {
            if usersFiltred[indexPath.row].name != nil  && usersFiltred[indexPath.row].firstName != nil {
                name = usersFiltred[indexPath.row].name!
                firstname = usersFiltred[indexPath.row].firstName!
            }
        } else {
            if users[indexPath.row].name != nil  && users[indexPath.row].firstName != nil {
                name = users[indexPath.row].name!
                firstname = users[indexPath.row].firstName!
            }
        }
        cell.textLabel?.text = "\(firstname.lowercased().capitalizingFirstLetter()) \(name.uppercased())"
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
            self.usersFiltred = self.users.filter({ (user) -> Bool in
                (user.firstName?.uppercased().contains(searchText.uppercased()))! || (user.name?.uppercased().contains(searchText.uppercased()))!
            })
            self.myTableView.reloadData()
        }
    }
    
    
}

