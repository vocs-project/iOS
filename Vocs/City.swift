//
//  File.swift
//  Vocs
//
//  Created by Mathis Delaunay on 16/09/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import Alamofire

class City {
    
    var cityName : String?
    var codePostale : String?
    
    init(codePostale : String, cityName : String) {
        self.cityName = cityName
        self.codePostale = codePostale
    }
    
    static func loadCityFrom(code : String,completionHandler: @escaping ([String]) -> Void)  {
        if !code.isNumeric {
            return
        }
        var cities : [String] = []
        Alamofire.request("https://vicopo.selfbuild.fr/cherche/\(code)").responseJSON { (response) in
            do {
                let readableJSON = try JSONSerialization.jsonObject(with: response.data!, options:.allowFragments) as! [String: Any]
                
                let items = readableJSON["cities"] as! [[String: Any]]
                for item in items {
                    guard let name = item["city"] as? String else {return}
                    cities.append(name)
                }
                cities.sort()
                completionHandler(cities)
            }
            catch {
                print(error)
            }
        }
    
    }
}
