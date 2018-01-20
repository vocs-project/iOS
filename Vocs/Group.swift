//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 07/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

//Group est la class qui represente une classe d'un professeur ( Pas class car c'est un mot clé )
class Group {
    
    var id : Int?
    var name : String?
    var users : [User]?
    var lists : [List]?
    var school : String?
    var prof : User?
    
    init ( id : Int, name : String, users : [User]) {
        self.id = id
        self.users = users
        self.name = name
        self.findProfessor()
    }
    
    init ( id : Int ,name : String) {
        self.id = id
        self.name = name
    }
    
    init ( id : Int ,name : String, users : [User], lists : [List]) {
        self.id = id
        self.name = name
        self.users = users
        self.lists = lists
        self.findProfessor()
    }
    
    func findProfessor() {
        guard let users = users else {
            return
        }
        for user in users {
            if user.isProfessor() {
                prof = user
            }
        }
    }
    
    init ( id : Int ,name : String, users : [User], lists : [List], school : String) {
        self.id = id
        self.name = name
        self.users = users
        self.lists = lists
        self.school = school
        self.findProfessor()
    }
    
    static func createNewClass(idUser : Int, name: String,schoolId : Int,completion: @escaping (Group?) -> Void){
        let parametres : [String : Any] = [
            "name" : name,
            "users" : [idUser],
            "school" : schoolId
        ]
        Alamofire.request("\(Auth.URL_API)/classes", method: .post, parameters: parametres).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(nil)
                return
            }
            guard let id = json["id"] as? Int, let name = json["name"] as? String, let usersData = json["users"]  as? [[String : Any]] else {
                completion(nil)
                return
            }
            var users: [User] = []
            for userData in usersData {
                guard let id = userData["id"] as? Int else {
                    completion(nil)
                    return
                }
                users.append(User(id: id))
            }
            let group = Group(id: id, name: name,users : users)
            guard let school = json["school"] as? [String : Any], let schoolName = school["nom"] as? String else {
                completion(group)
                return
            }
            group.school = schoolName
            completion(group)
        }
    }
    
    //recupere les autres informations du group
    func loadAllInformations(completion : @escaping (Bool) -> Void) {
        guard let id = self.id else {
            completion(false)
            return
        }
        Group.loadGroup(idClasse: id) { (group) in
            if group != nil {
                self.users = group!.users
                self.school = group!.school
                self.name = group!.name
                self.lists = group!.lists
                self.findProfessor()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    //Charge une classe avec un id
    static func loadGroup(idClasse : Int , completion : @escaping (Group?) -> Void) {
        Alamofire.request("\(Auth.URL_API)/classes/\(idClasse)",method: .get).responseJSON(completionHandler: { (responeTwo) in
            guard let jsonClasse = responeTwo.result.value as? [String : Any] else {
                completion(nil)
                return
            }
            guard let idClasse = jsonClasse["id"] as? Int, let name = jsonClasse["name"] as? String else {
                completion(nil)
                return
            }
            let group = Group(id: idClasse, name: name)
            guard  let usersData = jsonClasse["users"] as? [[String : Any]]  else {
                completion(group)
                return
            }
            var users : [User] = []
            for userData in usersData {
                guard let idUser = userData["id"] as? Int, let firsname = userData["firstname"] as? String , let surname = userData["surname"] as? String, let roles = userData["roles"] as? [String] else {
                    completion(group)
                    return
                }
                users.append(User(id: idUser, firstname: firsname, name: surname,roles : roles))
            }
            group.users = users
            guard  let listsDatas = jsonClasse["lists"] as? [[String : Any]] else {
                completion(group)
                return
            }
            var lists : [List] = []
            for listData in listsDatas {
                guard let idList = listData["id"] as? Int, let nameList = listData["name"] as? String else {
                    guard let school = jsonClasse["school"] as? [String : Any], let schoolName = school["nom"] as? String else {
                        completion(group)
                        return
                    }
                    group.school = schoolName
                    completion(group)
                    return
                }
                lists.append(List(id_list: idList, name: nameList))
            }
            group.lists = lists
            guard let school = jsonClasse["school"] as? [String : Any], let schoolName = school["nom"] as? String else {
                completion(group)
                return
            }
            group.school = schoolName
            completion(group)
        })
    }
    
    //Ajouter un user dans une classe
    func addNewUser(userId : Int, completion : @escaping (Bool) -> Void) {
        let parameters : [String : Any] = [
            "users" : [userId]
        ]
        
        guard let classId = self.id else {
            completion(false)
            return
        }
        Alamofire.request("\(Auth.URL_API)/classes/\(classId)",method : .patch, parameters : parameters).responseJSON { (response) in
            guard let _ = response.result.value as? [String : Any] else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //Charger les listes d'une classe
    static func loadLists(classId: Int,completion: @escaping ([List]) -> Void) {
        Alamofire.request("\(Auth.URL_API)/classes/\(classId)/lists",method: .get).responseJSON { (response) in
            guard let listsJson = response.result.value as? [[String : Any]] else {
                completion([])
                return
            }
            var lists : [List] = []
            for list in listsJson {
                guard let idList = list["id"] as? Int, let name = list["name"] as? String else {completion(lists);return}
                lists.append(List(id_list: idList, name: name))
            }
            completion(lists)
        }
    }
    
    //Permet de modifier les listes de la classe
    func modifyLists(lists: [List] ,completion: @escaping (Bool) -> Void) {
        guard let classeId = self.id else {
            completion(false)
            return
        }
        var listIds: [Int] = []
        for list in lists {
            guard let id = list.id_list else {
                completion(false)
                return
            }
            listIds.append(id)
        }
        let parameters = [
            "lists" : listIds
        ]
        Alamofire.request("\(Auth.URL_API)/classes/\(classeId)",method: .patch, parameters : parameters).responseJSON { (response) in
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
    
    //Supprimer la classe sur l'api
    func supprimerLaClasse(completion: @escaping (Group,Bool) -> Void) {
        guard let classeId = self.id else {
            completion(self,false)
            return
        }
        Alamofire.request("\(Auth.URL_API)/classes/\(classeId)", method: .delete).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(self,false)
                return
            }
            guard let _ = json["error"] as? [String : Any] else {
                completion(self,true)
                return
            }
            completion(self,false)
        }
    }
    
    func loadUsers(completion: @escaping ([User]) -> Void) {
//        guard let idClasse = self.id else {
//            completion([])
//            return
//        }
//        Alamofire.request("http://vocs.lebarillier.fr/rest/classes/\(idClasse)",method : .get)
    }
    
    //Charge toutes les classes disponibles
    static func loadGroups(completion: @escaping ([Group]) -> Void) {
        Alamofire.request("\(Auth.URL_API)/classes",method: .get).responseJSON { (response) in
            guard let classes = response.result.value as? [[String : Any]] else {
                completion([])
                return
            }
            var groups : [Group] = []
            for classe in classes {
                guard let idClasse = classe["id"] as? Int, let name = classe["name"] as? String else {
                    completion(groups)
                    return
                }
                groups.append(Group(id: idClasse, name: name ))
             }
             completion(groups)
        }
    }
    
    
}

