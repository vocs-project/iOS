//
//  Authentification.swift
//  Vocs
//
//  Created by Mathis Delaunay on 28/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

/*Auth est une classe importante qui permet de laisser un utilisateur authentifier avec sa session sur l'application.
La session est sauvegardée en local pour éviter qu'il ne se reconnecte à chaque fois*/

class Auth {
    
    
    static var URL_API = "http://vocsapi.lebarillier.fr/rest"
    
    var currentUserId : Int? {
        get {
            return loadUserId()
        }
        set {
            
        }
    }
    
    func registerUser(firstname: String, surname : String, email: String, password : String, role : String, completion : @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "firstname" : firstname,
            "surname" : surname,
            "email" : email,
            "password" : password,
            "roles" : [role]
        ]
        Alamofire.request("\(Auth.URL_API)/users", method: .post, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any], let id = json["id"] as? Int  else {
                completion(false)
                return
            }
            self.setUserId(id: id)
            completion(true)
        }
    }
    
    func loginUser(email: String, password : String,completion : @escaping (User?) -> Void) {
        let parameters: [String: Any] = [
            "email" : email,
            "password" : password
        ]
        Alamofire.request("\(Auth.URL_API)/users/authentification", method: .post, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(nil)
                return
            }
            print(json)
            guard let id = json["id"] as? Int,let surname = json["surname"] as? String, let firstname = json["firstname"] as? String, let email = json["email"] as? String else {
                completion(nil)
                return
            }
            self.setUserId(id: id)
            completion(User(id: id, firstname: firstname, name: surname, email: email))
        }
    }
    
    func loadUserConnected(completion : @escaping (User?) -> Void) {
        if (userIsConnected()) {
            guard let userId = loadUserId() else {
                completion(nil)
                return
            }
            User.loadUser(userId: userId, completion: { (user) in
                completion(user)
            })
        } else {
            completion(nil)
        }
    }
    
    func setUserId(id : Int) {
        self.currentUserId = id
        UserDefaults.standard.set(id, forKey: "currentUserId")
    }
    
    func loadUserId() -> Int? {
        if let id = UserDefaults.standard.value(forKey: "currentUserId") as? Int {
            return id
        }
        return nil
    }
    
    func logout() {
        self.currentUserId = nil
        UserDefaults.standard.removeObject(forKey: "currentUserId")
    }
    
    func userIsConnected () -> Bool {
        if (Auth().currentUserId != nil) {
            return true
        } else {
            print("Pas connecté")
            return false
        }
    }
}
