//
//  Session.swift
//  Vocs
//
//  Created by Mathis Delaunay on 07/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class Session {
    
    var begin : Int?
    var end : Int?
    
    init (from begin : Int, to end : Int) {
        self.begin = begin
        self.end = end
    }
}
