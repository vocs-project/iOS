//
//  MotsViewController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SQLite
import AVFoundation
class MotsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, AjouterUnMotDelegate {

    let reuseIdentifier = "motCell"
    let reuseIdentifierHeader = "motCellHeader"
    var list : List? {
        didSet {
            self.motsTableView.reloadData()
        }
    }
    var mustLoadWords : Bool = false
    var canShare = false {
        didSet {
            self.setupTopBar()
        }
    }
    
    var enableEditing = false {
        didSet {
            self.setupTopBar()
        }
    }
    
    lazy var motsTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupTopBar()
    }
    
    //Permet de changer les options de la top bar
    func setupTopBar() {
        if enableEditing && canShare {
            var rightBarItems =  [UIBarButtonItem(image: #imageLiteral(resourceName: "AjouterClass"), style: .plain, target: self, action: #selector(handleAjouter)),UIBarButtonItem(image : #imageLiteral(resourceName: "share"),style: .plain, target: self, action: #selector(handleShare))]
            rightBarItems[0].imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
            rightBarItems[1].imageInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
            self.navigationItem.setRightBarButtonItems(rightBarItems, animated: true)
        } else if (enableEditing && !canShare)  {
            self.navigationItem.setRightBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "AjouterClass"), style: .plain, target: self, action: #selector(handleAjouter)), animated: true)
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Revenir", style: .plain, target: self, action: #selector(handleRevenir)), animated: true)
        self.motsTableView.register(VCMotCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.motsTableView.register(VCHeaderMotCell.self, forCellReuseIdentifier: reuseIdentifierHeader)
        self.view.backgroundColor = .white
        if self.list?.words == nil {
            loadWords()
        }
        setupViews()
    }
    
    //charger les mots de la liste
    let loading = VCLoadingController()
    func loadWords() {
        guard let idList =  self.list?.id_list, let uid = Auth().currentUserId else {return}
        self.present(loading, animated: true) {
            List.loadWords(fromListId: idList,userId : uid, completion: { (mots) in
                self.list?.words = mots
                self.loading.dismiss(animated: true, completion: nil)
                self.motsTableView.reloadData()
            })
        }
    }
    
    func loadWordsWithoutLoading(){
        guard let idList =  self.list?.id_list,let uid = Auth().currentUserId  else {return}
        List.loadWords(fromListId: idList,userId : uid, completion: { (mots) in
            self.list?.words = mots
            self.motsTableView.reloadData()
        })
    }
    
    @objc func handleShare() {
        let controller = VCRechercherProfController()
        controller.list = self.list
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    @objc func handleAjouter() {
        let controller = AjouterMotViewController()
        controller.delegateMot = self
        controller.liste = list
        controller.navigationItem.title = self.navigationItem.title
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    //Ajouter un nouveau mot dans le table view
    func addNewWordToTableView(listMot : ListMot) {
        if self.list?.words != nil {
            self.list!.words!.append(listMot)
            let indexPath = IndexPath(row: self.list!.words!.count - 1, section: 0)
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(insertRow), userInfo: indexPath, repeats: false)
        }
    }
    
    func envoyerMot(french: String, english: String) {
        guard let currentList = self.list else {return}
        currentList.addNewWord(french: french.capitalizingFirstLetter(), english: english.capitalizingFirstLetter()) { (added) in
            if (added) {
                self.loadWordsWithoutLoading()
            } else {
                self.presentError(title: "Problème de connexion", message: "Le mot n'a pas été ajouté suite à un problème de connexion")
            }
        }
    }
    
    func setupViews(){
        self.view.addSubview(motsTableView)
        
        motsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant : 10).isActive = true
        motsTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        motsTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9/10).isActive = true
        motsTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    }
    
    @objc func handleRevenir() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.list?.words != nil {
            return self.list!.words!.count == 0 ? 0 : self.list!.words!.count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0  ? 80 : 45
    }
    
    @objc func insertRow(timer : Timer) {
        motsTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell:VCHeaderMotCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierHeader)! as! VCHeaderMotCell
            if list != nil {
                if list!.words != nil {
                    cell.changeProgressBar(ratioGreen: list!.getRatioColor(levelColor: .green), ratioOrange: list!.getRatioColor(levelColor: .orange), ratioRed: list!.getRatioColor(levelColor: .red))
                }
            }
            return cell
        } else {
            let cell:VCMotCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! VCMotCell
            var text = "Erreur chargement"
            if self.list?.words != nil {
                let listMot = self.list!.words![indexPath.row - 1]
                guard let word = listMot.word?.content, let trad = listMot.trad?.content else {
                    cell.labelListe.text = text
                    return cell
                }
                if let color = listMot.getLevelColor() {
                    cell.setColor(color: color)
                }
                text = "\(word.capitalizingFirstLetter()) - \(trad.capitalizingFirstLetter())"
                cell.labelListe.text = text
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if enableEditing  && indexPath.row > 0 {
            return "Supprimer"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if self.list?.words != nil {
                let listWord = self.list!.words![indexPath.row - 1]
                guard let mot = listWord.trad else {
                    return
                }
                PrononcationMots.loadInstance().prononcer(mot: mot)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if enableEditing && indexPath.row > 0 {
            if editingStyle == UITableViewCellEditingStyle.delete {
                if self.list?.words != nil {
                    let listWord = self.list!.words!.remove(at: indexPath.row - 1)
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                    self.list?.deleteWordFromList(listMot : listWord , completion: { (deleted,listWord) in
                        if !deleted {
                            self.presentError(title: "Problème de connexion", message: "Le mot n'a pas été supprimé suite à un problème de connexion")
                            self.list!.words!.append(listWord)
                            let indexPath = IndexPath(row: self.list!.words!.count - 1, section: 0)
                            self.motsTableView.insertRows(at: [indexPath], with: .automatic)
                        }
                    })
                }
            }
        }
    }
}
