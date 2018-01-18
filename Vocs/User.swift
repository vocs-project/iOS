//
//  User.swift
//  Vocs
//
//  Created by Mathis Delaunay on 28/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

//Represente un utilisateur lamda : pas étudiant ni un professeur

class User {
    
    var id : Int?
    var firstName : String?
    var name : String?
    var email : String?
    var lists : [List]?
    var roles : [String]?
    
    init(id: Int, firstname : String, name : String, email : String) {
        self.id = id
        self.name = name
        self.firstName = firstname
        self.email = email
    }
    
    init(id: Int, firstname : String, name : String, roles : [String]) {
        self.id = id
        self.name = name
        self.firstName = firstname
        self.roles = roles
    }
    
    init(id: Int, firstname : String, name : String) {
        self.id = id
        self.name = name
        self.firstName = firstname
    }
    
    init(id: Int) {
        self.id = id
    }
    
    init(id: Int,roles : [String]) {
        self.id = id
        self.roles = roles
    }
    
    init(id: Int, firstname : String, name : String, email : String, roles : [String]) {
        self.id = id
        self.name = name
        self.firstName = firstname
        self.email = email
        self.roles = roles
    }
    
    //Savoir si l'user est un professeur
    func isProfessor() -> Bool {
        guard let roles = roles else {return false}
        return roles.contains("ROLE_PROFESSOR")
    }
    
    //Savoir si l'user est un élève
    func isStudent() -> Bool {
        guard let roles = roles else {return false}
        return roles.contains("ROLE_STUDENT")
    }
    
    func isUser() -> Bool {
        guard let roles = roles else {return false}
        return roles.contains("ROLE_USER") && !roles.contains("ROLE_PROFESSOR")
    }
    
    func loadClasse(completion : @escaping (Group?) -> Void){
        guard let userId = self.id else {
            completion(nil)
            return
        }
        Alamofire.request("\(Auth.URL_API)/users/\(userId)",method: .get).responseJSON { (response) in
            guard let json = response.result.value as? [String: Any] else {
                completion(nil)
                return
            }
            guard let classes = json["classes"] as? [[String : Any]], let last = classes.last, let idClasse = last["id"] as? Int else {
                completion(nil)
                return
            }
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
                group.loadAllInformations(completion: { (_) in
                    completion(group)
                })
            })
        }
    }
    
    func changePassword(newPassword : String, completion: @escaping (User?) -> Void) {
        guard let userId = self.id else {
            completion(nil)
            return
        }
        let parameters: [String: String] = [
            "password" : newPassword
        ]
        Alamofire.request("\(Auth.URL_API)/users/\(userId)", method: .patch, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any]  else {
                completion(nil)
                return
            }
            guard let id = json["id"] as? Int, let email = json["email"] as? String, let firstname = json["firstname"] as? String, let name = json["surname"] as? String, let roles = json["roles"] as? [String] else {
                completion(nil)
                return
            }
            let user = User(id: id, firstname: firstname, name: name, email: email,roles: roles)
            completion(user)
        }
    }
    
    func updateProfil(completion : @escaping (User?) -> Void) {
        guard let userId = self.id, let firstname = self.firstName, let surname = self.name, let email = self.email else {
            completion(nil)
            return
        }
        let parameters: [String: Any] = [
            "firstname" : firstname,
            "surname" : surname,
            "email" : email
        ]
        Alamofire.request("\(Auth.URL_API)/users/\(userId)", method: .patch, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any]  else {
                completion(nil)
                return
            }
            guard let id = json["id"] as? Int, let email = json["email"] as? String, let firstname = json["firstname"] as? String, let name = json["surname"] as? String, let roles = json["roles"] as? [String] else {
                completion(nil)
                return
            }
            let user = User(id: id, firstname: firstname, name: name, email: email,roles: roles)
            completion(user)
        }
    }
    
    //Charge toutes les classes
    static func loadClasses(userId: Int,completion : @escaping ([Group]) -> Void){
        var groups : [Group] = []
        Alamofire.request("\(Auth.URL_API)/users/\(userId)/classes",method: .get).responseJSON { (response) in
            guard let classes = response.result.value as? [[String: Any]] else {
                completion(groups)
                return
            }
            for classe in classes {
                guard let id = classe["id"] as? Int, let name = classe["name"] as? String, let usersData = classe["users"] as? [[String : Any]] else {
                    completion(groups)
                    return
                }
                var users: [User] = []
                for userData in usersData {
                    guard let idUser = userData["id"] as? Int, let roles = userData["roles"] as? [String] else {
                        completion(groups)
                        return
                    }
                    users.append(User(id: idUser, roles: roles))
                }
                groups.append(Group(id: id, name: name, users: users))
            }
            completion(groups)
        }
    }
    
    //Enlever un user d'une classe
    func quitterLaClasse(completion : @escaping (Bool) -> Void) {
        guard let userId = self.id else {
            completion(false)
            return
        }
        self.loadClasse { (group) in
            guard let classeId = group?.id else {
                completion(false)
                return
            }
            Alamofire.request("\(Auth.URL_API)/users/\(userId)/classes/\(classeId)", method: .delete).responseJSON { (response) in
                print(userId)
                print(classeId)
                completion(true)
            }
        }
    }
    
    static func loadUser(userId : Int,completion : @escaping (User?) -> Void) {
        Alamofire.request("\(Auth.URL_API)/users/\(userId)", method: .get).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(nil)
                return
            }
            guard let id = json["id"] as? Int, let email = json["email"] as? String, let firstname = json["firstname"] as? String, let name = json["surname"] as? String, let roles = json["roles"] as? [String] else {
                completion(nil)
                return
            }
            let user = User(id: id, firstname: firstname, name: name, email: email,roles: roles)
            completion(user)
        }
    }
    
    //Recuperer les users et les éudiants de l'API
    static func loadStudentsAndUsers(completion : @escaping ([User]) -> Void) {
        Alamofire.request("\(Auth.URL_API)/users", method: .get).responseJSON { (response) in
            guard let usersData = response.result.value as? [[String : Any]] else {
                completion([])
                return
            }
            var users : [User] = []
            for userData in usersData {
                guard let id = userData["id"] as? Int, let firstname = userData["firstname"] as? String, let name = userData["surname"] as? String, let roles = userData["roles"] as? [String] else {
                    completion(users)
                    return
                }
                let user = User(id: id, firstname: firstname, name: name, roles: roles)
                if user.isStudent() || user.isUser() {
                    users.append(user)
                }
            }
            completion(users)
        }
    }
    
    
    //Recuperer les professeurs depuis l'API
    static func loadProfessors(completion : @escaping ([User]) -> Void) {
        Alamofire.request("\(Auth.URL_API)/users", method: .get).responseJSON { (response) in
            guard let usersData = response.result.value as? [[String : Any]] else {
                completion([])
                return
            }
            var users : [User] = []
            for userData in usersData {
                guard let id = userData["id"] as? Int, let firstname = userData["firstname"] as? String, let name = userData["surname"] as? String, let roles = userData["roles"] as? [String] else {
                    completion(users)
                    return
                }
                let user = User(id: id, firstname: firstname, name: name, roles: roles)
                if user.isProfessor() {
                    users.append(user)
                }
            }
            completion(users)
        }
    }
    
}

enum Role {
    case professor
    case student
    case user
}

