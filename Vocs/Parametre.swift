//
//  Parametre.swift
//  Vocs
//
//  Created by Mathis Delaunay on 13/01/2018.
//  Copyright © 2018 Wathis. All rights reserved.
//

import Foundation

class Parametre {

    var standard = UserDefaults.standard
    static var instance : Parametre!
    let DEFAULTS_NUMBER_OF_WORDS = 10
    let defaultLangName = "English (United States)"
    let defaultLangId = "en-US"
    let NBR_MAX_MOTS = 100
    
    //Cle du parametre du UserDefault
    let KEY_LANG_PRONOUCE_ID = "KEY_LANG_PRONOUCE_ID"
    let KEY_LANG_PRONOUNCE_NAME = "KEY_LANG_PRONOUNCE_NAME"
    
    let KEY_EXERCICE_SIZE = "KEY_EXERCICE_SIZE"
    
    fileprivate init() {
        
    }
    
    //Patron singleton
    static func loadInstance() -> Parametre {
        if (instance == nil) {
            self.instance = Parametre()
        }
        return instance
    }
    
    //charge le nom de la langue
    func loadLangName() -> String {
        guard let langName = standard.string(forKey: KEY_LANG_PRONOUNCE_NAME) else {
            return defaultLangName
        }
        return langName
    }
    
    //Charge le parametre identifiant de la langue
    func loadLangId() -> String {
        guard let langId = standard.string(forKey: KEY_LANG_PRONOUCE_ID) else {
            return defaultLangId
        }
        return langId
    }
    
    //Changer identifiant et le nom de la langue
    func setLang(id : String) {
        standard.set(id, forKey: KEY_LANG_PRONOUCE_ID)
        standard.set(PrononcationMots.loadInstance().loadLangNameForCode(id: id), forKey: KEY_LANG_PRONOUNCE_NAME)
        standard.synchronize()
    }
    
    //Connaitre la taille des exercices
    func loadExcerciceSize() -> Int {
        guard let size = standard.value(forKey: KEY_EXERCICE_SIZE) as? Int else {
            return DEFAULTS_NUMBER_OF_WORDS
        }
        return size
    }
    
    //Changer la taille des exercices
    func setExerciceSize(size : Int) {
        standard.set(size, forKey: KEY_EXERCICE_SIZE)
        standard.synchronize()
    }
}
