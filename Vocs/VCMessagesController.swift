//
//  VCMessagesController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 28/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class VCMessageController :  UITableViewController, VCDelegateDemands {
    
    var demands : [Demand] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var delegateUserChangeClass : VCUserChangeClass?
    let reuseIdentifier = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(VCMessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "Invitations"
        tableView.separatorStyle = .none
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleRetour))
        loadDemands()
    }
    
    func loadDemands() {
        let loading = VCLoadingController()
        self.present(loading, animated: true) {
            Demand.loadDemandsReceive(completion: { (demands) in
                loading.dismiss(animated: true, completion: nil)
                self.demands = demands
            })
        }
    }
    
    func loadDemandsWithoutLoading() {
        Demand.loadDemandsReceive(completion: { (demands) in
            self.demands = demands
        })
    }
    
    func updateMessages() {
        self.loadDemandsWithoutLoading()
    }
    
    @objc func handleRetour() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = VCConsultInvitationController()
        controller.demand = self.demands[indexPath.row]
        controller.delegateUserChangeClass = delegateUserChangeClass
        controller.delegateUpdateMessage  = self
        self.navigationController?.pushViewController(controller)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VCMessageCell
        let demandClicked = self.demands[indexPath.row]
        if demandClicked is DemandClasse {
            cell.objectLabel.text = "CLASSE"
            cell.objectLabel.textColor = UIColor(hex: 0x1C7FBD)
            cell.contentLabel.text = "Nouvelle demande de classe"
        } else if (demandClicked is DemandWord) {
            cell.objectLabel.text = "MOT"
            cell.objectLabel.textColor = UIColor(hex: 0x1ABC9C)
            cell.contentLabel.text = "Demande de synonyme"
        } else if (demandClicked is DemandList) {
            cell.objectLabel.text = "LISTE"
            cell.objectLabel.textColor = UIColor(hex: 0xF27171)
            cell.contentLabel.text = "Demande de partage de liste"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demands.count
    }
}
