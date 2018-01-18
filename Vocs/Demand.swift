//
//  Demand.swift
//  Vocs
//
//  Created by Mathis Delaunay on 02/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Alamofire

class Demand {
    
    var id: Int?
    var userSend : User?
    var userReveive : User?

    init(id: Int, userSend : User, userReveive : User) {
        self.userSend = userSend
        self.userReveive = userReveive
        self.id = id
    }
    
    init() {}
    
    func refuseDemand( completion : @escaping (Bool) -> Void) {
        self.deleteDemand { (deleted) in
            completion(deleted)
        }
    }
    
    internal func envoyerDemand(parameters : [String : Any],completion : @escaping (Bool) -> Void?) {
        Alamofire.request("\(Auth.URL_API)/demands", method : .post, parameters : parameters).responseJSON { (response) in
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
    }
    
    func accepterDemand(completion : @escaping (Bool) -> Void) {
        preconditionFailure("Une demande generale ne peut pas etre acceptée")
    }
    
    func deleteDemand(completion : @escaping (Bool) -> Void) {
        guard let id = self.id else {
            completion(false)
            return
        }
        Alamofire.request("\(Auth.URL_API)/demands/\(id)", method : .delete).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(false)
                return
            }
            guard let error = json["error"] as? [String : Any] else {
                completion(true)
                return
            }
            print(error)
            completion(false)
        }
    }
    
    
    //Charge les demandes de l'utilisateur connecté
    static func loadDemandsReceive(completion : @escaping ([Demand]) -> Void) {
        guard let userId =  Auth().currentUserId else {
            completion([])
            return
        }
        Alamofire.request("\(Auth.URL_API)/demands/users/\(userId)", method : .get).responseJSON { (response) in
            guard let jsonData = response.result.value as? [String : Any] else {
                completion([])
                return
            }
            guard let demandsReceive = jsonData["demandReceive"] as? [[String : Any]] else {
                completion([])
                return
            }
            var demands : [Demand] = []
            for demandReceive in demandsReceive {
                //On charge les parametres communs
                guard let demandId = demandReceive["id"] as? Int,let userSend = demandReceive["userSend"] as? [String : Any], let idUser = userSend["id"] as? Int, let surname = userSend["surname"] as? String, let firstname = userSend["firstname"] as? String else {
                    completion(demands)
                    return
                }
                //C'est une demande de classe
                if let classeData = demandReceive["classe"] as? [String : Any] {
                    guard let idClasse = classeData["id"] as? Int ,let classeName = classeData["name"] as? String else {
                        completion(demands)
                        return
                    }
                    demands.append(DemandClasse(id: demandId, userSend: User(id: idUser, firstname: firstname, name: surname) , userReceive: User(id: userId), classe: Group(id: idClasse, name: classeName)))
                } else if let wordTrad = demandReceive["wordTrad"] as? [String : Any] {
                    //Si c'est une demande de synonyme
                    guard let idWordTrad = wordTrad["id"] as? Int ,let word = wordTrad["word"] as? [String  : Any],let trad = wordTrad["trad"] as? [String  : Any], let wordId = word["id"] as? Int, let contentWord = word["content"] as? String, let tradsWordDatas = word["trads"] as? [[String : Any]],let tradId = trad["id"] as? Int, let contentTrad = trad["content"] as? String, let tradsTradDatas = trad["trads"] as? [[String : Any]] else {
                        completion(demands)
                        return
                    }
                    var tradsWord : [Mot] = []
                    for tradWordDatas in tradsWordDatas {
                        guard let id = tradWordDatas["id"] as? Int else {
                            return
                        }
                        tradsWord.append(Mot(id: id))
                    }
                    var tradsTrad : [Mot] = []
                    for tradTradDatas in tradsTradDatas {
                        guard let id = tradTradDatas["id"] as? Int else {
                            return
                        }
                        tradsTrad.append(Mot(id: id))
                    }
                    let wordTraduction = ListMot(id: idWordTrad, word: Mot(id: wordId, content: contentWord, trads: tradsWord, lang: "FR"), trad: Mot(id: tradId, content: contentTrad, trads: tradsTrad, lang: "EN"))
                    demands.append(DemandWord(id: demandId,  userSend: User(id: idUser, firstname: firstname, name: surname) , userReceive: User(id: userId), wordTrad: wordTraduction))
                } else if let list = demandReceive["list"] as? [String : Any]  {
                    //Si c'est une demande pour partager une liste
                    guard let idList = list["id"] as? Int ,let listName = list["name"] as? String else {
                        completion(demands)
                        return
                    }
                    demands.append(DemandList(id: demandId, userSend: User(id: idUser, firstname: firstname, name: surname) , userReceive: User(id: userId), list: List(id_list: idList, name: listName)))
                } else {
                    completion(demands)
                    return
                }
            }
            completion(demands)
        }
    }
}

enum DemandType {
    case fromProfessor
    case fromStudent
}


