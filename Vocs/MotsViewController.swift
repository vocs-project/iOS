//
//  MotsViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SQLite

class MotsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, AjouterUnMotDelegate {

    
    var mots : [ListMot] = [] {
        didSet {
            self.motsTableView.reloadData()
        }
    }
    let reuseIdentifier = "motCell"
    var list : List?
    
    lazy var motsTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Ajouter", style: .plain, target: self, action: #selector(handleAjouter)), animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Revenir", style: .plain, target: self, action: #selector(handleRevenir)), animated: true)
        self.motsTableView.register(VCMotCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.view.backgroundColor = .white
        loadWords()
        setupViews()
    }
    
    func loadWords() {
        guard let idList =  self.list?.id_list, let userId = Auth().loadUserId() else {return}
        List.loadWords(fromUserId: userId,fromListId: idList, completion: { (mots) in
            self.mots = mots
        })
    }
    
    func handleTrain() {
        
    }
    
    func handleAjouter() {
        let controller = AjouterMotViewController()
        controller.delegateMot = self
        controller.liste = list
        controller.navigationItem.title = self.navigationItem.title
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    //Ajouter un nouveau mot dans le table view
    func addNewWordToTableView(listMot : ListMot) {
        self.mots.append(listMot)
        self.motsTableView.reloadData()
//        let indexPath = IndexPath(row: self.mots.count, section: 0)
//        _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(insertRow), userInfo: indexPath, repeats: false)
    }
    
    func envoyerMot(french: String, english: String) {
        guard let currentList = self.list else {return}
        currentList.addNewWord(french: french, english: english) { (added) in
            if (added) {
                self.addNewWordToTableView(listMot: ListMot(word: Mot(content: french, lang: "FR"), trad: Mot(content: english, lang: "EN")))
            } else {
                self.presentError(title: "Problème de connexion", message: "Le mot n'a pas été ajouté suite à un problème de connexion")
            }
        }
    }
    
    func deleteMot(indexPath : IndexPath) {
        self.presentError(title: "Non disponible", message: "Cette fonction n'est pas encore disponible")
//        Mot.deleteWord(word: mots[indexPath.row])
//        mots.remove(at: indexPath.row)
    }
    
    func setupViews(){
        self.view.addSubview(motsTableView)
        
        motsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant : 10).isActive = true
        motsTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        motsTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10).isActive = true
        motsTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    func handleRevenir() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mots.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func insertRow(timer : Timer) {
        motsTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VCMotCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! VCMotCell
        var text = "Erreur chargement"
        let listMot = self.mots[indexPath.row]
        guard let word = listMot.word?.content, let trad = listMot.trad?.content else {
            cell.labelListe.text = text
            return cell
        }
        text = "\(word) - \(trad)"
        cell.labelListe.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Supprimer"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
//            deleteMot(indexPath: indexPath)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            self.presentError(title: "Non disponible", message: "Cette fonction n'est pas encore disponible")
        }
    }
}
