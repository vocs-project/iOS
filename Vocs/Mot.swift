//
//  Mot.swift
//  Vocs
//
//  Created by Mathis Delaunay on 27/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import SQLite
import Alamofire
import AVFoundation

class Mot  {
    var content : String?
    var trads : [Mot]?
    var lang : String?
    var id : Int?
    
    init(content : String, trads: [Mot], lang : String) {
        self.content = content
        self.trads = trads
        self.lang = lang
    }
    
    init(id : Int ) {
        self.id = id
    }
    
    init(id : Int, content : String, trads: [Mot], lang : String) {
        self.id = id
        self.content = content
        self.trads = trads
        self.lang = lang
    }
    
    init(content : String, lang : String) {
        self.content = content
        self.lang = lang
    }
    
    static func deleteWord(word: Mot) {
//        do {
//            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                .appendingPathComponent("Vocs.sqlite")
//            let db = try Connection("\(fileURL)")
//            let word_id = Expression<Int>("id_word")
//            let words = Table("words")
//            let words_lists = Table("words_lists")
//            if let id_word =  word.id {
//                let word_filtered = words.filter(word_id == id_word)
//                try db.run(word_filtered.delete())
//                let words_lists_filtered = words_lists.filter(word_id == id_word)
//                try db.run(words_lists_filtered.delete())
//            }
//        }   catch {
//            print(error)
//        }
    }
    
    static func addWordToList(idList : Int,french: String, english: String) {
        
    }
}
