//
//  VCSelectClasseListController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 31/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCSelectClasseListController : UITableViewController {
    
    var lists : [List] = []
    var listsClasse : [List] = []
    var group : Group?
    let reuseIdentifier = "cellId"
    let reuseIdentifierHeader = "celliDHeader"
    var delegate : VCSelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()
        self.tableView.register(VCSelectListCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(VCHeaderListeCell.self, forHeaderFooterViewReuseIdentifier: reuseIdentifierHeader)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.tableView.separatorStyle = .none
        self.navigationItem.title = "Listes"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleRetour))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Choisir", style: .plain, target: self, action: #selector(handleConfirm))
    }
    
    @objc func handleRetour() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let loading = VCLoadingController()
    @objc func handleConfirm() {
        if (group != nil) {
            self.present(loading, animated: true, completion: {
                self.group!.modifyLists(lists: self.listsClasse, completion: { (modified) in
                    if modified {
                        self.delegate?.envoyerLists(lists: self.listsClasse)
                        self.loading.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.loading.dismiss(animated: true, completion: nil)
                        self.presentError(title: "Erreur", message: "Une erreur est survenue avec la connexion")
                    }
                })
            })
        }
    }
    //Charger les listes personnelles
    func loadList() {
        guard let userId = Auth().currentUserId else {
            return
        }
        self.present(loading, animated: true, completion: {
            List.loadLists(forUserId: userId, completion: { (lists) in
                if (lists.count == 0){
                    self.messageVide()
                }
                self.lists = lists
                self.tableView.reloadData()
                self.loading.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    @objc func selectNewClass(switchView : VCSwitchInCell) {
        guard let indexPath = switchView.indexPath else {return}
        let list = self.lists[indexPath.row]
        if switchView.isOn {
            listsClasse.append(list)
        } else {
            let index = listsClasse.index(where: { (listSearched) -> Bool in
                listSearched.id_list == list.id_list
            })
            if index != nil {
                self.listsClasse.remove(at: index!)
            }
        }
    }
    
    var labelIndispobible = VCLabelMenu(text: "Vous n'avez aucune liste",size: 20)
    func messageVide() {
        self.view.addSubview(labelIndispobible)
        labelIndispobible.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant : -30).isActive = true
        labelIndispobible.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        labelIndispobible.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelIndispobible.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifierHeader) as! VCHeaderListeCell
        headerCell.textHeader = "Listes personnelles"
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cc")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VCSelectListCell
        let list = self.lists[indexPath.row]
        let isAClasseList = listsClasse.contains(where: { (listIterate) -> Bool in
            list.id_list == listIterate.id_list
        })
        cell.switchView.setOn(isAClasseList, animated: true)
        cell.switchView.addTarget(self, action: #selector(selectNewClass), for: UIControlEvents.valueChanged)
        cell.switchView.indexPath = indexPath
        cell.labelListe.text = self.lists[indexPath.row].name
        return cell
    }
}
