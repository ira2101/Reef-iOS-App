//
//  ReefBubbleFlag.swift
//  Reef
//
//  Created by Ira Einbinder on 1/26/23.
//

import Foundation
import RealmSwift

class ReefBubbleFlag : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id : ObjectId = ObjectId.generate();
    @Persisted var bubbleID: ObjectId
    @Persisted var userID : ObjectId
    @Persisted var timestamp: Date = Date.now
    @Persisted var reason: String
    
    convenience init(bubbleID: ObjectId, userID: ObjectId, reason: String) {
        self.init()
        self.bubbleID = bubbleID
        self.userID = userID
        self.reason = reason
    }
}
