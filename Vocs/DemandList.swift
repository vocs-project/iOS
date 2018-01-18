//
//  DemandList.swift
//  Vocs
//
//  Created by Mathis Delaunay on 06/12/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class DemandList : Demand {
    
    var list : List?
    
    
    init(id: Int, userSend: User, userReceive: User, list : List) {
        super.init(id: id, userSend: userSend, userReveive: userReceive)
        self.list = list
    }
    
    static var demandList = DemandList()
    
    override init() {
        super.init()
    }
    
    static func sharedInstance() -> DemandList {
        return demandList
    }
    
    //Envoyer une demande de partage de liste
    func envoyerDemand(toUserId : Int, forList : Int,completion : @escaping (Bool) -> Void) {
        guard let uid = Auth().currentUserId else  {
            completion(false)
            return
        }
        
        let parameters = [
            "userSend" : uid,
            "userReceive" : toUserId,
            "list" : forList
        ]
        
        super.envoyerDemand(parameters: parameters) { (sent) -> Void? in
            completion(sent)
        }
    }
    
    //accepter une demande de liste
    override func accepterDemand(completion : @escaping (Bool) -> Void?) {
        guard let userId = Auth().currentUserId , let idList = list?.id_list, let listName = list?.name else {
            return
        }
        //On doit d'abord charger tous les id des wordTrad de la liste
        List.loadWords(fromListId: idList) { (mots) in
            var motsIds : [Int] = []
            for mot in mots {
                if mot.id != nil {
                    motsIds.append(mot.id!)
                }
            }
            //On créé la liste
            List.addList(withName: listName, forUser: userId, mots: motsIds, completion: { (idList) in
                self.deleteDemand(completion: { (idList) in
                    if idList == nil {
                        completion(false)
                    } else {
                        completion(true)
                    }
                })
            })
        }
    }
    
}
