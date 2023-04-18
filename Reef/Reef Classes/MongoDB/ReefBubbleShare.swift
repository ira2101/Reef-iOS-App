//
//  ReefBubbleShare.swift
//  Reef
//
//  Created by Ira Einbinder on 1/25/23.
//

import Foundation
import RealmSwift

class ReefBubbleShare : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id : ObjectId = ObjectId.generate();
    @Persisted var bubbleID: ObjectId
    @Persisted var userID : ObjectId
    @Persisted var timestamp: Date = Date.now
    
    convenience init(bubbleID: ObjectId, userID: ObjectId) {
        self.init()
        self.bubbleID = bubbleID
        self.userID = userID
    }
}
