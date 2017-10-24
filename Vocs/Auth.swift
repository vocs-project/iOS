//
//  Authentification.swift
//  Vocs
//
//  Created by Mathis Delaunay on 28/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

class Auth {
    var currentUserId : Int? {
        get {
            return loadUserId()
        }
        set {
            
        }
    }
    
    func registerUser(firstname: String, surname : String, email: String, password : String,completion : @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "firstname" : firstname,
            "surname" : surname,
            "email" : email,
            "password" : password
        ]
        Alamofire.request("http://vocs.lebarillier.fr/rest/users", method: .post, parameters: parameters).responseJSON { (response) in
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
        Alamofire.request("http://vocs.lebarillier.fr/rest/users/authentification", method: .post, parameters: parameters).responseJSON { (response) in
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
            guard let userId = loadUserId() else {return}
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
