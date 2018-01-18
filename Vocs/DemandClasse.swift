//
//  DemandClasse.swift
//  Vocs
//
//  Created by Mathis Delaunay on 06/12/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

class DemandClasse : Demand {
    
    var classe : Group?
    static var demandClasse = DemandClasse()
    
    init(id: Int, userSend: User, userReceive: User, classe : Group) {
        super.init(id: id, userSend: userSend, userReveive: userReceive)
        self.classe = classe
    }
    
    override init() {
        super.init()
    }
    
    static func sharedInstance() -> DemandClasse {
        return demandClasse
    }
    
    override func accepterDemand(completion : @escaping (Bool) -> Void) {
        var uidEleve: Int?
        //Si fromProfessor => C'est l'eleve qui est invité
        Auth().loadUserConnected { (user) in
            //Si l'utilisateur est un professeur, on prend uid de la personne qui a envoyé
            guard let user = user else {
                completion(false)
                return
            }
            if (user.isProfessor()) {
                uidEleve = self.userSend?.id
            } else {
                uidEleve = Auth().currentUserId
            }
            
            if uidEleve == nil {
                completion(false)
                return
            }
            
            guard let classeId = self.classe?.id else {
                completion(false)
                return
            }
            let parameters = [
                "classes" : [classeId]
            ]
            self.deleteDemand { (deleted) in
                if deleted {
                    Alamofire.request("\(Auth.URL_API)/users/\(uidEleve!)", method : .patch, parameters : parameters).responseJSON { (response) in
                        guard let jsonData = response.result.value as? [String : Any] else {
                            completion(false)
                            return
                        }
                        //Si on arrive a recuperer le code erreur, c'est que la demande n'a pas été faite
                        guard let _ = jsonData["code"] as? Int else {
                            completion(true)
                            return
                        }
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    //envoyer une demande pour une classe
    func sendDemand(group : Group, completion : @escaping (Bool) -> Void) {
        guard let prof = group.prof else {
            completion(false)
            return
        }
        self.sendDemand(group: group, toUser: prof) { (sent) in
            completion(sent)
        }
    }
    
    //envoyer une demande de groupe
    func sendDemand(group : Group, toUser user :User, completion : @escaping (Bool) -> Void) {
        guard let currentUID = Auth().currentUserId, let userId = user.id,let groupId = group.id else {
            completion(false)
            return
        }
        let parameters = [
            "userSend" : currentUID,
            "userReceive" : userId,
            "classe" : groupId
        ]
        super.envoyerDemand(parameters: parameters) { (sent) -> Void? in
            completion(sent)
        }
    }
}
