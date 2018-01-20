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

// List est la classe qui permet de respresenter une liste et de communiquer avec l'API

class List {
    var id_list : Int?
    var name : String?
    var words : [ListMot]?
    
    init(id_list: Int,name : String) {
        self.id_list = id_list
        self.name = name
    }
    
    
    init(name : String,words : [ListMot]) {
        self.name = name
        self.words = words
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
    
    //Permet d'obtenir le ratio du nombre de mots de niveau précisé en parametre
    func getRatioColor(levelColor : VCColorWord) -> CGFloat {
        if words != nil  {
            var i  = 0
            for word in words! {
                if word.getLevelColor() == levelColor {
                    i += 1
                }
            }
            var ratio = CGFloat(0)
            if words!.count > 0 {
                ratio = CGFloat(CGFloat(i) / CGFloat(words!.count))
            } else {
                ratio = 0
            }
            return ratio
        } else {
            return 0
        }
    }
    
    //Permet d'obtenir la hard liste de l'utilisateur courant
    static func loadCurrentHardList( completion : @escaping (List?) -> Void) {
        guard let uid = Auth().currentUserId else {
            completion(nil)
            return
        }
        Alamofire.request("\(Auth.URL_API)/users/\(uid)/hardlist", method : .get).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                return
            }
            guard let name = json["name"] as? String else {
                completion(nil)
                return
            }
            guard let wordsList = json["wordTrads"] as? [[String : Any]] else {
                completion(nil)
                return
            }
            let wordsOfList : [ListMot] = extractList(wordsList: wordsList)
            completion(List(name: name, words: wordsOfList))
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
        Alamofire.request("\(Auth.URL_API)/users/\(userId)/lists/\(listId)/wordTrad", method: .post, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any], let _ = json["id"] as? Int else {
                completion(false)
                print(response.result.value ?? "Erreur")
                return
            }
            completion(true)
        }
    }
    
    //Supprimer un mot d'une liste
    func deleteWordFromList(listMot : ListMot, completion : @escaping (Bool,ListMot) -> Void) {
        guard let idMyList = self.id_list, let wordMyId = listMot.id else {
            completion(false,listMot)
            return
        }
        Alamofire.request("\(Auth.URL_API)/lists/\(idMyList)/wordTrad/\(wordMyId)",method: .delete).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(false,listMot)
                print(response.result.value ?? "Erreur")
                return
            }
            guard let error = json["error"] as? [String : Any] else {
                completion(true,listMot)
                return
            }
            print(error)
            completion(false,listMot)
        }
    }
    
    static func extractList(wordsList : [[String : Any]]) -> [ListMot] {
        var wordsOfList : [ListMot] = []
        for wordList in wordsList {
            //Chargement du mot et de sa traduction
            guard let word = wordList["word"] as? [String : Any], let trad = wordList["trad"] as? [String : Any], let idMot = wordList["id"] as? Int, let stats = wordList["stat"] as? [String : Int] else {
                return wordsOfList
            }
            //Chargement des informations du mot
            guard let contentWord = word["content"] as? String, let langWordArray = word["language"] as? [String : String], let langWord = langWordArray["code"] , let tradsOfWord = word["trads"] as? [[String : Any]] else {
                return wordsOfList
            }
            //Chargement des informations sur la traduction
            guard let contentTrad = trad["content"] as? String, let langTradArray = trad["language"] as? [String : String], let langTrad = langTradArray["code"], let tradsOfTrad = trad["trads"] as? [[String : Any]] else {
                return wordsOfList
            }
            //Extraction des traductions de la trad
            var tradsForWord : [Mot] = []
            for trad in tradsOfWord {
                guard let content = trad["content"] as? String, let lang = trad["language"] as? [String: String], let code = lang["code"] else {
                    return wordsOfList
                }
                tradsForWord.append(Mot(content: content, lang: code))
            }
            //Extraction des traduction de la trad
            var tradsForTrad : [Mot] = []
            for trad in tradsOfTrad {
                guard let content = trad["content"] as? String , let lang = trad["language"] as? [String: String], let code = lang["code"]  else {
                    return wordsOfList
                }
                tradsForTrad.append(Mot(content: content, lang: code))
            }
            
            guard let level = stats["level"], let idStat = stats["id"], let goodRepetition = stats["goodRepetition"], let badRepetition = stats["badRepetition"] else {
                return wordsOfList
            }
            
            //Ajoute a la liste
            let finalWord = Mot(content: contentWord, trads: tradsForWord, lang: langWord)
            let finalTrad = Mot(content: contentTrad, trads: tradsForTrad,lang: langTrad)
            if langWord == "FR" {
                wordsOfList.append(ListMot(id: idMot,word: finalWord, trad: finalTrad,statIdWord : idStat,level : level, goodRepetitions : goodRepetition, badRepetitions : badRepetition))
            } else {
                wordsOfList.append(ListMot(id: idMot,word: finalTrad, trad: finalWord,statIdWord : idStat,level : level, goodRepetitions : goodRepetition, badRepetitions : badRepetition))
            }
        }
        return wordsOfList
    }
    
    //Chargement des mots d'une liste donné en parametre
    static func loadWords(fromListId idList : Int, completion : @escaping ([ListMot]) -> Void) {
        Alamofire.request("\(Auth.URL_API)/lists/\(idList)", method: .get).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion([])
                return
            }
            guard let wordsList = json["wordTrads"] as? [[String : Any]] else {
                completion([])
                return
            }
            completion(extractList(wordsList: wordsList))
        }
    }
    
    //Chargement des mots d'une liste donné en parametre
    static func loadWords(fromListId idList : Int,userId : Int, completion : @escaping ([ListMot]) -> Void) {
        Alamofire.request("\(Auth.URL_API)/users/\(userId)/lists/\(idList)", method: .get).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion([])
                return
            }
            guard let wordsList = json["wordTrads"] as? [[String : Any]] else {
                completion([])
                return
            }
            completion(extractList(wordsList: wordsList))
        }
    }
    
    //Charger les listes depuis l'API d'un user
    static func loadLists(forUserId : Int,completion : @escaping ([List]) -> Void ){
        var lists : [List] = []
        Alamofire.request("\(Auth.URL_API)/users/\(forUserId)/lists", method : .get).responseJSON { (response) in
            guard let json = response.result.value as? [[String : Any]] else {
                return
            }
            for jsonData in json {
                guard let id = jsonData["id"] as? Int, let name = jsonData["name"] as? String else { return }
                guard let wordsList = jsonData["wordTrads"] as? [[String : Any]] else {
                    completion(lists)
                    return
                }
                let wordsOfList : [ListMot] = extractList(wordsList: wordsList)
                lists.append(List(id_list: id, name: name, words: wordsOfList))
            }
            completion(lists)
        }
    }
    
    //Ajouter une nouvelle liste avec son nom
    static func addList(withName name : String,forUser id : Int,completion : @escaping (Int?) -> Void) {
        let parameters = [
            "name" : name
        ]
        Alamofire.request("\(Auth.URL_API)/users/\(id)/lists", method: .post, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(nil)
                return
            }
            if let idList = json["id"] as? Int {
                completion(idList)
            }
        }
    }
    
    //Ajouter une nouvelle liste avec son nom et ses mots
    static func addList(withName name : String,forUser id : Int, mots : [Int],completion : @escaping (Int?) -> Void) {
        let parameters = [
            "name" : name,
            "wordTrads" : mots
            ] as [String : Any]
        Alamofire.request("\(Auth.URL_API)/users/\(id)/lists", method: .post, parameters: parameters).responseJSON { (response) in
            guard let json = response.result.value as? [String : Any] else {
                completion(nil)
                return
            }
            if let idList = json["id"] as? Int {
                completion(idList)
            }
            print(json)
            completion(nil)
        }
    }
    
    //Supprimer une liste d'un utilisateur depuis son id
    static func deleteList(withId idList : Int,forUser userId : Int,completion : @escaping (Bool) -> Void){
        Alamofire.request("\(Auth.URL_API)/users/\(userId)/lists/\(idList)", method: .delete).responseJSON { (response) in
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
