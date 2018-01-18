//
//  DemandWord.swift
//  Vocs
//
//  Created by Mathis Delaunay on 06/12/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

class DemandWord : Demand {
    
    var wordTrad : ListMot?
    
    init(id: Int, userSend: User, userReceive: User, wordTrad : ListMot) {
        super.init(id: id, userSend: userSend, userReveive: userReceive)
        self.wordTrad = wordTrad
    }
    
    static var demandList = DemandWord()
    
    override init() {
        super.init()
    }
    
    static func sharedInstance() -> DemandWord {
        return demandList
    }
    
    //Envoyer une demande
    func envoyerDemand(french: String, english: String,completion : @escaping (Bool) -> Void) {
        Auth().loadUserConnected { (user) in
            guard let uid = user?.id, let isProfessor = user?.isProfessor() else {
                completion(false)
                return
            }
            if isProfessor {
                //Si l'utilisateur est un professeur on l'envoie a lui même
                let parameters = [
                    "userSend" : uid,
                    "userReceive" : uid,
                    "wordTrad" :  [
                        "word" : [
                            "content" : french,
                            "language" : "FR"
                        ],
                        "trad" : [
                            "content" : english,
                            "language" : "EN"
                        ]
                    ]
                ] as [String : Any]
                super.envoyerDemand(parameters: parameters) { (sent) -> Void? in
                    completion(sent)
                }
            } else {
                //Sinon on essaye de trouver la classe de l'eleve
                user?.loadClasse(completion: { (group) in
                    //Si l'utilisateur a un prof, on envoie la correction au professeur
                    var parameters : [String : Any] = [:]
                    if (group != nil) {
                        guard let professor = group?.prof, let profUID = professor.id else {
                            return
                        }
                        parameters = [
                            "userSend" : uid,
                            "userReceive" : profUID,
                            "wordTrad" :  [
                                "word" : [
                                    "content" : french,
                                    "language" : "FR"
                                ],
                                "trad" : [
                                    "content" : english,
                                    "language" : "EN"
                                ]
                            ]
                            ] as [String : Any]
                    } else { //Sinon on l'envoie a l'admin de Vocs
                        parameters = [
                            "userSend" : uid,
                            "userReceive" : -1,
                            "wordTrad" :  [
                                "word" : [
                                    "content" : french,
                                    "language" : "FR"
                                ],
                                "trad" : [
                                    "content" : english,
                                    "language" : "EN"
                                ]
                            ]
                        ] as [String : Any]
                    }
                    super.envoyerDemand(parameters: parameters) { (sent) -> Void? in
                        completion(sent)
                    }
                })
            }
        }
    }
    
    //accepter une demande de traduction d'un mot
    override func accepterDemand(completion : @escaping (Bool) -> Void) {
        // Quand le prof est OK, tu fais un patch sur word/3 et en trad tu lui ajoute hello et tu fais un patch sur word/4 et en trad tu ajoute salut
        guard let idWord = self.wordTrad?.word?.id, let idTrad = self.wordTrad?.trad?.id, let tradsWord = self.wordTrad?.word?.trads, let tradsTrad = self.wordTrad?.trad?.trads else {
            return
        }
        var tradWordId : [Int] = []
        for tradWord in tradsWord {
            if tradWord.id != nil {
                tradWordId.append(tradWord.id!)
            }
        }
        tradWordId.append(idTrad)
        var tradTradId : [Int] = []
        for tradTrad in tradsTrad {
            if tradTrad.id != nil {
                tradTradId.append(tradTrad.id!)
            }
        }
        tradTradId.append(idWord)
        let parametersWord = [
            "trads" : tradWordId
        ]
        let parametersTrad = [
            "trads" : tradTradId
        ]
        //On patch le premier mot
        Alamofire.request("\(Auth.URL_API)/words/\(idWord)", method : .patch, parameters : parametersWord).responseJSON { (response) in
            guard let jsonData = response.result.value as? [String : Any] else {
                print(response.result.value ?? "Erreur")
                return
            }
            //Si on arrive a recuperer le code erreur, c'est qu'il y a une erreur
            guard let _ = jsonData["code"] as? Int else {
                return
            }
            print(jsonData)
        }

        //on patch le second mot
        Alamofire.request("\(Auth.URL_API)/words/\(idTrad)", method : .patch, parameters : parametersTrad).responseJSON { (response) in
            guard let jsonData = response.result.value as? [String : Any] else {
                print(response.result.value ?? "Erreur")
                return
            }
            //Si on arrive a recuperer le code erreur, c'est qu'il y a une erreur
            guard let _ = jsonData["code"] as? Int else {
                return
            }
            print(jsonData)
        }
        
        //On supprime la demande
        self.deleteDemand(completion: { (deleted) in
            completion(deleted)
        })
    }
    
}
