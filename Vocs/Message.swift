//
//  Message.swift
//  Vocs
//
//  Created by Mathis Delaunay on 28/10/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class Message {
    
    var content : String?
    var object : MessageObject?
    var classeIdInvitation : Int?
    //UserId de la personne qui a envoyé le message
    var fromUserId : Int?
 
    init(object: MessageObject, content : String, classeIdInvitation : Int, fromUserId : Int) {
        self.object = object
        self.content = content
        self.classeIdInvitation = classeIdInvitation
        self.fromUserId = fromUserId
    }
    
    init(object: MessageObject, content : String) {
        self.object = object
        self.content = content
    }
    
    init(object: MessageObject, content : String, fromUserId: Int ) {
        self.object = object
        self.content = content
        self.fromUserId = fromUserId
    }
    
    static func loadMessage(formUserId userId : Int, completion : ([Message]) -> Void) {
    
        let messages : [Message] = [Message(object: .vocs, content: "Bienvenue sur Vocs"),Message(object: .message, content: "Bienvenue, c'est moi phiphi",fromUserId: 15),Message(object: .invitation, content: "Invitation dans la classe de l'IUT", classeIdInvitation: 1, fromUserId : 15)]
        
        completion(messages)
    }
    
}

enum MessageObject {
    
    case invitation
    case message
    case vocs
    
}
