//
//  Mot.swift
//  Vocs
//
//  Created by Mathis Delaunay on 27/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import SQLite

class Mot  {
    var french : String?
    var english : String?
    var id : Int?
    
    init(id : Int, french : String, english : String) {
        self.french = french
        self.english = english
        self.id = id;
    }
    init(french : String, english : String) {
        self.french = french
        self.english = english
    }
    
    static func deleteWord(word: Mot) {
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Vocs.sqlite")
            let db = try Connection("\(fileURL)")
            let word_id = Expression<Int>("id_word")
            let words = Table("words")
            let words_lists = Table("words_lists")
            if let id_word =  word.id {
                let word_filtered = words.filter(word_id == id_word)
                try db.run(word_filtered.delete())
                let words_lists_filtered = words_lists.filter(word_id == id_word)
                try db.run(words_lists_filtered.delete())
            }
        }   catch {
            print(error)
        }
    }
    
    static func loadWords(fromListId idList : Int) -> [Mot] {
        var words : [Mot] = []
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Vocs.sqlite")
            let db = try Connection("\(fileURL)")
            let word_id = Expression<Int>("id_word")
            let list_id = Expression<Int>("id_list")
            let french = Expression<String>("french")
            let english = Expression<String>("english")
            let words_lists = Table("words_lists")
            let words_table = Table("words")
            let join_words = words_table.join(JoinType.leftOuter, words_lists, on: words_table[word_id] == words_lists[word_id])
            let query = join_words.select(words_table[word_id],french,english)
                .filter(list_id == idList)
                .order(french, english)
            for word in try db.prepare(query) {
                words.append(Mot(id: word[word_id], french: word[french], english: word[english]))
            }
        } catch {
            print(error)
        }
        return words
    }
    
    static func createWord(word : Mot, inList idList: Int) {
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Vocs.sqlite")
            let db = try Connection("\(fileURL)")
            let french = Expression<String>("french")
            let english = Expression<String>("english")
            let word_id = Expression<Int>("id_word")
            let list_id = Expression<Int>("id_list")
            let words = Table("words")
            let insert = words.insert(french <- word.french!,english <- word.english!)
            var rowid = try db.run(insert)
            word.id = Int(rowid)
            let words_lists = Table("words_lists")
            rowid = try db.run(words_lists.insert(word_id <- Int(rowid), list_id <- idList))
        }   catch {
            print(error)
        }
    }
}
