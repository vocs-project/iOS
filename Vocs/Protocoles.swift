//
//  Protocoles.swift
//  Vocs
//
//  Created by Mathis Delaunay on 14/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

protocol AjouterUnMotDelegate {
    func envoyerMot(french :  String, english : String)
}
protocol AjouterUneListeDelegate {
    func envoyerListe(texte : String)
}
protocol VCSearchClasseDelegate {
    func envoyerClasse(group : Group)
}
protocol AjouterClassDelegate {
    func envoyerClass(name : String, schoolId : Int)
}
protocol VCDelegateSupprimerClasse {
    func envoyerGroup(groupId : Int)
}
protocol VCSelectDelegate {
    func envoyerLists(lists: [List])
}
protocol VDelegateReload {
    func reloadData()
}
protocol VCUserChangeClass {
    func userChangedClass()
}
protocol VCDelegateKickUser {
    func kickUserFromClass(indexPath : IndexPath)
}
protocol VCDelegateSupprimer {
    func classeSupprimee()
}
protocol VCDelegateDemands {
    func updateMessages()
}
