//
//  List.swift
//  Vocs
//
//  Created by Mathis Delaunay on 25/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import SQLite

class List {
    var id_list : Int?
    var name : String?
    init(id_list: Int,name : String) {
        self.id_list = id_list
        self.name = name
    }
    
    func deleteList() {
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Vocs.sqlite")
            let db = try Connection("\(fileURL)")
            let list_id = Expression<Int>("id_list")
            let lists_table = Table("lists")
            let words_lists = Table("words_lists")
            if let id_list = id_list {
                let list_filtered = lists_table.filter(list_id == id_list)
                try db.run(list_filtered.delete())
                let words_lists_filtered = words_lists.filter(list_id == id_list)
                try db.run(words_lists_filtered.delete())
            }
        }   catch {
            print(error)
            return
        }
    }
    
    func estVide() -> Bool {
        guard let idList = self.id_list else {return true}
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Vocs.sqlite")
            let db = try Connection("\(fileURL)")
            let count = try db.scalar("SELECT count(*) FROM words_lists where id_list = \(idList);" ) as! Int64
            if (count == 0){
                return true
            } else {
                return false
            }
        } catch {
            print(error)
        }
        return true
    }
    
    static func loadLists() -> [List] {
        var lists : [List] = []
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Vocs.sqlite")
            let db = try Connection("\(fileURL)")
            let idList = Expression<Int>("id_list")
            let nameList = Expression<String>("name")
            let words = Table("lists")
            for list in try db.prepare(words) {
                lists.append(List(id_list: list[idList],name: list[nameList]))
            }
        }   catch {
            print(error)
        }
        return lists
    }
    
    static func createList(withTitle title : String) -> Int64? {
        let rowid : Int64?
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Vocs.sqlite")
            let db = try Connection("\(fileURL)")
            let listName = Expression<String>("name")
            let lists = Table("lists")
            let insert = lists.insert(listName <- title)
            rowid = try db.run(insert)
        }   catch {
            print(error)
            return nil
        }
        return rowid
    }
    
    static func deleteList() {
        
    }
    
}
