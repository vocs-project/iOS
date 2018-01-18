//
//  VCManageStudentsController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 01/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import SwifterSwift
import UIKit

class VCManageStudentsController : UITableViewController {
    
    var users : [User] = []
    var group : Group?
    let reuseIdentifier = "cellId"
    var delegateUsers : VCDelegateKickUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(VCMotCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "AjouterClass"), style: .plain, target: self, action: #selector(handleAjouter))
        if group?.users != nil {
            self.users = group!.users!
        }
        self.tableView.separatorStyle = .none
    }
    
    @objc func handleAjouter() {
        let controller = VCRechercherStudentController()
        controller.group = self.group
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VCMotCell
        if self.users[indexPath.row].firstName != nil && self.users[indexPath.row].name != nil {
            if users[indexPath.row].isProfessor() {
                cell.labelListe.text = "   Professeur \(self.users[indexPath.row].name!.uppercased()) \(self.users[indexPath.row].firstName!.lowercased().capitalizingFirstLetter())"
            } else {
                cell.labelListe.text = "    \(self.users[indexPath.row].name!.uppercased()) \(self.users[indexPath.row].firstName!.lowercased().capitalizingFirstLetter())"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Retirer"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.users[indexPath.row].quitterLaClasse { (left) in
            if !left {
                self.presentError(title: "Erreur", message: "Erreur de connexion pour retirer l'étudiant de la classe")
            } else {
                self.users.remove(at: indexPath.row)
                self.delegateUsers?.kickUserFromClass(indexPath : indexPath)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
