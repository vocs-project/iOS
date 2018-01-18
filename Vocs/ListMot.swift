//
//  Traduction.swift
//  Vocs
//
//  Created by Mathis Delaunay on 05/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation



class ListMot {
    
    var id : Int?
    var word : Mot?
    var trad : Mot?

    
    init(id : Int,word : Mot, trad : Mot) {
        self.word = word
        self.id = id
        self.trad = trad
    }
    init(word : Mot, trad : Mot) {
        self.word = word
        self.trad = trad
    }
    
    
    func copie() -> ListMot? {
        guard let id = self.id, let word = word, let trad = trad else {
            return nil
        }
        return ListMot(id: id, word: word, trad: trad)
    }
}
