//
//  ReefQuestionSeen.swift
//  Reef
//
//  Created by Ira Einbinder on 1/22/23.
//

import Foundation
import RealmSwift

class ReefQuestionSeen : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id : ObjectId = ObjectId.generate();
    @Persisted var questionID: ObjectId
    @Persisted var userID : ObjectId
    @Persisted var timestamp: Date = Date.now
    
    convenience init(questionID: ObjectId, userID: ObjectId) {
        self.init()
        self.questionID = questionID
        self.userID = userID
    }
}
