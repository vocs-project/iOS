//
//  List.swift
//  Vocs
//
//  Created by Mathis Delaunay on 25/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation
import SQLite
import Alamofire

class List {
    var id_list : Int?
    var name : String?
    var words : [ListMot]?
    
    init(id_list: Int,name : String) {
        self.id_list = id_list
        self.name = name
    }
    
    init(id_list: Int,name : String,words : [ListMot]) {
        self.id_list = id_list
        self.name = name
        self.words = words
    }

    func estVide() -> Bool {
        if self.words != nil {
            return self.words!.count > 0 ? false : true
        } else {
            return true
        }
    }
    
    //Ajouter un mot a une liste de l'utilisateur actuellement connecté
    func addNewWord(french : String, english: String, completion : @escaping (Bool) -> Void) {
        //chargement de l'utilsateur connecté
        guard let userId = Auth().loadUserId(), let listId = self.id_list else {
            completion(false)
            return
        }
        //on charge les parametres
        let parameters = [
            "word" : [
                "content" : french,
                "language" : "FR"
            ],
            "trad" : [
                "content" : english,
                "language" : "EN"
            ]
        ]
        Alamofire.request("http://vocs.lebarillier.fr/rest/users/\(userId)/lists/\(listId)/words", method: .post, parameters: parameters).responseJSON { (response) in
            guard let _ = response.result.value as? [String : Any] else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //Chargement des mots d'une liste donné en parametre
    static func loadWords(fromUserId userId : Int,fromListId idList : Int, completion : @escaping ([ListMot]) -> Void) {
        Alamofire.request("http://vocs.lebarillier.fr/rest/users/\(userId)/lists/\(idList)", method: .get).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion([])
                return
            }
            guard let wordsList = json["words"] as? [[String : Any]] else {
                return
            }
            var wordsOfList : [ListMot] = []
            for wordList in wordsList {
                //Chargement du mot et de sa traduction
                guard let word = wordList["word"] as? [String : Any], let trad = wordList["trad"] as? [String : Any] else {return}
                //Chargement des informations du mot
                guard let contentWord = word["content"] as? String, let langWord = word["lang"] as? String, let tradsOfWord = word["trads"] as? [[String : String]] else {return}
                //Chargement des informations sur la traduction
                guard let contentTrad = trad["content"] as? String, let langTrad = trad["lang"] as? String, let tradsOfTrad = trad["trads"] as? [[String : String]] else {return}
                //Extraction des traductions de la trad
                var tradsForWord : [Mot] = []
                for trad in tradsOfWord {
                    guard let content = trad["content"], let lang = trad["lang"] else {return}
                    tradsForWord.append(Mot(content: content, lang: lang))
                }
                //Extraction des traduction de la trad
                var tradsForTrad : [Mot] = []
                for trad in tradsOfTrad {
                    guard let content = trad["content"] , let lang = trad["lang"] else {return}
                    tradsForTrad.append(Mot(content: content, lang: lang))
                }
                //Ajoute a la liste
                let finalWord = Mot(content: contentWord, trads: tradsForWord, lang: langWord)
                let finalTrad = Mot(content: contentTrad, trads: tradsForTrad,lang: langTrad)
                wordsOfList.append(ListMot(word: finalWord, trad: finalTrad))
            }
            completion(wordsOfList)
        }
    }
    
    //Charger les listes depuis l'API d'un user
    static func loadLists(forUserId : Int,completion : @escaping ([List]) -> Void ){
        var lists : [List] = []
        Alamofire.request("http://vocs.lebarillier.fr/rest/users/\(forUserId)/lists", method : .get).responseJSON { (response) in
            guard let json = response.result.value as? [[String : Any]] else {
                return
            }
            for jsonData in json {
                guard let id = jsonData["id"] as? Int, let name = jsonData["name"] as? String else { return }
                lists.append(List(id_list: id, name: name))
            }
            completion(lists)
        }
    }
    
    //Ajouter une nouvelle liste avec son nom
    static func addList(withName name : String,forUser id : Int,completion : @escaping (Int?) -> Void) {
        let parameters = [
            "name" : name
        ]
        Alamofire.request("http://vocs.lebarillier.fr/rest/users/\(id)/lists", method: .post, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(nil)
                return
            }
            if let idList = json["id"] as? Int {
                completion(idList)
            }
        }
    }
    
    //Supprimer une liste d'un utilisateur depuis son id
    static func deleteList(withId idList : Int,forUser userId : Int,completion : @escaping (Bool) -> Void){
        Alamofire.request("http://vocs.lebarillier.fr/rest/users/\(userId)/lists/\(idList)", method: .delete).responseJSON { (response) in
            guard let _ = response.result.value as? [String : Any] else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //ANCIENNEMENT POUR LA BASE DE DONNÉE EN LOCAL
    
    
    //    func loadWords() {
    //                var words : [Mot] = []
    //                do {
    //                    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    //                        .appendingPathComponent("Vocs.sqlite")
    //                    let db = try Connection("\(fileURL)")
    //                    let word_id = Expression<Int>("id_word")
    //                    let list_id = Expression<Int>("id_list")
    //                    let french = Expression<String>("french")
    //                    let english = Expression<String>("english")
    //                    let words_lists = Table("words_lists")
    //                    let words_table = Table("words")
    //                    let join_words = words_table.join(JoinType.leftOuter, words_lists, on: words_table[word_id] == words_lists[word_id])
    //                    let query = join_words.select(words_table[word_id],french,english)
    //                        .filter(list_id == idList)
    //                        .order(french, english)
    //                    for word in try db.prepare(query) {
    //                        words.append(Mot(id: word[word_id], french: word[french], english: word[english]))
    //                    }
    //                } catch {
    //                    print(error)
    //                }
    //                return words
    //    }

    
    //    func loadList() {
    //        var lists : [List] = []
    //                do {
    //                    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    //                        .appendingPathComponent("Vocs.sqlite")
    //                    let db = try Connection("\(fileURL)")
    //                    let idList = Expression<Int>("id_list")
    //                    let nameList = Expression<String>("name")
    //                    let words = Table("lists")
    //                    for list in try db.prepare(words) {
    //                        lists.append(List(id_list: list[idList],name: list[nameList]))
    //                    }
    //                }   catch {
    //                    print(error)
    //                }
    //                return lists
    //    }

    
    //
    //    func deleteList() {
    //        do {
    //            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    //                .appendingPathComponent("Vocs.sqlite")
    //            let db = try Connection("\(fileURL)")
    //            let list_id = Expression<Int>("id_list")
    //            let lists_table = Table("lists")
    //            let words_lists = Table("words_lists")
    //            if let id_list = id_list {
    //                let list_filtered = lists_table.filter(list_id == id_list)
    //                try db.run(list_filtered.delete())
    //                let words_lists_filtered = words_lists.filter(list_id == id_list)
    //                try db.run(words_lists_filtered.delete())
    //            }
    //        }   catch {
    //            print(error)
    //            return
    //        }
    //    }
    
//    static func createList(withTitle title : String) -> Int64? {
//        let rowid : Int64?
//        do {
//            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                .appendingPathComponent("Vocs.sqlite")
//            let db = try Connection("\(fileURL)")
//            let listName = Expression<String>("name")
//            let lists = Table("lists")
//            let insert = lists.insert(listName <- title)
//            rowid = try db.run(insert)
//        }   catch {
//            print(error)
//            return nil
//        }
//
//        return rowid
//    }
    
}
