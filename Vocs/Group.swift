//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 07/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class Group {
    
    var id : Int?
    var session : Session?
    var name : String?
    var study : String?
    var school : School?
    var students : [Student]?
    
    init ( id : Int, session : Session, name : String, study : String, school : School) {
        self.id = id
        self.session = session
        self.name = name
        self.study = study
        self.school = school
    }
    
}

