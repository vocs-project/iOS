//
//  Student.swift
//  Vocs
//
//  Created by Mathis Delaunay on 07/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class Student {
    
    var id : Int?
    var firstName : String?
    var name : String?
    var email : String?
    
    init(id: Int, firstname : String, name : String, email : String) {
        self.id = id
        self.name = name
        self.firstName = firstname
        self.email = email
    }
}
