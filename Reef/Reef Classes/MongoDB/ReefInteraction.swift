//
//  ReefInteraction.swift
//  Reef
//
//  Created by Ira Einbinder on 1/25/22.
//

import Foundation
import RealmSwift

class ReefInteraction : Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var userID: ObjectId = ObjectId.generate()
    @Persisted var interactedWithUserID: ObjectId = ObjectId.generate()
    @Persisted var interactedWithBubble: ObjectId = ObjectId.generate()
    @Persisted var interactionType: String = "" //interaction can be a like, dislike
    @Persisted var dateAdded: Date = Date.now
    
    convenience init(userID: ObjectId, interactedWithUserID: ObjectId, interactedWithBubble: ObjectId, interactionType: String) {
        self.init()
        self.userID = userID
        self.interactedWithUserID = interactedWithUserID
        self.interactedWithBubble = interactedWithBubble
        self.interactionType = interactionType
    }
    
}
