//
//  School.swift
//  Vocs
//
//  Created by Mathis Delaunay on 02/11/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

class School {
    
    var id : Int?
    var name : String?
    
    init(id : Int, name : String) {
        self.id = id
        self.name = name
    }
    
    static func loadSchools(cp : String,completion : @escaping ([School]) -> Void) {
    
        Alamofire.request("\(Auth.URL_API)/schools/\(cp)",method: .get).responseJSON { (response) in
            guard let jsonDatas = response.result.value as? [[String : Any]] else {
                completion([])
                return
            }
            var schools : [School] = []
            for jsonData in jsonDatas {
                guard let id = jsonData["id"] as? Int, let name = jsonData["nom"] as? String else {
                    completion(schools)
                    return
                }
                schools.append(School(id: id, name: name))
            }
            completion(schools)
        }
    }
    
    
}
