//
//  User.swift
//  Vocs
//
//  Created by Mathis Delaunay on 28/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

class User {
    
    var id : Int?
    var firstName : String?
    var name : String?
    var email : String?
    var lists : [List]?
    
    init(id: Int, firstname : String, name : String, email : String) {
        self.id = id
        self.name = name
        self.firstName = firstname
        self.email = email
    }
    
    static func loadUser(userId : Int,completion : @escaping (User?) -> Void) {
        Alamofire.request("http://vocs.lebarillier.fr/rest/users/\(userId)", method: .get).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(nil)
                return
            }
            guard let id = json["id"] as? Int, let email = json["email"] as? String, let firstname = json["firstname"] as? String, let name = json["surname"] as? String else {
                completion(nil)
                return
            }
            let user = User(id: id, firstname: firstname, name: name, email: email)
            completion(user)
        }
    }
}
