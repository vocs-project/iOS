//
//  PrononciationMots.swift
//  Vocs
//
//  Created by Mathis Delaunay on 12/01/2018.
//  Copyright © 2018 Wathis. All rights reserved.
//

import AVFoundation

class PrononcationMots {
    
    let synth = AVSpeechSynthesizer()
    let parametres = Parametre.loadInstance()
    static var sharedInstance : PrononcationMots!
    
    
    fileprivate init () {
        //Constructeur privé
        chargerLesLanguages()
    }
    
    //Acceder au singleton
    static func loadInstance() -> PrononcationMots {
        if  sharedInstance == nil {
            sharedInstance = PrononcationMots()
        }
        return sharedInstance
    }
    
    //Prononcer un mot
    func prononcer(mot : Mot) {
        guard let content = mot.content else {
            return
        }
        prononcer(expression : content)
    }
    
    //Prononcer une phrase avec une langue précisée
    func prononcer(expression : String, codeLangue : String) {
        if !synth.isSpeaking {
            let utterance = AVSpeechUtterance(string: expression)
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
            utterance.voice = AVSpeechSynthesisVoice(language: codeLangue)
            synth.speak(utterance)
        }
    }
    
    //Prononcer une phrase avec la langue par défault
    func prononcer(expression : String) {
        let defaults = UserDefaults.standard
        var lang = Parametre.loadInstance().defaultLangId
        //On charge la langue dans les parametres
        if let langUserDefault = defaults.string(forKey: parametres.KEY_LANG_PRONOUCE_ID) {
            lang = langUserDefault
        }
        prononcer(expression: expression, codeLangue: lang)
    }
    
    
    var voicesLanguages: [Dictionary<String, String?>] = []
    
    //Permet d'obtenir le nom d'un id de langue
    func loadLangNameForCode(id : String) -> String {
        let locale = NSLocale(localeIdentifier: id)
        guard let languageName = locale.displayName(forKey: NSLocale.Key.identifier, value: id) else {
            return ""
        }
        return languageName
    }
    
    
    //Permet de ne garder que les langues dont le code est précisé ( Ex : en, fr ... )
    func chargerLangues(code : String) {
        voicesLanguages = []
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            let voiceLanguageCode = (voice as AVSpeechSynthesisVoice).language
            let voiceLanguageVoiceName = (voice as AVSpeechSynthesisVoice).name
            if (voiceLanguageCode.contains("\(code.lowercased())-")) {
                let dictionary = ["languageName": "\(loadLangNameForCode(id: voiceLanguageCode))", "languageCode": voiceLanguageCode,"languagePerson" : voiceLanguageVoiceName]
                voicesLanguages.append(dictionary)
            }
        }
    }
    
    
    func chargerLesLanguages() {
        voicesLanguages = []
        //On charches les voix disponibles
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            let voiceLanguageCode = (voice as AVSpeechSynthesisVoice).language
            let dictionary = ["languageName": loadLangNameForCode(id: voiceLanguageCode), "languageCode": voiceLanguageCode]
            voicesLanguages.append(dictionary)
        }
    }
}
