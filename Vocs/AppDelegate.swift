//
//  AppDelegate.swift
//  Vocs
//
//  Created by Mathis Delaunay on 04/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import SQLite
import UIKit
import Foundation
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.setBackgroundImage(#imageLiteral(resourceName: "NavigationBackground").resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = UIColor(r: 40, g: 125, b: 192)
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 20) as Any]
        //GENERAL SETUPS
        //Mettre   -->   View controller-based status bar appearance      a   NO
        UIApplication.shared.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = UIColor(r: 40, g: 125, b: 192)
        
        //Modify KeyBoard color
        UITextField.appearance().keyboardAppearance = .dark
        findIfSqliteDBExists()
        window?.rootViewController = SplashViewController()
        return true
    }
    
    func scriptPourAjouterLesMots() {
        let donees = """
        NAME    < identificateur
        (to) nest    < (s’)insérer (s’emboiter)
        network    < réseau
        newsletter<    bulletin d'informations
        niche (= gap)    < créneau commercial
        node<    noeud
        noise<    bruit
        notebook    <ordinateur taille mini
        nought (GB)    <zéro
        (to) number<    numéroter
        OA (OFFICE AUTOMATION)<    bureautique
        (oblique) stroke<    barre oblique
        obsolete    < obsolète
        outdated < dépassé
        OCR (Optical Character Recognition)<    reconnaissance optique de caractères
        odd (number)    <nombre impair
        off    <éteint
        off-line    <non connecté
        (to) offset  < ( compenser ) décaler
        offset<    ( compensation ) décalage
        on    < allumé
        OOO (Out Of Order)    <hors service (HS)
        OOP (Object-Oriented Programming)<    Programmation Orientée Objet (POO)
        (to) operate    <(faire) fonctionner
        operating instructions    <mode d’emploi
        optical fiber    <fibre optique
        (to) order < commander
         an order     < commande   (→ achats)
        OS (Operating System) < système d'exploitation
        out of    <  en rupture de
        out of adjustment    <  déréglé
        outlet    < point de vente
        outlet <  point de vente
        outline    <contour (→ image)
        outline < plan
        outlook    <perspective(s) (d'avenir)
        (to) outperform <    dépasser ( être meilleur )
        (to) output     <sortir
         an output < sortie
        (to) overflow    <déborder
        an overflow <  dépassement (→ capacité)
        to overlap    < se superposer
        an overlap < superposition
        (to) overload     <surcharger
        an overload < surcharge
        (to) overrun < dépasser
         an overrun    < dépassement
        (to work) overtime    < (faire des) heures  suplémentaires
        (to) overtype <    taper par-dessus
        (to) overwrite < écraser
        ongoing (adj.)<    en cours
        PACE<    cadence
        (to) pack    <comprimer
        (software) package<    logiciel
        packaging    <conditionnement
        (to) paint<    colorier
        (to) pan    <faire un panoramique
        panel    <panneau
        parity (check)<    (contrôle de) parité
        parser    <programme d'analyse
        parsing    <analyse grammaticale
        password    <mot de passe
        (to) paste <    coller
        (to) patch < corriger
        a patch <  correctif
        (access) path    <chemin (d'accès)
        pattern    < modèle
        (to) perform<    effectuer
        peripheral    <périphérique (n.)
        (to) phase out<    supprimer petit à petit
        phrase<    expression
        pie chart    <camembert (graphique)
        (to) pinpoint    <identifier
        pipe<    tuyau
        piracy<    piratage
        pixel (= picture element)<    pixel
        """
        
        let mots = donees.components(separatedBy: "\n")
        for mot in mots {
            var motData = mot.components(separatedBy: "<")
            motData[0] = motData[0].trimmingCharacters(in: .whitespacesAndNewlines)
            motData[1] = motData[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let parameters = [
                "word" : [
                    "content" : motData[1],
                    "language" : "FR"
                ],
                "trad" : [
                    "content" : motData[0],
                    "language" : "EN"
                ]
            ]
            Alamofire.request("https://vocs.lebarillier.fr/rest/users/48/lists/89/wordTrad", method: .post, parameters : parameters).responseJSON(completionHandler: { (reponse) in
                print(reponse)
            })
        }
    }
    
    
    func findIfSqliteDBExists(){
        let docsDir     : URL       = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath      : URL       = docsDir.appendingPathComponent("Vocs.sqlite")
        let strDBPath   : String    = dbPath.path
        let fileManager : FileManager   = FileManager.default
        if !(fileManager.fileExists(atPath:strDBPath)){
            createTables()
        }
    }
    
    func createTables() {
        let query = "create table words" +
            "(" +
            "id_word integer ," +
            "french varchar(255)," +
            "english varchar(255)," +
            "primary key (id_word)" +
            ");" +
            
            "create table lists" +
            "(" +
            "id_list integer ," +
            "name varchar(255)," +
            "primary key (id_list)" +
            ");" +
            
            "create table words_lists" +
            
            "(" +
            "id_word integer," +
            "id_list integer," +
            "primary key (id_list,id_word)," +
            "foreign key (id_word) references words," +
            "foreign key (id_list) references lists" +
        ");"
        do {
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("Vocs.sqlite")
            let db = try Connection("\(fileURL)")
            try db.execute(query)
        } catch {
            print(error)
            return
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

